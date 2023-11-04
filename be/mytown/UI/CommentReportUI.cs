using mytown.BL.Interfaces;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class CommentReportUI : ICommentReportUI
    {
        private readonly ICommentReportBL _iCommentReportBL;

        public CommentReportUI(ICommentReportBL iCommentReportBL)
        {
            _iCommentReportBL = iCommentReportBL;
        }

        public CommentReport AddCommentReport(CommentReport report)
        {
            return _iCommentReportBL.AddCommentReport(report);
        }

        public List<CommentReport> GetAllCommentReports()
        {
            return _iCommentReportBL.GetAllCommentReports();
        }

        public bool MarkCommentReportAsRead(int reportID)
        {
            return _iCommentReportBL.MarkCommentReportAsRead(reportID);
        }
    }
}
