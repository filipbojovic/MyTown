using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IUserEntityDAL
    {
        Task<ActionResult<UserEntity>> AddUserEntity(UserEntity userEntity);
        Task<ActionResult<bool>> DeleteUserEntity(int userEntityID);
        Task<ActionResult<UserEntity>> GetUserEntityByID(int userEntityID);
        Task<ActionResult<bool>> GenerateUserPassword(string email, int userTypeID);
    }
}
