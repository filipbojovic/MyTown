using mytown.BL.Interfaces;
using mytown.Data;
using mytown.Models.AppModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace mytown.BL
{
    public class CommentLikeDAL : ICommentLikeDAL
    {
        private readonly AppDbContext _context;
        private readonly INotificationBL _iNotificationBL;
        public CommentLikeDAL(AppDbContext context, INotificationBL iNotificationBL)
        {
            _context = context;
            _iNotificationBL = iNotificationBL;
        }

        public async Task<ActionResult<int>> AddCommentLike(CommentLike like)
        {
            //first check if this like exists
            var oldLike = await _context.CommentLike.FindAsync(like.CommentID, like.PostID, like.UserEntityID);
            var comment = await _context.Comment.FindAsync(like.CommentID, like.PostID);

            if (oldLike == null) //it does not exists
                _context.CommentLike.Add(like);
            else
                oldLike.Value = like.Value;
            await _context.SaveChangesAsync();

            var comments = _context.CommentLike
                .Where(c => c.CommentID == like.CommentID && c.PostID == like.PostID);

            return comments.Count() > 0 ? comments.Sum(c => c.Value) : 0;
        }

        public async Task<ActionResult<int>> DeleteCommentLike(int commentID, int PostID, int userID)
        {
            var commentLike = await _context.CommentLike.FindAsync(commentID, PostID, userID);
            if (commentLike == null)
                return -1;

            var comment = await _context.Comment.FindAsync(commentID, PostID);

            _context.CommentLike.Remove(commentLike);
            await _context.SaveChangesAsync();

            _iNotificationBL.DeleteCommentNotification(commentID, PostID, userID, (int)Enums.NotificationType.COMMENT_LIKE);

            return _context.CommentLike.Where(c => c.PostID == PostID && c.CommentID == commentID).Count();
        }

        public async Task<ActionResult<List<CommentLike>>> getLikesByCommentID(int PostID, int commentID)
        {
            return await _context.CommentLike
                .Include(cl => cl.User)
                .Include(cl => cl.Comment)
                .Where(cl => cl.CommentID == commentID && cl.PostID == PostID)
                .ToListAsync();
        }
    }
}
