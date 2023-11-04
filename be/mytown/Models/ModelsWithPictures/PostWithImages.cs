using Microsoft.AspNetCore.Http;

namespace mytown.Models.ModelsWithPictures
{
    public class PostWithImages
    {
        public Post Challenge { get; set; }
        public IFormFile[] Images { get; set; }
    }
}
