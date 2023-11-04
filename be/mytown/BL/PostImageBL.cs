using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace mytown.BL
{
    public class PostImageBL : IPostImageBL
    {
        private readonly IPostImageDAL _iPostImageDAL;
        private readonly IWebHostEnvironment _environment;

        public PostImageBL(IPostImageDAL iPostImageDAL, IWebHostEnvironment enviroment)
        {
            _environment = enviroment;
            _iPostImageDAL = iPostImageDAL;
        }
        public void addImage(PostImage image)
        {
            _iPostImageDAL.AddImage(image);
        }
        public List<PostImage> getImagesByPostID(int id)
        {
            return _iPostImageDAL.GetImagesByPostID(id).Result.Value;
        }

        public async Task<ActionResult<bool>> UploadImages(IFormFile[] images, int PostID)
        {
            int subFolderID; //number of subFolder
            string subFolder; //name of subfolder with ID on the END

            if (images == null || images.Length == 0)
                return false;

            string folder = "/post/";

            if (!Directory.Exists(_environment.WebRootPath + folder))
                Directory.CreateDirectory(_environment.WebRootPath + folder);

            foreach (IFormFile img in images) //foreach sent image
            {
                string imgext = Path.GetExtension(img.FileName);
                //maxID = _context.Image.Count() > 0 ? _context.Image.Max(i => i.Id) + 1 : 1;

                if (imgext == ".jpg" || imgext == ".png" || imgext == ".jpeg")
                {
                    PostImage newImage = new PostImage
                    {
                        PostID = PostID,
                        Path = folder, // + subFolder,
                        Name = img.FileName
                    };

                    await _iPostImageDAL.AddImage(newImage);    

                    subFolderID = newImage.Id / 3000 + 1;
                    subFolder = string.Format("{0:D4}", subFolderID) + "/";

                    await _iPostImageDAL.UpdateImage(newImage.Id, imgext, folder + subFolder);

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

        public async Task<ActionResult<bool>> UploadInstitutionPostImage(int postID, string image)
        {
            try
            {
                string mainFolder = "/post/";
                int subFolderID;
                string subFolderName;

                if (image == "" || image == null)
                    return null;
                if (!Directory.Exists(_environment.WebRootPath + mainFolder))
                    Directory.CreateDirectory(_environment.WebRootPath + mainFolder);

                PostImage newImage = new PostImage
                {
                    PostID = postID,
                    Path = mainFolder, // + subFolder,
                    Name = "name"
                };

                await _iPostImageDAL.AddImage(newImage); //adds image to database table

                subFolderID = newImage.Id / 3000 + 1;
                subFolderName = string.Format("{0:D4}", subFolderID) + "/";

                await _iPostImageDAL.UpdateImage(newImage.Id, ".jpg", mainFolder + subFolderName); //updates path and name after adding image to database

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
