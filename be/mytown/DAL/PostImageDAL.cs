using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class PostImageDAL : IPostImageDAL
    {
        private readonly AppDbContext _context;
        public PostImageDAL(AppDbContext context)
        {
            _context = context;
        }
        public async Task<ActionResult<bool>> AddImage(PostImage image)
        {
            _context.PostImage.Add(image);
            await _context.SaveChangesAsync();
            return true;
        }
        public async Task<ActionResult<List<PostImage>>> GetImagesByPostID(int id)
        {
            var images = await _context.PostImage.ToListAsync();

            var userImages = images.Where(i => i.PostID == id).ToList();

            return userImages;
        }
        public async Task<ActionResult<List<string>>> GetImagesURLByPostID(int id)
        {
            List<string> imagesURL = new List<string>();

            var dbImages = await _context.PostImage.ToListAsync();

            foreach (var image in dbImages.Where(i => i.PostID == id))
                imagesURL.Add(image.Path + "/" + image.Name);

            return imagesURL;
        }
        public async Task<ActionResult<bool>> UpdateImage(int imageID, string imgExt, string path)
        {
            var image = _context.PostImage.FindAsync(imageID);
            image.Result.Path = path;
            image.Result.Name = imageID.ToString() + imgExt;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
