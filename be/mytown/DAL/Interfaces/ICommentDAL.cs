using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface ICommentDAL
    {
        Task<ActionResult<List<Comment>>> getComments();
        Task<ActionResult<Comment>> AddComment(Comment comment);
        Task<ActionResult<bool>> DeleteComment(int commentID, int PostID);
        Task<ActionResult<Comment>> GetCommentByID(int commentID, int postID);
        Task<ActionResult<List<Comment>>> GetCommentsByUserID(int userID);
        Task<ActionResult<bool>> ChangeCommentText(CommentVM commentData);
    }
}
