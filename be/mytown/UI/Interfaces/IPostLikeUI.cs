using mytown.Models.DbModels;

namespace mytown.UI.Interfaces
{
    public interface IPostLikeUI
    {
        int AddPostLike(PostLike like);
        int DeletePostLike(int PostID, int userID);
    }
}
