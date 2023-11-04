using mytown.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IPostImageDAL
    {
        Task<ActionResult<bool>> AddImage(PostImage image);
        Task<ActionResult<List<PostImage>>> GetImagesByPostID(int id);
        Task<ActionResult<List<string>>> GetImagesURLByPostID(int id);
        Task<ActionResult<bool>> UpdateImage(int imageID, string imgExt, string path);
    }
}
