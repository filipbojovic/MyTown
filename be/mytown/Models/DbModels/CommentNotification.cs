using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models.DbModels
{
    public class CommentNotification
    {
        public int Id { get; set; }
        public int SenderID { get; set; }
        public int ReceiverID { get; set; }
        public int PostID { get; set; }
        public int CommentID { get; set; }
        public int NotificationTypeID { get; set; }
        public bool Read { get; set; }
        public DateTime Date { get; set; }

        [ForeignKey("NotificationTypeID")]
        public NotificationType NotificationType { get; set; }

        [ForeignKey("ReceiverID")]
        public User Receiver { get; set; }

        [ForeignKey("SenderID")]
        public User Sender { get; set; }
        [ForeignKey("PostID")]
        public Post Post { get; set; }
        public virtual Comment Comment { get; set; }
    }
}
