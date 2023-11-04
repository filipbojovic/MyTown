using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface IAdministratorBL
    {
        Administrator AdministratorValidation(string username, string password);
        Administrator AddAdministrator(string email, string username, string password);
        List<Administrator> GetAllAdministrators();
        bool DeleteAdministrator(int userEntityID);
        AdministratorStats GetStatisticForDashboard();
        Administrator GetAdministratorByID(int adminID);
        List<Administrator> GetFilteredAdministrators(string filterText);
        bool ChangePassword(int adminID, string oldPassword, string newPassword);
    }
}
