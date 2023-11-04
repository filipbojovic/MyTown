using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;

namespace mytown.BL.Interfaces
{
    public interface IUserEntityImageBL
    {
        Task<bool> ChangeUserProfilePicture(IFormFile image, int userEntityID);
        bool DeleteUserProfilePhoto(int userEntityID);
        Task<string> ChangeInstitutionProfilePhoto(int userEntityID, string image);
    }
}
