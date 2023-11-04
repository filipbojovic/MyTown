using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class PostLikeDAL : IPostLikeDAL
    {
        private readonly AppDbContext _context;
        private readonly INotificationBL _iNotificationBL;

        public PostLikeDAL(AppDbContext context, INotificationBL iNotificationBL)
        {
            _context = context;
            _iNotificationBL = iNotificationBL;
        }

        public async Task<ActionResult<int>> AddPostLike(PostLike like)
        {
            var post = await _context.Post.FindAsync(like.PostID);
            if (post == null)
                return -1;

            _context.PostLike.Add(like);
            await _context.SaveChangesAsync();
            return _context.PostLike.Where(e => e.PostID == like.PostID).Count();
        }

        public async Task<ActionResult<int>> DeletePostLike(int postID, int userID)
        {
            var entityLike = await _context.PostLike.FindAsync(postID, userID);
            if (entityLike == null)
                return -1;

            var post = await _context.Post.FindAsync(postID);
            if (post == null)
                return -1;

            _context.PostLike.Remove(entityLike);
            await _context.SaveChangesAsync();

            _iNotificationBL.DeletePostNotification(postID, userID, (int)Enums.NotificationType.POST_LIKE);

            return _context.PostLike.Where(e => e.PostID == postID).Count();
        }

        public async Task<ActionResult<List<PostLike>>> GetLikesByPostID(int postID)
        {
            return await _context.PostLike.Include(e => e.User).Where(e => e.PostID == postID).ToListAsync();
        }
    }
}
