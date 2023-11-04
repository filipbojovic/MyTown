using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IInstitutionDAL
    {
        Task<ActionResult<List<Institution>>> getAllInstitutions();
        Task<ActionResult<Institution>> AddInstitution(Institution institution);
        Task<ActionResult<bool>> DeleteInstitution(int userEntityID);
        Task<ActionResult<bool>> ChangePassword(int userEntityID, string oldPassword, string newPassword);
        Task<ActionResult<bool>> ChangeData(int userEntityID, string name, int headquaterID, string address, string email, string phone);
        Task<ActionResult<Institution>> GetInstitutionByID(int userEntityID);
    }
}
