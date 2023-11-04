using mytown.Models;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface IPostImageUI
    {
        void AddImage(PostImage image);
        List<PostImage> GetImagesByPostID(int id);
    }
}
