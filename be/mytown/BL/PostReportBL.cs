using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL
{
    public class PostReportBL : IPostReportBL
    {
        private readonly IPostReportDAL _iPostReportDAL;
        private readonly ICommentReportDAL _iCommentReportDAL;
        private readonly IPostBL _iPostBL;
        public PostReportBL(IPostReportDAL iPostReportDAL, ICommentReportDAL iCommentReportDAL, IPostBL iPostBL)
        {
            _iPostReportDAL = iPostReportDAL;
            _iCommentReportDAL = iCommentReportDAL;
            _iPostBL = iPostBL;
        }

        public PostReport AddPostReport(PostReport report)
        {
            return _iPostReportDAL.AddPostReport(report).Result.Value;
        }
        public List<PostReport> GetAllPostReports()
        {
            return _iPostReportDAL.GetAllPostReports().Result.Value;
        }
        public List<AppReport> GetAllAppReports()
        {
            var _postReports = this.GetAllPostReports();
            var _commentReports = _iCommentReportDAL.GetAllCommentReports();

            List<AppReport> reportList = new List<AppReport>();
            foreach (var item in _postReports)
            {
                AppReport appReport = new AppReport
                {
                    Id = item.Id,
                    CommentID = null,
                    PostID = item.PostID,
                    ReportedUserID = item.ReportedUserID,
                    SenderID = item.SenderID,
                    Date = item.Date,
                    Read = item.Read,
                    Text = item.Text,
                    ReportedUserFullName = item.ReportedUser.FirstName + " " + item.ReportedUser.LastName,
                    SenderFullName = item.Sender.FirstName + " " + item.Sender.LastName,
                    Post = _iPostBL.GetAppPostByID(item.PostID, item.SenderID)
                };
                reportList.Add(appReport);
            }
            foreach (var item in _commentReports.Result.Value)
            {
                AppReport appReport = new AppReport
                {
                    Id = item.Id,
                    CommentID = item.CommentID,
                    PostID = item.PostID,
                    ReportedUserID = item.ReportedUserID,
                    SenderID = item.SenderID,
                    Date = item.Date,
                    Read = item.Read,
                    Text = item.Text,
                    ReportedUserFullName = item.ReportedUser.FirstName + " " + item.ReportedUser.LastName,
                    SenderFullName = item.Sender.FirstName + " " + item.Sender.LastName,
                    Post = _iPostBL.GetAppPostByID(item.PostID, item.SenderID),
                    CommentText = item.Comment.Text
                };
                reportList.Add(appReport);
            }
            return reportList;
        }

        public bool MarkPostReportAsRead(int reportID)
        {
            return _iPostReportDAL.MarkPostReportAsRead(reportID).Result.Value;
        }
    }
}
