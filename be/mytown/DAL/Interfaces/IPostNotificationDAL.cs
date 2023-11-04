using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IPostNotificationDAL
    {
        Task<ActionResult<PostNotification>> AddPostNotification(PostNotification notification);
        Task<ActionResult<List<PostNotification>>> GetAllPostNotificationsByUserID(int userEntityID);
        Task<ActionResult<bool>> DeletePostNotification(int PostID, int userEntityID, int notificationTypeID);
        Task<ActionResult<PostNotification>> GetPostNotificationByID(int postNotificationID);
        Task<ActionResult<bool>> MakeAllNotificationsRead(int userID);
    }
}
