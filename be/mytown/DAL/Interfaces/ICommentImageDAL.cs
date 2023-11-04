using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface ICommentImageDAL
    {
        Task<ActionResult<CommentImage>> AddCommentImage(CommentImage image);
        Task<ActionResult<bool>> UpdateImage(int imageID, string imgExt, string path);
        Task<ActionResult<List<CommentImage>>> GetAllCommentImages(int commentID, int postID);
    }
}
