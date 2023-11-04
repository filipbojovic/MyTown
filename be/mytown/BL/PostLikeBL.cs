using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL
{
    public class PostLikeBL : IPostLikeBL
    {
        private readonly IPostLikeDAL _iEntityLikeDAL;

        public PostLikeBL(IPostLikeDAL iEntityLikeDAL)
        {
            _iEntityLikeDAL = iEntityLikeDAL;
        }

        public int AddPostLike(PostLike like)
        {
            return _iEntityLikeDAL.AddPostLike(like).Result.Value;
        }

        public int DeletePostLike(int PostID, int userID)
        {
            return _iEntityLikeDAL.DeletePostLike(PostID, userID).Result.Value;
        }

        public List<PostLike> GetLikesByPostID(int PostID)
        {
            return _iEntityLikeDAL.GetLikesByPostID(PostID).Result.Value;
        }
    }
}
