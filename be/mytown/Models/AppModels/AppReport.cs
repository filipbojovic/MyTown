using System;

namespace mytown.Models.AppModels
{
    public class AppReport
    {
        public int Id { get; set; }
        public int? CommentID { get; set; }
        public int PostID { get; set; }
        public int ReportedUserID { get; set; }
        public int SenderID { get; set; }
        public DateTime Date { get; set; }
        public string Text { get; set; }
        public bool Read { get; set; }
        public string SenderFullName { get; set; }
        public string ReportedUserFullName { get; set; }
        public string CommentText { get; set; }
        public AppPost Post { get; set; }
    }
}
