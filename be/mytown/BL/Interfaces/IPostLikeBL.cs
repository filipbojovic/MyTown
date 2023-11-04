using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface IPostLikeBL
    {
        List<PostLike> GetLikesByPostID(int PostID);
        int AddPostLike(PostLike like);
        int DeletePostLike(int PostID, int userID);
    }
}
