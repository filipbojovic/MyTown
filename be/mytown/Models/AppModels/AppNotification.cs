using System;

namespace mytown.Models.AppModels
{
    public class AppNotification
    {
        public string Header { get; set; }
        public ImagePath UserProfilePhoto { get; set; }
        public ImagePath PostImage { get; set; }
        public DateTime Date { get; set; }
        public int PostID { get; set; }
        public int NotificationType { get; set; }
    }
}
