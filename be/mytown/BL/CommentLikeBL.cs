using mytown.BL.Interfaces;
using mytown.Models.AppModels;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class CommentLikeBL : ICommentLikeBL
    {
        private readonly ICommentLikeDAL _iCommentLikeDAL;
        private readonly IUserBL _iUserBL;

        public CommentLikeBL(ICommentLikeDAL iCommentLikeDAL, IUserBL iUserBL)
        {
            _iCommentLikeDAL = iCommentLikeDAL;
            _iUserBL = iUserBL;
        }

        public int AddCommentLike(CommentLike like)
        {
            return _iCommentLikeDAL.AddCommentLike(like).Result.Value;
        }

        public int DeleteCommentLike(int commentID, int postID, int userID)
        {
            return _iCommentLikeDAL.DeleteCommentLike(commentID, postID, userID).Result.Value;
        }

        public List<AppUser> GetUsersWhoLikesThisComment(int postID, int commentID)
        {
            return _iCommentLikeDAL.getLikesByCommentID(postID, commentID).Result.Value
                .Select(cl => _iUserBL.GetAppUserByID(cl.User.Id))
                .ToList();
        }
    }
}
