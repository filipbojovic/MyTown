using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IPostLikeDAL
    {
        Task<ActionResult<List<PostLike>>> GetLikesByPostID(int PostID);
        Task<ActionResult<int>> AddPostLike(PostLike like);
        Task<ActionResult<int>> DeletePostLike(int PostID, int userID);
    }
}
