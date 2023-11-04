using mytown.Models;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IPostDAL
    {
        Task<ActionResult<List<Post>>> GetAllDbPosts();
        Task<ActionResult<Post>> AddPost(Post post);
        Task<ActionResult<bool>> DeletePost(int postID);
        Task<ActionResult<Post>> GetDbPostByID(int id);
        Task<ActionResult<int>> GetPostTypeID(int postID);
        Task<ActionResult<List<Post>>> GetPostsByUserID(int userID);
        Task<ActionResult<int>> GetNumberOfPostsByUserID(int userEntityID);
        Task<ActionResult<bool>> ChangePostData(PostVM newPost);
        Task<ActionResult<bool>> PostExistance(int postID);
    }
}
