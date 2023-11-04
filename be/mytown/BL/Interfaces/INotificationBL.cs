using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface INotificationBL
    {
        bool AddCommentNotification(CommentNotification commentNotif);
        bool AddPostNotification(PostNotification entityNotif);
        List<AppNotification> GetAllNotificationsByUserID(int userEntityID);
        bool DeleteCommentNotification(int commentID, int PostID, int userID, int notificationType);
        bool DeletePostNotification(int PostID, int userID, int notificationType);
        bool CheckUnreadNotification(int userID);
        bool MakeAllNotificationsAsRead(int userID);
    }
}
