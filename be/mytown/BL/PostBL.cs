using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using mytown.Models.ModelsWithPictures;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.BL
{
    public class PostBL : IPostBL
    {
        const int _userPostInfinityScroll = 10;

        private readonly IPostDAL _iPostDAL;
        private readonly IPostImageBL _iPostImageBL;
        private readonly IPostImageDAL _iPostImageDAL;
        private readonly ICategoryDAL _iCategoryDAL;
        private readonly ICommentBL _iCommentBL;
        private readonly IPostLikeBL _iPostLikeBL;
        private readonly IUserBL _iUserBL;
        private readonly IInstitutionDAL _iInstitutionDAL;
        public PostBL(IPostDAL iPostDAL, IPostImageBL iPostImageBL, IPostImageDAL iPostImageDAL, ICategoryDAL iCategoryDAL, ICommentBL iCommentBL, IPostLikeBL iPostLikeBL, IUserBL iUserBL, IInstitutionDAL iInstitutionDAL)
        {
            _iPostDAL = iPostDAL;
            _iPostImageBL = iPostImageBL;
            _iPostImageDAL = iPostImageDAL;
            _iCategoryDAL = iCategoryDAL;
            _iCommentBL = iCommentBL;
            _iPostLikeBL = iPostLikeBL;
            _iUserBL = iUserBL;
            _iInstitutionDAL = iInstitutionDAL;
        }

        public async Task<ActionResult<List<Post>>> GetAllDbPosts() //returns all posts from DB
        {
            return await _iPostDAL.GetAllDbPosts();
        }

        public async Task<ActionResult<bool>> AddPost(PostWithImages challengeWithImages) //adds posts to db
        {
            try
            {
                if(challengeWithImages.Images != null)
                {
                    foreach (IFormFile img in challengeWithImages.Images)
                    {
                        string imgext = Path.GetExtension(img.FileName);
                        if (imgext != ".jpg" && imgext != ".png" && imgext != ".jpeg")
                            return false;
                    }
                }

                Post post = challengeWithImages.Challenge;
                var isChallengeSuccesfullyAded = await _iPostDAL.AddPost(post);

                if (isChallengeSuccesfullyAded == null)
                    return null;

                //if it's not, add images for it
                if(challengeWithImages.Images != null)
                    await _iPostImageBL.UploadImages(challengeWithImages.Images, post.Id);

                return true;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public List<AppPost> GetAllAppPosts(int userID) //returns all posts with values instead of IDs
        {
            List<AppPost> hpps = new List<AppPost>();

            var posts = _iPostDAL.GetAllDbPosts();
            var user = _iUserBL.GetUserByID(userID);

            foreach (var post in posts.Result.Value)
                hpps.Add(GetAppPostByID(post.Id, userID));
            return hpps.OrderByDescending(h => h.Date).ToList();
        }

        public List<AppUser> GetUsersWhoLikesThisPost(int postID)
        {
            var likes = _iPostLikeBL.GetLikesByPostID(postID);
            List<AppUser> users = new List<AppUser>();

            if (likes != null)
                foreach (var like in likes)
                    users.Add(_iUserBL.GetAppUserByID(like.User.Id));
            else
                return null;
            return users;
        }

        public bool DeletePost(int postID)
        {
            return _iPostDAL.DeletePost(postID).Result.Value;
        }

        public AppPost GetAppPostByID(int postID, int? userID)
        {
            var dbPost = _iPostDAL.GetDbPostByID(postID).Result.Value;
            User dbUser = null;
            Institution dbInstitution = null;
            
            if(userID != null)
            {
                dbUser = _iUserBL.GetUserByID((int)userID);
                if (dbUser == null)
                {
                    dbInstitution = _iInstitutionDAL.GetInstitutionByID((int)userID).Result.Value;
                }
            }

            AppPost appPost = new AppPost();
            appPost.Id = dbPost.Id;
            appPost.Description = dbPost.Description;
            appPost.Date = dbPost.Date;
            appPost.Comments = _iCommentBL.getComments().Where(c => c.PostID == dbPost.Id && c.ParrentID == null).Count();
            appPost.CategoryName = dbPost.CategoryID != null ? _iCategoryDAL.getCategoryByID((int)dbPost.CategoryID).Result.Value.Name : null;

            var urls = _iPostImageDAL.GetImagesURLByPostID(dbPost.Id).Result.Value;
            List<ImagePath> listpath = new List<ImagePath>();
            foreach (var url in urls)
            {
                ImagePath ip = new ImagePath
                {
                    Path = url
                };
                listpath.Add(ip);
            }
            appPost.ImageURLS = listpath;
            appPost.Latitude = dbPost.Latitude;
            appPost.Longitude = dbPost.Longitude;
            appPost.UserEntityID = dbPost.UserEntityID;
            appPost.FirstName = dbPost.User != null ? dbPost.User.FirstName : dbPost.Institution.Name;
            appPost.LastName = dbPost.User != null ? dbPost.User.LastName : "";
            appPost.CityID = dbPost.CityID;
            appPost.CityName = dbPost.City.Name;
            appPost.Rating = 0;// dbPost.Rating;

            var likesForThisPost = _iPostLikeBL.GetLikesByPostID(dbPost.Id);
            if(userID != null)
                appPost.LikedByUser = (likesForThisPost.Where(l => l.UserID == userID).FirstOrDefault()) != null; //ovo
            appPost.Likes = likesForThisPost.Count();

            appPost.Title = dbPost.Title;
            appPost.EndDate = dbPost.EndDate != null ? dbPost.EndDate : null;

            appPost.UserProfilePhotoURL = dbPost.User != null ?
                (dbPost.User.ProfilePhoto == null ? Enums.defaultProfilePhotoURL : dbPost.User.ProfilePhoto.Path + dbPost.User.ProfilePhoto.Name) :
                (dbPost.Institution.Logo == null ? Enums.defaultProfilePhotoURL : dbPost.Institution.Logo.Path + dbPost.Institution.Logo.Name);

            if (userID != null)
                appPost.AcceptedByTheUser = (dbUser != null && dbUser.AcceptedChallenges.Where(c => c.PostID == dbPost.Id).FirstOrDefault() != null) ? true : false; //ovo
            appPost.CityID = dbPost.CityID;

            if(userID != null)
            {
                var acceptedChallenge = dbUser != null ? dbUser.AcceptedChallenges.Where(c => c.PostID == dbPost.Id).FirstOrDefault() : null; //ovo
                Comment solvedByInstitution = null;
                if (dbInstitution != null)
                    solvedByInstitution = _iCommentBL.getComments()
                        .Where(c => c.PostID == dbPost.Id && c.ParrentID == null && c.UserEntityID == dbInstitution.Id)
                        .FirstOrDefault();

                appPost.SolvedByTheUser = dbUser != null ? //ovo
                    (acceptedChallenge != null ? acceptedChallenge.Status : (int)Enums.ChallengeStatus.NOT_SOLVED_YET) :
                    (solvedByInstitution != null ? (int)Enums.ChallengeStatus.SOLVED : (int)Enums.ChallengeStatus.NOT_SOLVED_YET);
            }

            appPost.TypeID = dbPost.TypeID;

            return appPost;
        }

        public List<Post> GetPostsByUserID(int userID)
        {
            return _iPostDAL.GetPostsByUserID(userID).Result.Value;
        }

        public async Task<ActionResult<AppPost>> AddInstitutionPost(InstitutionPostWithImage post)
        {
            try
            {
                await _iPostDAL.AddPost(post.Post);

                if(post.Image != null)
                    await _iPostImageBL.UploadInstitutionPostImage(post.Post.Id, post.Image);

                return GetAppPostByID(post.Post.Id, post.Post.UserEntityID);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public List<AppPost> GetAppPostsByUserID(int userID)
        {
            var posts = GetPostsByUserID(userID);
            List<AppPost> appPosts = new List<AppPost>();

            foreach (var item in posts)
                appPosts.Add(GetAppPostByID(item.Id, userID));
            return appPosts
                .OrderByDescending(p => p.Date)
                .ToList();
        }

        public bool ChangePostData(PostVM post)
        {
            return _iPostDAL.ChangePostData(post).Result.Value;
        }

        public List<AppPost> GetFilteredPosts(PostFilterVM filter)
        {
            var posts = GetAllDbPosts().Result.Value;

            if (filter.UserPost || filter.ChallengePost || filter.InstitutionPost) //at least one postType checkbox is checked
                posts = posts
                    .Where(p => (p.TypeID == (int)Enums.PostEntityType.CHALLENGE && filter.ChallengePost) || (p.TypeID == (int)Enums.PostEntityType.USER_POST && filter.UserPost)
                        || (p.TypeID == (int)Enums.PostEntityType.INSTITUTION_POST && filter.InstitutionPost))
                    .ToList();

            if (filter.CategoryID != -1) //filter by category
                posts = posts
                    .Where(p => (p.CategoryID == filter.CategoryID && p.TypeID == (int)Enums.PostEntityType.CHALLENGE) || (p.CategoryID == filter.CategoryID && p.TypeID == (int)Enums.PostEntityType.INSTITUTION_POST)
                        || p.TypeID == (int)Enums.PostEntityType.USER_POST)
                    .ToList();

            posts = posts //filter by city
                .Where(p => (p.CityID == filter.CityID && p.TypeID == (int)Enums.PostEntityType.CHALLENGE) || (p.CityID == filter.CityID && p.TypeID == (int)Enums.PostEntityType.INSTITUTION_POST)
                    || p.TypeID == (int)Enums.PostEntityType.USER_POST)
                .ToList();

            List<AppPost> list = new List<AppPost>();
            foreach (var post in posts)
                list.Add(GetAppPostByID(post.Id, filter.UserEntityID));

            return list
                .OrderByDescending(p => p.Date)
                .ToList()
                .Take(filter.Counter * _userPostInfinityScroll)
                .ToList();
        }

        public List<AppPost> GetFilteredPostsAdminPage(string filterText, int cityID, int postType) //search by title or username
        {
            var posts = GetAllDbPosts().Result.Value;
            if(cityID != -1 && postType != (int)Enums.PostEntityType.USER_POST)
                posts = posts //filter by city
                    .Where(p => p.CityID == cityID)
                    .ToList();

            posts = posts //filter by type
                .Where(p => p.TypeID == postType)
                .ToList();

            if(filterText != null)
            {
                if(postType == (int)Enums.PostEntityType.INSTITUTION_POST)
                    posts = posts
                        .Where(p => ((p.Institution.Name).ToLower().Contains(filterText.ToLower())) || (p.Title != null && p.Title.ToLower().Contains(filterText.ToLower())))
                        .ToList();
                else
                    posts = posts
                        .Where(p => ((p.User.FirstName + " " + p.User.LastName).ToLower().Contains(filterText.ToLower())) || (p.Title != null && p.Title.ToLower().Contains(filterText.ToLower())))
                        .ToList();
            }

            List<AppPost> list = new List<AppPost>();
            foreach (var post in posts)
                list.Add(GetAppPostByID(post.Id, null));

            return list
                .OrderByDescending(p => p.Date)
                .ToList();
        }

        public bool PostExistance(int postID)
        {
            return _iPostDAL.PostExistance(postID).Result.Value;
        }
    }
}
