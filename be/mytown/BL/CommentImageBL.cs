using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;

namespace mytown.BL
{
    public class CommentImageBL : ICommentImageBL
    {
        private readonly ICommentImageDAL _iCommentImageDAL;
        private readonly IWebHostEnvironment _environment;

        public CommentImageBL(ICommentImageDAL iCommentImageDAL, IWebHostEnvironment enviroment)
        {
            _iCommentImageDAL = iCommentImageDAL;
            _environment = enviroment;
        }

        public bool DeleteCommentImages(int commentID, int postID)
        {
            var images = _iCommentImageDAL.GetAllCommentImages(commentID, postID).Result.Value;
            foreach (var image in images)
                File.Delete(_environment.WebRootPath + Path.Combine(image.Path, image.Name));
            return true;
        }

        public async Task<ActionResult<bool>> UploadCommentImages(IFormFile[] images, int commentID, int PostID, int typeID)
        {
            int subFolderID; //number of subFolder
            string subFolder; //name of subfolder with ID on the END

            if (images == null || images.Length == 0)
                return false;

            string folder = "/comment/";

            if (!Directory.Exists(_environment.WebRootPath + folder))
                Directory.CreateDirectory(_environment.WebRootPath + folder);

            foreach (IFormFile img in images) //foreach sent image
            {
                string imgext = Path.GetExtension(img.FileName);

                if (imgext == ".jpg" || imgext == ".png" || imgext == ".jpeg")
                {
                    CommentImage newImage = new CommentImage
                    {
                        CommentID = commentID,
                        PostID = PostID,
                        Path = folder, //+ subFolder,
                        Name = img.FileName
                    };

                    await _iCommentImageDAL.AddCommentImage(newImage);

                    subFolderID = newImage.Id / 3000 + 1;
                    subFolder = string.Format("{0:D4}", subFolderID) + "/";

                    await _iCommentImageDAL.UpdateImage(newImage.Id, imgext, folder + subFolder);

                    if (!Directory.Exists(_environment.WebRootPath + folder + subFolder))
                        Directory.CreateDirectory(_environment.WebRootPath + folder + subFolder);

                    using FileStream fileStream = System.IO.File.Create(_environment.WebRootPath + folder + subFolder + newImage.Id.ToString() + imgext);
                    await img.CopyToAsync(fileStream);
                    fileStream.Flush();
                }
                else
                    return false;
            }
            return true;
        }

        public async Task<ActionResult<bool>> UploadInstitutionCommentImage(int commentID, int postID, string image)
        {
            try
            {
                string mainFolder = "/comment/";
                int subFolderID;
                string subFolderName;

                if (image == "" || image == null)
                    return null;
                if (!Directory.Exists(_environment.WebRootPath + mainFolder))
                    Directory.CreateDirectory(_environment.WebRootPath + mainFolder);

                CommentImage newImage = new CommentImage
                {
                    CommentID = commentID,
                    PostID = postID,
                    Path = mainFolder, //+ subFolder,
                    Name = "image"
                };

                await _iCommentImageDAL.AddCommentImage(newImage); //adds image to database table

                subFolderID = newImage.Id / 3000 + 1;
                subFolderName = string.Format("{0:D4}", subFolderID) + "/";

                await _iCommentImageDAL.UpdateImage(newImage.Id, ".jpg", mainFolder +subFolderName); //updates path and name after adding image to database

                if (!Directory.Exists(_environment.WebRootPath + mainFolder + subFolderName))
                    Directory.CreateDirectory(_environment.WebRootPath + mainFolder + subFolderName);
                    
                //adding to server
                byte[] bytes = Convert.FromBase64String(image);
                var path = mainFolder + subFolderName + newImage.Id.ToString() + ".jpg";
                var filePath = Path.Combine(_environment.WebRootPath + path);
                System.IO.File.WriteAllBytes(filePath, bytes);
                return true;
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
