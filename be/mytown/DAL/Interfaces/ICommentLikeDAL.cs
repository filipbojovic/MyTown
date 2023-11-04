using mytown.Models.AppModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.BL.Interfaces
{
    public interface ICommentLikeDAL
    {
        Task<ActionResult<List<CommentLike>>> getLikesByCommentID(int PostID, int commentID);
        Task<ActionResult<int>> AddCommentLike(CommentLike like);
        Task<ActionResult<int>> DeleteCommentLike(int commentID, int PostID, int userID);
    }
}
