using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface ICommentNotificationDAL
    {
        Task<ActionResult<CommentNotification>> AddCommentNotification(CommentNotification notification);
        Task<ActionResult<List<CommentNotification>>> GetAllCommentNotificationsByUserID(int userEntityID);
        Task<ActionResult<bool>> DeleteCommentNotification(int commentID, int PostID, int userEntityID, int notificationTypeID);
        Task<ActionResult<CommentNotification>> GetCommentNotificationByID(int commentNotificationID);
        Task<ActionResult<bool>> MakeAllNotificationsRead(int userID);
    }
}
