using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class UserBL : IUserBL
    {
        private readonly IUserDAL _iUserDAL;
        private readonly IUserEntityDAL _iUserEntityDAL;
        private readonly INotificationBL _iNotificationBL;
        private readonly ICommentBL _iCommentBL;
        private readonly IRankBL _iRankBL;
        private readonly IPostDAL _iPostDAL;
        private readonly IInstitutionDAL _iInstitutionDAL;
        private readonly IAdministratorDAL _iAdministratorDAL;
        private readonly IAcceptedChallengeBL _iAcceptedChallengeBL;
        public UserBL(IUserDAL iUserDAL, IUserEntityDAL iUserEntityDAL, INotificationBL iNotificationBL, ICommentBL iCommentBL, IRankBL iRankBL, IPostDAL iPostDAL,
            IInstitutionDAL iInstitutionDAL, IAdministratorDAL iAdministratorDAL, IAcceptedChallengeBL iAcceptedChallengeBL)
        {
            _iUserDAL = iUserDAL;
            _iUserEntityDAL = iUserEntityDAL;
            _iNotificationBL = iNotificationBL;
            _iCommentBL = iCommentBL;
            _iRankBL = iRankBL;
            _iPostDAL = iPostDAL;
            _iInstitutionDAL = iInstitutionDAL;
            _iAdministratorDAL = iAdministratorDAL;
            _iAcceptedChallengeBL = iAcceptedChallengeBL;
        }

        public List<User> GetAllUsers()
        {
            return _iUserDAL.GetAllUsers().Result.Value.ToList();
        }
        public User LoginValidation(string email, string password)
        {
            var listOfUsers = _iUserDAL.GetAllUsers();

            var user = listOfUsers.Result.Value.Where(u => u.Email.Equals(email)).FirstOrDefault();

            if (user != null)
                if (SHA256.Verify256SHA(password, user.Password))
                    return user;

            return null;
        }
        public User AddUser(User user, string password)
        {
            var users = _iUserDAL.GetAllUsers().Result.Value;

            var check = users
                .Where(u => u.Email.Equals(user.Email))
                .FirstOrDefault();

            if (check != null)
                return null;

            user.Password = SHA256.CreateSHA256Hash(password);
            UserEntity ue = new UserEntity { UserTypeID = (int)Enums.UserType.USER };
            _iUserEntityDAL.AddUserEntity(ue);
            user.Id = ue.Id;
            _iUserDAL.AddUser(user);
            return user;
        }

        public User GetUserByID(int id)
        {
            return _iUserDAL.GetUserByID(id).Result.Value;
        }

        public AppUser GetAppUserByID(int id)
        {
            User dbUser = this.GetUserByID(id);
            int userPoints = CalculateEcoFPoints(id);
            Rank rank = _iRankBL.GetRankForGivenPoints(userPoints);
            AppUser appUser = new AppUser
            {
                Id = dbUser.Id,
                FirstName = dbUser.FirstName,
                LastName = dbUser.LastName,
                City = dbUser.City.Name,
                CityID = dbUser.City.Id,
                EcoFPoints = userPoints,
                Email = dbUser.Email,
                JoinDate = dbUser.JoinDate,
                NumOfPosts = _iPostDAL.GetPostsByUserID(dbUser.Id).Result.Value.Count(),
                BirthDay = dbUser.BirthDay,
                GenderID = dbUser.GenderID,
                NumOfAcceptedChallenges = _iAcceptedChallengeBL.GetAcceptedChallengesByUserID(dbUser.Id)
                    .Where(ac => ac.Status == (int)Enums.ChallengeStatus.NOT_SOLVED_YET)
                    .Count(),
                NumOfSolvedChallenges = _iAcceptedChallengeBL.GetAcceptedChallengesByUserID(dbUser.Id)
                    .Where(ac => ac.Status == (int)Enums.ChallengeStatus.SOLVED)
                    .Count(),
                ProfilePhotoURL = dbUser.ProfilePhoto == null ? Enums.defaultProfilePhotoURL.ToString() : dbUser.ProfilePhoto.Path + dbUser.ProfilePhoto.Name,
                UnreadNotification = _iNotificationBL.CheckUnreadNotification(dbUser.Id),
                RankPhotoURL = rank.Path + rank.FileName,
                RankName = rank.Name
            };

            return appUser;
        }

        public AppUser UpdateUserInfo(UserVM userVM)
        {
            var users = _iUserDAL.GetAllUsers().Result.Value;
            var admins = _iAdministratorDAL.GetAllAdministrators().Result.Value;
            var institutions = _iInstitutionDAL.getAllInstitutions().Result.Value;

            if (users.Where(u => u.Email.ToLower().Equals(userVM.Email.ToLower()) && u.Id != userVM.Id).FirstOrDefault() != null
                || admins.Where(a => a.Email.ToLower().Equals(userVM.Email.ToLower())).FirstOrDefault() != null
                    || institutions.Where(i => i.Email.ToLower().Equals(userVM.Email.ToLower())).FirstOrDefault() != null)
                return null;

            return GetAppUserByID(_iUserDAL.UpdateUserInfo(userVM).Result.Value.Id);
        }

        public bool UpdateUserPassword(int userID, string oldPassword, string newPassword)
        {
            return _iUserDAL.UpdateUserPassword(userID, oldPassword, newPassword).Result.Value;
        }

        public List<AppUser> GetAllAppUsers()
        {
            List<AppUser> appUserList = new List<AppUser>();
            var dbUsers = _iUserDAL.GetAllUsers();

            foreach (var user in dbUsers.Result.Value)
                appUserList.Add(this.GetAppUserByID(user.Id));
            return appUserList;
        }

        public int CalculateEcoFPoints(int userID)
        {
            var userProposals = _iCommentBL.GetProposalsByUserID(userID);

            var userPosts = _iPostDAL.GetPostsByUserID(userID)
                .Result
                .Value
                .Where(p => p.TypeID == (int)Enums.PostEntityType.CHALLENGE)
                .ToList();
            int points = 0;

            foreach (var post in userPosts)
            {
                points += post.Likess.Count();
                if (post.Likess != null && post.Likess.Where(l => l.UserID == userID).FirstOrDefault() != null)
                    points -= 1;
            }
            foreach (var proposal in userProposals)
            {
                points += proposal.Likes.Count();
                if (proposal.Likes != null && proposal.Likes.Where(l => l.UserEntityID == userID).FirstOrDefault() != null)
                    points -= 1;
            }

            //substract points cause giving up from challenge
            points -= _iAcceptedChallengeBL.GetWithdrawalNumber(userID) * Enums.withdrawalPoints;
            return points;
        }

        public UserStats GetUserStatsByUserID(int userID)
        {
            var appUser = GetAppUserByID(userID);
            UserStats userStats = new UserStats
            {
                Id = appUser.Id,
                BithDate = appUser.BirthDay,
                FirstName = appUser.FirstName,
                LastName = appUser.LastName,
                GenderID = appUser.GenderID,
                JoinDate = (DateTime)appUser.JoinDate,
                NumOfEcoFPoints = appUser.EcoFPoints
            };

            return userStats;
        }

        public List<UserStats> GetAllUsersWithStats()
        {
            var dbUsers = GetAllUsers();
            List<UserStats> list = new List<UserStats>();
            foreach (var item in dbUsers)
                list.Add(GetUserStatsByUserID(item.Id));
            return list;
        }

        public List<TopUser> GetTop10UsersByEcoFPoints()
        {
            var users = GetAllAppUsers();

            var top10 = users
                .OrderByDescending(u => u.EcoFPoints)
                .Take(10)
                .ToList();

            List<TopUser> list = new List<TopUser>();

            foreach (var item in top10)
                list.Add(new TopUser
                {
                    Id = item.Id,
                    photoURL = item.ProfilePhotoURL,
                    points = item.EcoFPoints,
                    FullName = item.FirstName + " " + item.LastName
                });
            return list;
        }

        public List<AppUser> GetFilteredUsersAdminPage(string filterText, int cityID)
        {
            var users = _iUserDAL.GetAllUsers().Result.Value;

            if (cityID != -1)
                users = users
                    .Where(u => u.CityID == cityID)
                    .ToList();

            if (filterText != null)
                users = users
                    .Where(u => (u.FirstName + " " + u.LastName).ToLower().Contains(filterText.ToLower()))
                    .ToList();

            List<AppUser> list = new List<AppUser>();
            foreach (var item in users)
                list.Add(GetAppUserByID(item.Id));
            return list;
        }

        public bool CheckUserExistance(int userID)
        {
            return _iUserDAL.CheckUserExistance(userID).Result.Value;
        }
    }
}
