using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class CommentDAL : ICommentDAL
    {
        private readonly AppDbContext _context;
        private readonly IAcceptedChallengeDAL _iAcceptedChallengeDAL;
        private readonly INotificationBL _iNotificationBL;
        private readonly ICommentImageBL _iCommentImageBL;
        public CommentDAL(AppDbContext context, IAcceptedChallengeDAL iAcceptedChallengeDAL, INotificationBL iNotificationBL, ICommentImageBL iCommentImageBL)
        {
            _context = context;
            _iAcceptedChallengeDAL = iAcceptedChallengeDAL;
            _iNotificationBL = iNotificationBL;
            _iCommentImageBL = iCommentImageBL;
        }

        public async Task<ActionResult<List<Comment>>> getComments()
        {
            return await _context.Comment
                .Include(c => c.Likes)
                .Include(c => c.User.ProfilePhoto)
                .Include(c => c.Institution.Logo)
                .Include(c => c.Institution.UserEntity)
                .Include(c => c.User.UserEntity)
                .Include(c => c.Post)
                .Include(c => c.Images)
                .ToListAsync();
        }

        public async Task<ActionResult<Comment>> AddComment(Comment comment)
        {
            var commentsOfEntity = _context.Comment.Where(c => c.PostID == comment.PostID);

            comment.Id = commentsOfEntity.Count() > 0 ? commentsOfEntity.Max(c => c.Id) + 1 : 1;
            _context.Comment.Add(comment);

            var post = await _context.Post.FindAsync(comment.PostID);
            if (post.TypeID == (int)Enums.PostEntityType.CHALLENGE) //after adding comment, this is solved
            {
                var user = _context.User.FindAsync(comment.UserEntityID);
                if (user != null)
                    await _iAcceptedChallengeDAL.ChangeStatus(comment.PostID, comment.UserEntityID, (int)Enums.ChallengeStatus.SOLVED);
            }

            await _context.SaveChangesAsync();

            //---------------------------send notif to everyone who accepted challenge--------------------------------------
            if (post.TypeID == (int)Enums.PostEntityType.CHALLENGE)
            {
                foreach (var user in _context.AcceptedChallenge.Where(ac => ac.PostID == comment.PostID && ac.UserEntityID != comment.UserEntityID))
                {
                    _iNotificationBL.AddCommentNotification
                    (
                        new CommentNotification
                        {
                            ReceiverID = user.UserEntityID,
                            SenderID = comment.UserEntityID,
                            Read = false,
                            PostID = comment.PostID,
                            CommentID = comment.Id,
                            Date = comment.Date,
                            NotificationTypeID = (int)Enums.NotificationType.ADDED_PROPOSAL
                        }
                    );
                }
            }
            return await GetCommentByID(comment.Id, comment.PostID);
        }

        public async Task<ActionResult<bool>> DeleteComment(int commentID, int postID)
        {
            var comment = await _context.Comment.FindAsync(commentID, postID);
            if (comment == null)
                return false;

            if (comment.ParrentID == null) //if this is a parrent, delete all his childs
            {
                var childs = _context.Comment.Where(c => c.ParrentID == comment.Id);
                _context.Comment.RemoveRange(childs);

                _iCommentImageBL.DeleteCommentImages(commentID, postID);
            }

            _context.Comment.Remove(comment);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<ActionResult<Comment>> GetCommentByID(int commentID, int postID)
        {
            return await _context.Comment
                .Include(c => c.Likes)
                .Include(c => c.User.ProfilePhoto)
                .Include(c => c.Institution.Logo)
                .Include(c => c.Institution.UserEntity)
                .Include(c => c.User.UserEntity)
                .Include(c => c.Post)
                .Include(c => c.Images)
                .Where(c => c.Id == commentID && c.PostID == postID)
                .FirstOrDefaultAsync();
        }

        public async Task<ActionResult<List<Comment>>> GetCommentsByUserID(int userID)
        {
            return await _context.Comment
                .Include(c => c.Likes)
                .Include(c => c.User.ProfilePhoto)
                .Include(c => c.Institution.Logo)
                .Include(c => c.Institution.UserEntity)
                .Include(c => c.User.UserEntity)
                .Include(c => c.Post)
                .Include(c => c.Images)
                .Where(c => c.UserEntityID == userID)
                .ToListAsync();
        }

        public async Task<ActionResult<bool>> ChangeCommentText(CommentVM newComment)
        {
            var comment = _context.Comment
                .Where(c => c.PostID == newComment.PostID && c.Id == newComment.Id)
                .FirstOrDefault();
            if (comment == null)
                return false;

            comment.Text = newComment.Text;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
