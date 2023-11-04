using mytown.BL.Interfaces;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;

namespace mytown.UI
{
    public class UserEntityUI : IUserEntityUI
    {
        private readonly IUserEntityBL _iUserEntityBL;

        public UserEntityUI(IUserEntityBL iUserEntityBL)
        {
            _iUserEntityBL = iUserEntityBL;
        }

        public UserEntity AddUserEntity(UserEntity userEntity)
        {
            return _iUserEntityBL.AddUserEntity(userEntity);
        }

        public bool DeleteUserEntity(int userEntityID)
        {
            return _iUserEntityBL.DeleteUserEntity(userEntityID);
        }

        public bool GenerateUserPassword(string email, int userTypeID)
        {
            return _iUserEntityBL.GenerateUserPassword(email, userTypeID);
        }
    }
}
