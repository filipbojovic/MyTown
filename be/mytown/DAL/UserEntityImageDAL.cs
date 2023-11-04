using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class UserEntityImageDAL : IUserEntityImageDAL
    {
        private readonly AppDbContext _context;

        public UserEntityImageDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<bool>> AddUserProfilePhoto(UserEntityImage image, int userEntityID)
        {
            _context.UserEntityImage.Add(image);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<bool>> UpdateUserProfilePhoto(int userEntityID, string fileName)
        {
            var image = await _context.UserEntityImage
                .Where(i => i.UserEntityID == userEntityID)
                .FirstOrDefaultAsync();

            var user = await _context.User
                .FindAsync(userEntityID);

            if (image == null)
                return null;

            image.Name = fileName;
            user.ProfilePhotoID = image.Id;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<UserEntityImage>> GetEntityImageByUserEntityID(int userEntityID)
        {
            return await _context.UserEntityImage
                .Where(i => i.UserEntityID == userEntityID)
                .FirstOrDefaultAsync();
        }

        public async Task<ActionResult<bool>> DeleteUserProfilePhoto(int userEntityID, IWebHostEnvironment environment)
        {
            var photoToDelete = await _context.UserEntityImage
                .Where(i => i.UserEntityID == userEntityID)
                .FirstOrDefaultAsync();

            if (photoToDelete == null)
                return false;

            //delete from server directory
            File.Delete(environment.WebRootPath + Path.Combine(photoToDelete.Path, photoToDelete.Name));

            var user = await _context.User.FindAsync(userEntityID);
            if (user != null)
                user.ProfilePhotoID = null;
            else
            {
                var institution = _context.Institution.FindAsync(userEntityID);
                institution.Result.LogoID = null;
            }
            _context.UserEntityImage.Remove(photoToDelete);
            await _context.SaveChangesAsync();
            return true;
        }
        public async Task<ActionResult<bool>> UpdateImage(int imageID, string path, string ext, int userEntityID)
        {
            var image = _context.UserEntityImage.FindAsync(imageID);
            image.Result.Path = path;
            image.Result.Name = imageID.ToString() + ext;

            var user = _context.User.FindAsync(userEntityID).Result;
            if (user != null)
                user.ProfilePhotoID = imageID;
            else
            {
                var institution = _context.Institution.FindAsync(userEntityID).Result;
                institution.LogoID = imageID;
            }

            await _context.SaveChangesAsync();
            return true;
        }
    }
}
