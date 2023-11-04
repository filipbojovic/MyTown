using System;
using System.Linq;
using mytown.DAL.Interfaces;
using mytown.Models.DbModels;
using mytown.Models.ModelsWithPictures;
using mytown.Models.ViewModels;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChallengePostController : ControllerBase
    {
        private readonly IPostUI _iPostUI;
        private readonly IPostDAL _iPostDAL;
        private readonly IAcceptedChallengeUI _iAcceptedChallengeUI;
        private readonly IPostLikeUI _iPostLikeUI;

        public ChallengePostController(IPostUI iPostUI, IPostDAL iPostDAL, IAcceptedChallengeUI iAcceptedChallengeUI, IPostLikeUI iPostLikeUI)
        {
            _iPostUI = iPostUI;
            _iPostDAL = iPostDAL;
            _iAcceptedChallengeUI = iAcceptedChallengeUI;
            _iPostLikeUI = iPostLikeUI;
        }


        [HttpGet]
        public IActionResult GetAllDbChallenges()
        {
            return Ok(_iPostUI.GetAllDbPosts().Result.Value.ToList());
        }


        [Authorize(Roles = "User, Institution")]
        [HttpPost]
        public IActionResult AddPost([FromForm] PostWithImages challengeWithImages)
        {
            try
            {
                var res = _iPostUI.AddPost(challengeWithImages);
                if (res)
                    return CreatedAtAction("AddPost", res);
                else
                    return UnprocessableEntity();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpGet("onePost")]
        public IActionResult GetAppPostByID(int postID, int userID)
        {
            try
            {
                return Ok(_iPostUI.GetAppPostByID(postID, userID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpPost("{postID}")]
        public IActionResult DeletePost(int postID)
        {
            try
            {
                return Ok(_iPostUI.DeletePost(postID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpGet("challenges/{userID}")]
        public IActionResult GetAllAppChallenges(int userID)
        {
            try
            {
                return Ok(_iPostUI.GetAllAppPosts(userID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet("{id}")]
        public IActionResult getUserPostById(int id)
        {
            return Ok(_iPostDAL.GetDbPostByID(id));
        }

        [Authorize(Roles = "User")]
        [HttpPost("AcceptChallenge")]
        public IActionResult AcceptChallenge(AcceptedChallenge challenge)
        {
            try
            {
                return CreatedAtAction("AcceptChallenge", _iAcceptedChallengeUI.AddAcceptedChallenge(challenge));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("giveUpTheChallenge")]
        public IActionResult GiveUpTheChallenge(int postEntityID, int userEntityID)
        {
            try
            {
                return Ok(_iAcceptedChallengeUI.DeleteAcceptedChallenge(postEntityID, userEntityID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpGet("acceptedChallenges/{userID}")]
        public IActionResult GetAcceptedChallengesByUserID(int userID)
        {
            try
            {
                return Ok(_iAcceptedChallengeUI.GetAcceptedChallengesByUserID(userID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("addLike")]
        public IActionResult AddPostLike(PostLike like)
        {
            try
            {
                var res = _iPostLikeUI.AddPostLike(like);
                if (res == -1)
                    return NotFound();
                else
                    return CreatedAtAction("AddPostLike", res);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("deleteLike")]
        public IActionResult DeletePostLike(int postID, int userID)
        {
            try
            {
                var res = _iPostLikeUI.DeletePostLike(postID, userID);
                if (res != -1)
                    return Ok(res);
                else
                    return NotFound(-1);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpGet("likes")]
        public IActionResult GetUsersWhoLikesThisPost(int postID)
        {
            try
            {
                return Ok(_iPostUI.GetUsersWhoLikesThisPost(postID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Institution")]
        [HttpPost("institutionPost")]
        public IActionResult AddInstitutionPost(InstitutionPostWithImage post)
        {
            try
            {
                return CreatedAtAction("AddInstitutionPost", _iPostUI.AddInstitutionPost(post));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpGet("appPosts/{userID}")]
        public IActionResult GetAppPostsByUserID(int userID)
        {
            try
            {
                return Ok(_iPostUI.GetAppPostsByUserID(userID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpPost("changePostData")]
        public IActionResult ChangePostData(PostVM post)
        {
            try
            {
                var res = _iPostUI.ChangePostData(post);
                if (res)
                    return CreatedAtAction("ChangePostData", post);
                else
                    return NotFound();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpPost("filteredPosts")]
        public IActionResult GetFilteredPosts(PostFilterVM filter)
        {
            try
            {
                return Ok(_iPostUI.GetFilteredPosts(filter));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("filterPostsAdmin")] //filter for administrator page
        public IActionResult FilterPostAdmin(string filterText, int cityID, int postType)
        {
            try
            {
                return Ok(_iPostUI.GetFilteredPostsAdminPage(filterText, cityID, postType));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin, Institution, User")]
        [HttpGet("postExistance")] //filter for administrator page
        public IActionResult PostExistance(int postID)
        {
            try
            {
                return Ok(_iPostUI.PostExistance(postID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

    }
}