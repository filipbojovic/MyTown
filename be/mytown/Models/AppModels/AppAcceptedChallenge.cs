using System;

namespace mytown.Models.AppModels
{
    public class AppAcceptedChallenge
    {
        public int PostID { get; set; }
        public int UserEntityID { get; set; }
        public string Title { get; set; }
        public ImagePath Image { get; set; }
        public DateTime EndDate { get; set; }
        public int Status { get; set; }
    }
}
