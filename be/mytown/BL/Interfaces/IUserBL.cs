using mytown.Models;
using mytown.Models.AppModels;
using mytown.Models.ViewModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface IUserBL
    {
        List<User> GetAllUsers();
        User LoginValidation(string email, string password);
        User AddUser(User user, string password);
        User GetUserByID(int id);
        AppUser GetAppUserByID(int id);
        AppUser UpdateUserInfo(UserVM userVM);
        bool UpdateUserPassword(int userID, string oldPassword, string newPassword);
        List<AppUser> GetAllAppUsers();
        int CalculateEcoFPoints(int userID);
        UserStats GetUserStatsByUserID(int userID);
        List<UserStats> GetAllUsersWithStats();
        List<TopUser> GetTop10UsersByEcoFPoints();
        List<AppUser> GetFilteredUsersAdminPage(string filterText, int cityID);
        bool CheckUserExistance(int userID);
    }
}
