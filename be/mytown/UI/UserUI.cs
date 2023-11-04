using mytown.BL.Interfaces;
using mytown.Models;
using mytown.Models.AppModels;
using mytown.Models.ViewModels;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class UserUI : IUserUI
    {
        private readonly IUserBL _iUserBL;

        public UserUI(IUserBL iUserBL)
        {
            _iUserBL = iUserBL;
        }
        public User AddUser(User user, string password)
        {
            return _iUserBL.AddUser(user, password);
        }

        public List<User> GetAllUsers()
        {
            return _iUserBL.GetAllUsers();
        }

        public User GetUserByID(int id)
        {
            return _iUserBL.GetUserByID(id);
        }
        public User LoginValidation(string email, string password)
        {
            return _iUserBL.LoginValidation(email, password);
        }
        public AppUser GetAppUserByID(int id)
        {
            return _iUserBL.GetAppUserByID(id);
        }

        public AppUser UpdateUserInfo(UserVM userVM)
        {
            return _iUserBL.UpdateUserInfo(userVM);
        }

        public bool UpdateUserPassword(int userID, string oldPassword, string newPassword)
        {
            return _iUserBL.UpdateUserPassword(userID, oldPassword, newPassword);
        }

        public List<AppUser> GetAllAppUsers()
        {
            return _iUserBL.GetAllAppUsers();
        }

        public List<TopUser> GetTop10UsersByEcoFPoints()
        {
            return _iUserBL.GetTop10UsersByEcoFPoints();
        }

        public List<AppUser> GetFilteredUsersAdminPage(string filterText, int cityID)
        {
            return _iUserBL.GetFilteredUsersAdminPage(filterText, cityID);
        }

        public bool CheckUserExistance(int userID)
        {
            return _iUserBL.CheckUserExistance(userID);
        }
    }
}
