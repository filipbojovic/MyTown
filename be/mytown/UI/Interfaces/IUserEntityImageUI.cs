using Microsoft.AspNetCore.Http;

namespace mytown.UI.Interfaces
{
    public interface IUserEntityImageUI
    {
        bool ChangeUserProfilePicture(IFormFile image, int userEntityID);
        bool DeleteUserProfilePhoto(int userEntityID);
        string ChangeInstitutionProfilePhoto(int userEntityID, string image);
    }
}
