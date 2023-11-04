using mytown.Models.AppModels;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models.DbModels
{
    public class Comment
    {
        public int Id { get; set; }
        public int PostID { get; set; }
        public int UserEntityID { get; set; }
        public string Text { get; set; }
        public int? ParrentID { get; set; }
        public DateTime Date { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }

        [ForeignKey("UserEntityID")]
        public virtual User User { get; set; }
        [ForeignKey("UserEntityID")]
        public virtual Institution Institution { get; set; }

        public virtual List<CommentLike> Likes { get; set; }
        public virtual List<CommentImage> Images { get; set; }

        [ForeignKey("PostID")]
        public virtual Post Post { get; set; }
        public virtual List<CommentNotification> CommentNotifications { get; set; }
        public virtual List<CommentReport> Reports { get; set; }
    }
}
