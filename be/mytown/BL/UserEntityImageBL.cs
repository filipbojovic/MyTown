using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using System;
using System.IO;
using System.Threading.Tasks;

namespace mytown.BL
{
    public class UserEntityImageBL : IUserEntityImageBL
    {
        private readonly IUserEntityImageDAL _iUserEntityImageDAL;
        private readonly IWebHostEnvironment _environment;

        public UserEntityImageBL(IUserEntityImageDAL iUserEntityImageDAL, IWebHostEnvironment environment)
        {
            _iUserEntityImageDAL = iUserEntityImageDAL;
            _environment = environment;
        }

        public async Task<string> ChangeInstitutionProfilePhoto(int userEntityID, string image)
        {
            var userEntityImage = _iUserEntityImageDAL.GetEntityImageByUserEntityID(userEntityID).Result.Value;
            if (image == "" || image == null)
                return null;
            if (userEntityImage != null)
            {
                File.Delete(_environment.WebRootPath + Path.Combine(userEntityImage.Path, userEntityImage.Name));

                byte[] bytes = Convert.FromBase64String(image);
                var path = userEntityImage.Path + userEntityImage.Id.ToString() + ".jpg";
                var filePath = Path.Combine(_environment.WebRootPath + path);
                System.IO.File.WriteAllBytes(filePath, bytes);
                return path;
            }
            else
            {
                try
                {
                    string mainFolder = "/user/";
                    int subFolderID;
                    string subFolderName;

                    if (image == "" || image == null)
                        return null;
                    if (!Directory.Exists(_environment.WebRootPath + mainFolder))
                        Directory.CreateDirectory(_environment.WebRootPath + mainFolder);

                    UserEntityImage profileImage = new UserEntityImage
                    {
                        Path = mainFolder, //+ subFolderName,
                        Name = "image",
                        UserEntityID = userEntityID
                    };

                    await _iUserEntityImageDAL.AddUserProfilePhoto(profileImage, userEntityID);

                    subFolderID = profileImage.Id / 3000 + 1;
                    subFolderName = string.Format("{0:D4}", subFolderID) + "/";

                    await _iUserEntityImageDAL.UpdateImage(profileImage.Id, mainFolder + subFolderName, ".jpg", userEntityID);

                    if (!Directory.Exists(_environment.WebRootPath + mainFolder + subFolderName))
                        Directory.CreateDirectory(_environment.WebRootPath + mainFolder + subFolderName);

                    byte[] bytes = Convert.FromBase64String(image);
                    var path = mainFolder + subFolderName + profileImage.Id.ToString() + ".jpg";
                    var filePath = Path.Combine(_environment.WebRootPath + path);
                    System.IO.File.WriteAllBytes(filePath, bytes);
                    return path;
                }
                catch (Exception e)
                {
                    throw e;
                }
            }

        }

        public async Task<bool> ChangeUserProfilePicture(IFormFile image, int userEntityID)
        {
            string imgext = Path.GetExtension(image.FileName);
            if (imgext != ".jpg" && imgext != ".png" && imgext != ".jpeg")
                return false;
            //first need to check if this user already has profile picture
            var userEntityImage = _iUserEntityImageDAL.GetEntityImageByUserEntityID(userEntityID).Result.Value;

            if (userEntityImage != null) //user already has a picture
            {
                //delete old photo from server storage
                File.Delete(_environment.WebRootPath + Path.Combine(userEntityImage.Path, userEntityImage.Name));
                //add new photo from server storage
                using FileStream fileStream = System.IO.File.Create(_environment.WebRootPath + Path.Combine(userEntityImage.Path, image.FileName));
                await image.CopyToAsync(fileStream);
                fileStream.Flush();
                //update userentityTable
                await _iUserEntityImageDAL.UpdateUserProfilePhoto(userEntityID, image.FileName);
                return true;
            }
            else //add profile picture for this user
            {
                //first we need to add it on the server, then in the main table for storing images and last, in the userEntityImage table
                string mainFolder = "/user/";
                int subFolderID;
                string subFolderName;

                if (image == null)
                    return false;
                if (!Directory.Exists(_environment.WebRootPath + mainFolder))
                    Directory.CreateDirectory(_environment.WebRootPath + mainFolder);

                UserEntityImage profileImage = new UserEntityImage
                {
                    Path = mainFolder, //+ subFolderName,
                    Name = image.FileName,
                    UserEntityID = userEntityID
                };

                await _iUserEntityImageDAL.AddUserProfilePhoto(profileImage, userEntityID);

                subFolderID = profileImage.Id / 3000 + 1;
                subFolderName = string.Format("{0:D4}", subFolderID) + "/";

                await _iUserEntityImageDAL.UpdateImage(profileImage.Id, mainFolder + subFolderName, imgext, userEntityID);

                if (!Directory.Exists(_environment.WebRootPath + mainFolder + subFolderName))
                    Directory.CreateDirectory(_environment.WebRootPath + mainFolder + subFolderName);

                using FileStream fileStream = System.IO.File.Create(_environment.WebRootPath + mainFolder + subFolderName + profileImage.Id.ToString() + imgext);
                await image.CopyToAsync(fileStream);
                fileStream.Flush();

                return true;
            }
        }
        public bool DeleteUserProfilePhoto(int userEntityID)
        {
            return _iUserEntityImageDAL.DeleteUserProfilePhoto(userEntityID, _environment).Result.Value;
        }
    }
}
