using mytown.Models.DbModels;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IUserEntityImageDAL
    {
        Task<ActionResult<bool>> AddUserProfilePhoto(UserEntityImage image, int userEntityID);
        Task<ActionResult<bool>> UpdateUserProfilePhoto(int userEntityID, string fileName);
        Task<ActionResult<UserEntityImage>> GetEntityImageByUserEntityID(int userEntityID);
        Task<ActionResult<bool>> DeleteUserProfilePhoto(int userEntityID, IWebHostEnvironment environment);
        Task<ActionResult<bool>> UpdateImage(int imageID, string path, string ext, int userEntityID);
    }
}
