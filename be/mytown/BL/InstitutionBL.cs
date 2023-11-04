using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class InstitutionBL : IInstitutionBL
    {
        private readonly IInstitutionDAL _iInstitutionDAL;
        private readonly IPostDAL _iPostDAL;
        private readonly IUserEntityBL _iUserEntityBL;
        private readonly IAdministratorDAL _iAdministratorDAL;
        private readonly IUserBL _iUserBL;
        public InstitutionBL(IInstitutionDAL iInstitutionDAL, IPostDAL iPostDAL, IUserEntityBL iUserEntityBL, IAdministratorDAL iAdministratorDAL, IUserBL iUserBL)
        {
            _iInstitutionDAL = iInstitutionDAL;
            _iPostDAL = iPostDAL;
            _iUserEntityBL = iUserEntityBL;
            _iAdministratorDAL = iAdministratorDAL;
            _iUserBL = iUserBL;
        }

        public AppInstitution AddInstitution(Institution institution, string password)
        {
            var institutions = _iInstitutionDAL.getAllInstitutions().Result.Value;
            var admins = _iAdministratorDAL.GetAllAdministrators().Result.Value;
            var users = _iUserBL.GetAllUsers();

            var check = institutions
                .Where(i => i.Email.Equals(institution.Email)).FirstOrDefault();
            var check2 = admins
                .Where(a => a.Email.Equals(institution.Email)).FirstOrDefault();
            var check3 = users
                .Where(u => u.Email.Equals(institution.Email)).FirstOrDefault();

            if (check == null && check2 == null && check3 == null)
            {
                var ue = new UserEntity
                {
                    UserTypeID = (int)Enums.UserType.INSTITUTION
                };
                _iUserEntityBL.AddUserEntity(ue);
                institution.Id = ue.Id;
                institution.Password = SHA256.CreateSHA256Hash(password);

                var res = _iInstitutionDAL.AddInstitution(institution).Result.Value;

                if (res != null)
                    return GetAppInstitution(res.Id);
                else
                    return null;
            }
            else
                return null;
        }

        public bool ChangeData(int userEntityID, string name, int headquaterID, string address, string email, string phone)
        {
            return _iInstitutionDAL.ChangeData(userEntityID, name, headquaterID, address, email, phone).Result.Value;
        }

        public bool ChangePassword(int userEntityID, string oldPassword, string newPassword)
        {
            return _iInstitutionDAL.ChangePassword(userEntityID, oldPassword, newPassword).Result.Value;
        }

        public bool DeleteInstitution(int userEntityID)
        {
            return _iInstitutionDAL.DeleteInstitution(userEntityID).Result.Value;
        }

        public List<AppInstitution> GetAllAppInstitutions()
        {
            var institutions = getAllInstitutions();

            List<AppInstitution> list = new List<AppInstitution>();

            foreach (var item in institutions)
                list.Add(GetAppInstitution(item.Id));
            return list;
        }

        public List<Institution> getAllInstitutions()
        {
            var list = _iInstitutionDAL.getAllInstitutions().Result.Value;
            return list;
        }

        public AppInstitution GetAppInstitution(int userEntityID)
        {
            var item = _iInstitutionDAL.GetInstitutionByID(userEntityID).Result.Value;

            if (item == null)
                return null;

            AppInstitution ai = new AppInstitution
            {
                Id = item.Id,
                Address = item.Address,
                Email = item.Email,
                HeadquaterID = item.HeadquaterID,
                HeadquaterName = item.City.Name,
                Name = item.Name,
                ImageURL = item.Logo != null ? item.Logo.Path + item.Logo.Name : Enums.defaultProfilePhotoURL,
                JoinDate = item.JoinDate,
                Phone = item.Phone,
                NumOfPosts = _iPostDAL.GetAllDbPosts()
                    .Result
                    .Value
                    .Where(p => p.UserEntityID == item.Id)
                    .Count()
            };
            return ai;
        }

        public List<AppInstitution> GetFilteredInstitutions(string filterText, int cityID)
        {
            var institutions = _iInstitutionDAL.getAllInstitutions().Result.Value;

            if (cityID != -1)
                institutions = institutions
                    .Where(i => i.HeadquaterID == cityID)
                    .ToList();

            if (filterText != null)
                institutions = institutions
                    .Where(i => i.Name.ToLower().Contains(filterText.ToLower()))
                    .ToList();

            List<AppInstitution> list = new List<AppInstitution>();

            foreach (var item in institutions)
                list.Add(GetAppInstitution(item.Id));
            return list;
        }

        public Institution InstitutionValidation(string email, string password)
        {
            var users = _iInstitutionDAL.getAllInstitutions().Result.Value;

            var user = users
                .Where(u => u.Email.Equals(email)).FirstOrDefault();

            if (user != null)
            {
                var res = SHA256.Verify256SHA(password, user.Password);
                if (res)
                    return user;
                else
                    return null;
            }
            else
                return null;
        }
    }
}
