using mytown.Models.DbModels;
using Microsoft.AspNetCore.Http;

namespace mytown.Models.ModelsWithPictures
{
    public class CommentWithImages
    {
        public Comment Comment{ get; set; }
        public IFormFile[] Images { get; set; }
    }
}

