using mytown.BL.Interfaces;
using mytown.Models;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class PostImageUI : IPostImageUI
    {
        private readonly IPostImageBL _iUploadImageBL;

        public PostImageUI(IPostImageBL iUploadImageBL)
        {
            _iUploadImageBL = iUploadImageBL;
        }
        public void AddImage(PostImage image)
        {
            _iUploadImageBL.addImage(image);
        }
        public List<PostImage> GetImagesByPostID(int id)
        {
            return _iUploadImageBL.getImagesByPostID(id);
        }
    }
}
