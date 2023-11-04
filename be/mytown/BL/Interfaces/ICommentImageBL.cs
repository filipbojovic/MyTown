using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace mytown.BL.Interfaces
{
    public interface ICommentImageBL
    {
        Task<ActionResult<bool>> UploadCommentImages(IFormFile[] images, int commentID, int PostID, int typeID);
        bool DeleteCommentImages(int commentID, int postID);
        Task<ActionResult<bool>> UploadInstitutionCommentImage(int commentID, int postID, string image);
    }
}
