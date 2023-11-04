using mytown.Models;
using mytown.Models.AppModels;
using mytown.Models.ModelsWithPictures;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.BL.Interfaces
{
    public interface IPostBL
    {
        Task<ActionResult<List<Post>>> GetAllDbPosts();
        Task<ActionResult<bool>> AddPost(PostWithImages challengeWithImages);
        bool DeletePost(int postID);
        List<AppPost> GetAllAppPosts(int userID);
        List<AppUser> GetUsersWhoLikesThisPost(int postID);
        AppPost GetAppPostByID(int postID, int? userID);
        List<Post> GetPostsByUserID(int userID);
        Task<ActionResult<AppPost>> AddInstitutionPost(InstitutionPostWithImage post);
        List<AppPost> GetAppPostsByUserID(int userID);
        bool ChangePostData(PostVM post);
        List<AppPost> GetFilteredPosts(PostFilterVM filter);
        List<AppPost> GetFilteredPostsAdminPage(string filterText, int cityID, int postType);
        bool PostExistance(int postID);
    }
}
