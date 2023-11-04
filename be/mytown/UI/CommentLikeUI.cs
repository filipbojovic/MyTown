using mytown.BL.Interfaces;
using mytown.Models.AppModels;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class CommentLikeUI : ICommentLikeUI
    {
        private readonly ICommentLikeBL _iCommentLikeBL;
        public CommentLikeUI(ICommentLikeBL iCommentLikeBL)
        {
            _iCommentLikeBL = iCommentLikeBL;
        }

        public int AddCommentLike(CommentLike like)
        {
            return _iCommentLikeBL.AddCommentLike(like);
        }

        public int DeleteCommentLike(int commentID, int PostID, int userID)
        {
            return _iCommentLikeBL.DeleteCommentLike(commentID, PostID, userID);
        }

        public List<AppUser> GetUsersWhoLikesThisComment(int PostID, int commentID)
        {
            return _iCommentLikeBL.GetUsersWhoLikesThisComment(PostID, commentID);
        }
    }
}
