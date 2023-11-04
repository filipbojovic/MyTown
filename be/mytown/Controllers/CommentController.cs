using System;
using mytown.Models.AppModels;
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
    public class CommentController : ControllerBase
    {
        private readonly ICommentUI _iCommentUI;
        private readonly ICommentLikeUI _iCommentLikeUI;
        private readonly IPostUI _iPostUI;

        public CommentController(ICommentUI iCommentUI, ICommentLikeUI iCommentLikeUI, IPostUI iPostUI)
        {
            _iCommentUI = iCommentUI;
            _iCommentLikeUI = iCommentLikeUI;
            _iPostUI = iPostUI;
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpGet]
        public IActionResult getComments()
        {
            try
            {
                return Ok(_iCommentUI.getComments());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpGet("proposals")] //get all proposals by entity with their replies
        public IActionResult getAppProposals(int PostID, int userID)
        {
            try
            {
                return Ok(_iCommentUI.getAppProposalsByPostId(PostID, userID));
            }
            catch (Exception e)
            {
                return BadRequest(e.ToString());
            }
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpGet("likes")]
        public IActionResult GetUsersWhoLikesThisComment(int PostID, int commentID)
        {
            try
            {
                return Ok(_iCommentLikeUI.GetUsersWhoLikesThisComment(PostID, commentID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost]
        public IActionResult AddComment(Comment comment)
        {
            try
            {
                var res = _iPostUI.PostExistance(comment.PostID);
                if (!res)
                    return NotFound();
                return CreatedAtAction("AddComment", new { id = comment.Id }, _iCommentUI.AddComment(comment));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("withImages")]
        public IActionResult AddCommentWithImages([FromForm] CommentWithImages commentWithImages)
        {
            try
            {
                var res1 = _iPostUI.PostExistance(commentWithImages.Comment.PostID);
                if (!res1)
                    return NotFound();
                var res = _iCommentUI.AddCommentWithImages(commentWithImages);
                if (res == null)
                    return UnprocessableEntity();
                else
                    return CreatedAtAction("AddCommentWithImages", res);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("add")]
        public IActionResult AddCommentLike(CommentLike like)
        {
            try
            {
                int res = _iCommentLikeUI.AddCommentLike(like);
                return CreatedAtAction("AddCommentLike", res);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("delete")]
        public IActionResult DeleteCommentLike(int commentID, int PostID, int userID)
        {
            try
            {
                int res = _iCommentLikeUI.DeleteCommentLike(commentID, PostID, userID);
                if (res != -1)
                    return Ok(res);
                else
                    return NotFound(null);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution")]
        [HttpPost("deleteComment")]
        public IActionResult DeleteComment(int commentID, int PostID)
        {
            try
            {
                var res = _iCommentUI.DeleteComment(commentID, PostID);

                if (res)
                    return Ok(res);
                else
                    return NotFound(res);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Institution")]
        [HttpPost("institutionComment")]
        public IActionResult AddInstitutionComment(InstitutionCommentWithImage comment)
        {
            try
            {
                return CreatedAtAction("AddInstitutionComment", _iCommentUI.AddInstitutionComment(comment));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Institution")]
        [HttpPost("changeCommentData")]
        public IActionResult ChangeCommentData(CommentVM comment)
        {
            try
            {
                var res = _iCommentUI.ChangeCommentText(comment);
                if (res)
                    return CreatedAtAction("ChangeCommentData", comment);
                else
                    return NotFound();

            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}