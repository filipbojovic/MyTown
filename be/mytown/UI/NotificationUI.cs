using mytown.BL.Interfaces;
using mytown.Models.AppModels;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class NotificationUI : INotificationUI
    {
        private readonly INotificationBL _iNotificationBL;

        public NotificationUI(INotificationBL iNotificationBL)
        {
            _iNotificationBL = iNotificationBL;
        }

        public List<AppNotification> GetAllNotificationsByUserID(int userEntityID)
        {
            return _iNotificationBL.GetAllNotificationsByUserID(userEntityID);
        }

        public bool MakeAllNotificationsAsRead(int userID)
        {
            return _iNotificationBL.MakeAllNotificationsAsRead(userID);
        }
    }
}
