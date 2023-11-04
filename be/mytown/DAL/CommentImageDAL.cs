using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class CommentImageDAL : ICommentImageDAL
    {
        private readonly AppDbContext _context;

        public CommentImageDAL(AppDbContext context)
        {
            _context = context;
        }
        public async Task<ActionResult<CommentImage>> AddCommentImage(CommentImage image)
        {
            try
            {
                _context.CommentImage.Add(image);
                await _context.SaveChangesAsync();

                return image;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public async Task<ActionResult<List<CommentImage>>> GetAllCommentImages(int commentID, int postID)
        {
            return await _context.CommentImage.Where(ci => ci.CommentID == commentID && ci.PostID == postID).ToListAsync();
        }

        public async Task<ActionResult<bool>> UpdateImage(int imageID, string imgExt, string path)
        {
            var image = _context.CommentImage.FindAsync(imageID);
            image.Result.Path = path;
            image.Result.Name = imageID.ToString() + imgExt;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
