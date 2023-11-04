using mytown.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.BL.Interfaces
{
    public interface IPostImageBL
    {
        void addImage(PostImage image);
        List<PostImage> getImagesByPostID(int id);
        Task<ActionResult<bool>> UploadImages(IFormFile[] images, int PostID);
        Task<ActionResult<bool>> UploadInstitutionPostImage(int postID, string image);
    }
}
