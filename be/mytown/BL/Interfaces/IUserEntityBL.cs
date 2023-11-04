using mytown.Models.DbModels;

namespace mytown.BL.Interfaces
{
    public interface IUserEntityBL
    {
        UserEntity AddUserEntity(UserEntity userEntity);
        bool DeleteUserEntity(int userEntityID);
        bool GenerateUserPassword(string email, int userTypeID);
    }
}
