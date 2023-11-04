using mytown.Models.AppModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface ICommentLikeUI
    {
        List<AppUser> GetUsersWhoLikesThisComment(int PostID, int commentID);
        int AddCommentLike(CommentLike like);
        int DeleteCommentLike(int commentID, int PostID, int userID);
    }
}
