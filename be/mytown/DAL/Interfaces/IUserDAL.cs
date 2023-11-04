using mytown.Models;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IUserDAL
    {
        Task<ActionResult<IEnumerable<User>>> GetAllUsers();
        Task<ActionResult<User>> AddUser(User user);
        Task<ActionResult<User>> GetUserByID(int id);
        Task<ActionResult<User>> UpdateUserInfo(UserVM userVM);
        Task<ActionResult<bool>> UpdateUserPassword(int userID, string oldPassword, string newPassword);
        Task<ActionResult<bool>> CheckUserExistance(int userID);
    }
}
