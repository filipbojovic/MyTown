using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IAdministratorDAL
    {
        Task<ActionResult<List<Administrator>>> getAllAdministrators();
        Task<ActionResult<Administrator>> AdministratorValidation(string username, string password);
        Task<ActionResult<bool>> AddAdministrator(Administrator administrator);
        Task<ActionResult<List<Administrator>>> GetAllAdministrators();
        Task<ActionResult<bool>> DeleteAdministrator(int userEntityID);
        Task<ActionResult<Administrator>> GetAdministratorByID(int adminID);
        Task<ActionResult<bool>> ChangePassword(int adminID, string oldPassword, string newPassword);
    }
}
