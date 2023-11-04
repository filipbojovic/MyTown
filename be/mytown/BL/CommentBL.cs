using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
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
    public class CommentBL : ICommentBL
    {
        private readonly ICommentDAL _iCommentDAL;
        private readonly ICommentImageBL _iCommentImageBL;

        public CommentBL(ICommentDAL iCommentDAL, ICommentImageBL iCommentImageBL)
        {
            _iCommentDAL = iCommentDAL;
            _iCommentImageBL = iCommentImageBL;
        }

        public List<Comment> getComments()
        {
            return _iCommentDAL.getComments().Result.Value;
        }

        public AppComment GetAppProposalByCommentID(int commentID, int postID)
        {
            var comment = _iCommentDAL.GetCommentByID(commentID, postID).Result.Value;

            AppComment appComment = new AppComment();
            appComment.Id = comment.Id;
            appComment.PostID = comment.PostID;
            appComment.UserID = comment.UserEntityID;
            appComment.FirstName = comment.User != null ? comment.User.FirstName : comment.Institution.Name;
            appComment.LastName = comment.User != null ? comment.User.LastName : "";
            appComment.Date = comment.Date;
            appComment.Likes = 0;
            appComment.Text = comment.Text;
            appComment.LikeValue = 0;
            appComment.Latitude = comment.Latitude;
            appComment.Longitude = comment.Longitude;
            appComment.UserTypeID = (int)Enums.UserType.USER;

            List<ImagePath> images = new List<ImagePath>();

            foreach (var img in comment.Images)
                images.Add(new ImagePath() { Path = img.Path + img.Name });

            appComment.Images = images;

            appComment.Replies = new List<AppReply>();
            appComment.ProfileImage = comment.User != null ?
                            (comment.User.ProfilePhoto == null ? Enums.defaultProfilePhotoURL : comment.User.ProfilePhoto.Path + comment.User.ProfilePhoto.Name) :
                            (comment.Institution.Logo == null ? Enums.defaultProfilePhotoURL : comment.Institution.Logo.Path + comment.Institution.Logo.Name);


            return appComment;
        }

        public List<AppComment> getAppProposalsByPostId(int postID, int userID) //AppProposal is main comment
        {
            var allComments = _iCommentDAL.getComments().Result.Value.Where(c => c.PostID == postID);
            var comments = allComments.Where(c => c.ParrentID == null);

            List<AppComment> proposals = new List<AppComment>();

            foreach (var comment in comments)
            {
                AppComment proposal = new AppComment();
                var commentReplies = allComments.Where(c => c.ParrentID == comment.Id);
                List<AppReply> replies = new List<AppReply>();

                //create replies for proposal
                if (commentReplies != null)
                    foreach (var commentReply in commentReplies)
                        replies.Add(GetAppReplyByComment(commentReply, userID));

                proposal.Id = comment.Id;
                proposal.PostID = comment.PostID;
                proposal.UserID = comment.UserEntityID;
                proposal.FirstName = comment.User != null ? comment.User.FirstName : comment.Institution.Name;
                proposal.LastName = comment.User != null ? comment.User.LastName : "";
                proposal.Date = comment.Date;
                proposal.Likes = comment.Likes.Sum(l => l.Value);
                proposal.Text = comment.Text;
                var likeValue = comment.Likes.Where(l => l.UserEntityID == userID).FirstOrDefault();
                proposal.LikeValue = likeValue == null ? 0 : likeValue.Value;
                proposal.Latitude = comment.Latitude;
                proposal.Longitude = comment.Longitude;
                proposal.UserTypeID = comment.User != null ? comment.User.UserEntity.UserTypeID : comment.Institution.UserEntity.UserTypeID;

                List<ImagePath> images = new List<ImagePath>();

                foreach (var img in comment.Images)
                    images.Add(new ImagePath() { Path = img.Path + img.Name });

                proposal.Images = images;

                proposal.Replies = replies;
                proposal.ProfileImage = comment.User != null ?
                            (comment.User.ProfilePhoto == null ? Enums.defaultProfilePhotoURL : comment.User.ProfilePhoto.Path + comment.User.ProfilePhoto.Name) :
                            (comment.Institution.Logo == null ? Enums.defaultProfilePhotoURL : comment.Institution.Logo.Path + comment.Institution.Logo.Name);

                proposals.Add(proposal);
            }
            return proposals;
        }

        public AppReply AddComment(Comment comment)
        {
            var dbComment = _iCommentDAL.AddComment(comment).Result.Value;
            return GetAppReplyByComment(dbComment, -1);
        }

        public bool DeleteComment(int commentID, int PostID)
        {
            return _iCommentDAL.DeleteComment(commentID, PostID).Result.Value;
        }

        public async Task<ActionResult<AppComment>> AddCommentWithImages(CommentWithImages comment)
        {
            try
            {
                AppComment appCom = null;
                if (comment.Images != null)
                {
                    foreach (IFormFile img in comment.Images)
                    {
                        string imgext = Path.GetExtension(img.FileName);
                        if (imgext != ".jpg" && imgext != ".png" && imgext != ".jpeg")
                            return appCom;
                    }
                }

                var newComment = await _iCommentDAL.AddComment(comment.Comment);

                if (newComment == null)
                    return appCom;
                //add images to server

                if (comment.Images != null)
                    await _iCommentImageBL.UploadCommentImages(comment.Images, newComment.Value.Id, newComment.Value.PostID, (int)Enums.ImageType.COMMENT_IMAGE);


                appCom = GetAppProposalByCommentID(newComment.Value.Id, newComment.Value.PostID);
                return appCom;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public AppReply GetAppReplyByComment(Comment comment, int userID) //userID is -1 when it is not needed to determine if user liked this comment => likedByUser = false;
        {
            AppReply reply = new AppReply();

            reply.Id = comment.Id;
            reply.PostID = comment.PostID;
            reply.ParrentID = comment.ParrentID;
            reply.UserID = comment.UserEntityID;
            reply.FirstName = comment.User != null ? comment.User.FirstName : comment.Institution.Name;
            reply.LastName = comment.User != null ? comment.User.LastName : "";
            reply.Date = comment.Date;
            reply.Likes = comment.Likes.Sum(s => s.Value);
            reply.Text = comment.Text;
            reply.ProfileImage = comment.User != null ?
                (comment.User.ProfilePhoto == null ? Enums.defaultProfilePhotoURL : comment.User.ProfilePhoto.Path + comment.User.ProfilePhoto.Name) :
                (comment.Institution.Logo == null ? Enums.defaultProfilePhotoURL : comment.Institution.Logo.Path + comment.Institution.Logo.Name);
            new ImagePath() { Path = comment.User.ProfilePhoto == null ? Enums.defaultProfilePhotoURL : comment.User.ProfilePhoto.Path + comment.User.ProfilePhoto.Name };
            reply.LikedByUser = userID != -1 ? (comment.Likes.Where(l => l.UserEntityID == userID).FirstOrDefault() != null ? true : false) : false;
            reply.Latitude = comment.Latitude;
            reply.Longitude = comment.Longitude;
            reply.UserTypeID = comment.User != null ? comment.User.UserEntity.UserTypeID : comment.Institution.UserEntity.UserTypeID;

            return reply;
        }

        public List<Comment> GetProposalsByUserID(int userID)
        {
            var comments = _iCommentDAL.GetCommentsByUserID(userID);
            return comments
                .Result
                .Value
                .Where(c => c.Post.TypeID == (int)Enums.PostEntityType.CHALLENGE).ToList();
        }

        public async Task<ActionResult<AppComment>> AddInstitutionComment(InstitutionCommentWithImage comment)
        {
            try
            {
                var newComment = await _iCommentDAL.AddComment(comment.Comment);
                await _iCommentImageBL.UploadInstitutionCommentImage(newComment.Value.Id, comment.Comment.PostID, comment.Image);

                return GetAppProposalByCommentID(newComment.Value.Id, newComment.Value.PostID);

            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public bool ChangeCommentText(CommentVM comment)
        {
            return _iCommentDAL.ChangeCommentText(comment).Result.Value;
        }
    }
}
