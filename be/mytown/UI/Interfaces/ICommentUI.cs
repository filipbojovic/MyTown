using mytown.Models.AppModels;
using mytown.Models.DbModels;
using mytown.Models.ModelsWithPictures;
using mytown.Models.ViewModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface ICommentUI
    {
        List<Comment> getComments();
        List<AppComment> getAppProposalsByPostId(int postID, int userID);
        AppReply AddComment(Comment comment);
        AppComment AddCommentWithImages(CommentWithImages comment);
        AppComment AddInstitutionComment(InstitutionCommentWithImage comment);
        bool DeleteComment(int commentID, int PostID);
        bool ChangeCommentText(CommentVM comment);
    }
}
