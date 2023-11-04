using mytown.BL.Interfaces;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;

namespace mytown.UI
{
    public class PostLikeUI : IPostLikeUI
    {
        private readonly IPostLikeBL _iEntityLikeBL;

        public PostLikeUI(IPostLikeBL iPostLikeBL)
        {
            _iEntityLikeBL = iPostLikeBL;
        }

        public int AddPostLike(PostLike like)
        {
            return _iEntityLikeBL.AddPostLike(like);
        }

        public int DeletePostLike(int PostID, int userID)
        {
            return _iEntityLikeBL.DeletePostLike(PostID, userID);
        }
    }
}
