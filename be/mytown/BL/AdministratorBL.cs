using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class AdministratorBL : IAdministratorBL
    {
        private readonly IAdministratorDAL _iAdministratorDAL;
        private readonly IUserEntityBL _iUserEntityBL;
        private readonly IUserBL _iUserBL;
        private readonly ICityBL _iCityBL;
        private readonly IPostBL _iPostBL;
        private readonly ICategoryBL _iCategoryBL;
        private readonly IPostTypeBL _iPostTypeBL;
        private readonly IInstitutionDAL _iInstitutionDAL;
        public AdministratorBL(IAdministratorDAL iAdministratorDAL, IUserEntityBL iUserEntityBL, IUserBL iUserBL, ICityBL iCityBL, IPostBL iPostBL, ICategoryBL iCategoryBL, IPostTypeBL iPostTypeBL, IInstitutionDAL iInstitutionDAL)
        {
            _iAdministratorDAL = iAdministratorDAL;
            _iUserEntityBL = iUserEntityBL;
            _iUserBL = iUserBL;
            _iCityBL = iCityBL;
            _iPostBL = iPostBL;
            _iCategoryBL = iCategoryBL;
            _iPostTypeBL = iPostTypeBL;
            _iInstitutionDAL = iInstitutionDAL;
        }

        public Administrator AddAdministrator(string email, string username, string password)
        {
            var institutions = _iInstitutionDAL.getAllInstitutions().Result.Value;
            var admins = _iAdministratorDAL.GetAllAdministrators().Result.Value;
            var users = _iUserBL.GetAllUsers();
            var check = institutions
                .Where(i => i.Email.Equals(email)).FirstOrDefault();
            var check2 = admins
                .Where(a => a.Email.Equals(email)).FirstOrDefault();
            var check3 = users
                .Where(u => u.Email.Equals(email)).FirstOrDefault();

            if (check == null && check2 == null && check3 == null)
            {
                var ue = new UserEntity
                {
                    UserTypeID = (int)Enums.UserType.INSTITUTION
                };
                _iUserEntityBL.AddUserEntity(ue);

                Administrator administrator = new Administrator
                {
                    Id = ue.Id,
                    Email = email,
                    Username = username,
                    JoinDate = DateTime.Now,
                    Password = SHA256.CreateSHA256Hash(password),
                    Head = false
                };

                _iAdministratorDAL.AddAdministrator(administrator);
                return administrator;
            }
            else
            {
                return null;
            }
        }

        public Administrator AdministratorValidation(string username, string password)
        {
            var users = _iAdministratorDAL.GetAllAdministrators().Result.Value;

            var user = users
                .Where(u => u.Email.Equals(username) || u.Username.Equals(username))
                .FirstOrDefault();

            if (user == null)
                return null;
            
            var res = SHA256.Verify256SHA(password, user.Password);
            if (res)
                return user;
            else
                return null;
        }

        public bool ChangePassword(int adminID, string oldPassword, string newPassword)
        {
            return _iAdministratorDAL.ChangePassword(adminID, oldPassword, newPassword).Result.Value;
        }

        public bool DeleteAdministrator(int userEntityID)
        {
            return _iAdministratorDAL.DeleteAdministrator(userEntityID).Result.Value;
        }

        public Administrator GetAdministratorByID(int adminID)
        {
            return _iAdministratorDAL.GetAdministratorByID(adminID).Result.Value;
        }

        public List<Administrator> GetAllAdministrators()
        {
            return _iAdministratorDAL.GetAllAdministrators().Result.Value;
        }

        public List<Administrator> GetFilteredAdministrators(string filterText)
        {
            var admins = _iAdministratorDAL.GetAllAdministrators().Result.Value;

            if (filterText != null)
            {
                return admins
                    .Where(a => a.Username.ToLower().Contains(filterText.ToLower()))
                    .ToList();
            }
            else
            {
                return admins;
            }
        }

        public AdministratorStats GetStatisticForDashboard()
        {
            AdministratorStats stats = new AdministratorStats();
            var posts = _iPostBL.GetAllDbPosts().Result.Value;

            stats.NumberOfPosts = posts.Count();
            stats.NumberOfChallenges = posts
                .Where(p => p.TypeID == (int)Enums.PostEntityType.CHALLENGE)
                .Count();
            stats.NumberOfUsers = _iUserBL.GetAllUsers().Count();
            stats.Users = _iUserBL.GetAllUsersWithStats();
            stats.Cities = _iCityBL.GetAllCitiesStats();
            stats.Categories = _iCategoryBL.GetAllCategoryStats();
            stats.Types = _iPostTypeBL.GetPostTypeStats();

            return stats;
        }
    }
}
