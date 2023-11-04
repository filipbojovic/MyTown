using mytown.Models.DbModels;

namespace mytown.UI.Interfaces
{
    public interface IUserEntityUI
    {
        UserEntity AddUserEntity(UserEntity userEntity);
        bool DeleteUserEntity(int userEntityID);
        bool GenerateUserPassword(string email, int userTypeID);
    }
}
