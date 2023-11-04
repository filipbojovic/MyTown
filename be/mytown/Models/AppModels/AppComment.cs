using System;
using System.Collections.Generic;

namespace mytown.Models.AppModels
{
    public class AppComment
    {
        public int Id { get; set; }
        public int PostID { get; set; }
        public int UserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime Date { get; set; }
        public int Likes { get; set; }
        public string Text { get; set; }
        public List<ImagePath> Images { get; set; }
        public List<AppReply> Replies { get; set; }
        public string ProfileImage { get; set; }
        public int LikeValue { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public int UserTypeID { get; set; }
    }
}
