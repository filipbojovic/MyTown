using mytown.Models.AppModels;
using mytown.Models.DbModels;
using mytown.Models.ModelsWithPictures;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.BL.Interfaces
{
    public interface ICommentBL
    {
        List<Comment> getComments();
        List<AppComment> getAppProposalsByPostId(int postID, int userID);
        AppReply AddComment(Comment comment);
        Task<ActionResult<AppComment>> AddCommentWithImages(CommentWithImages comment);
        Task<ActionResult<AppComment>> AddInstitutionComment(InstitutionCommentWithImage comment);
        AppComment GetAppProposalByCommentID(int commentID, int postID);
        bool DeleteComment(int commentID, int PostID);
        AppReply GetAppReplyByComment(Comment comment, int userID);
        List<Comment> GetProposalsByUserID(int userID);
        bool ChangeCommentText(CommentVM comment);
    }
}
