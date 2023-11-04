using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface IInstitutionUI
    {
        List<Institution> getAllInstitutions();
        Institution InstitutionValidation(string email, string password);
        AppInstitution AddInstitution(Institution institution, string password);
        bool DeleteInstitution(int userEntityID);
        bool ChangePassword(int userEntityID, string oldPassword, string newPassword);
        bool ChangeData(int userEntityID, string name, int headquaterID, string address, string email, string phone);
        AppInstitution GetAppInstitution(int userEntityID);
        List<AppInstitution> GetAllAppInstitutions();
        List<AppInstitution> GetFilteredInstitutions(string filterText, int cityID);
    }
}
