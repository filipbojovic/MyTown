using mytown.Models.AppModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface INotificationUI
    {
        List<AppNotification> GetAllNotificationsByUserID(int userEntityID);
        bool MakeAllNotificationsAsRead(int userID);
    }
}
