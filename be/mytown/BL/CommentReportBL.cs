using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL
{
    public class CommentReportBL : ICommentReportBL
    {
        private readonly ICommentReportDAL _iCommentReportDAL;

        public CommentReportBL(ICommentReportDAL iCommentReportDAL)
        {
            _iCommentReportDAL = iCommentReportDAL;
        }

        public CommentReport AddCommentReport(CommentReport report)
        {
            return _iCommentReportDAL.AddCommentReport(report).Result.Value;
        }

        public List<CommentReport> GetAllCommentReports()
        {
            return _iCommentReportDAL.GetAllCommentReports().Result.Value;
        }

        public bool MarkCommentReportAsRead(int reportID)
        {
            return _iCommentReportDAL.MarkCommentReportAsRead(reportID).Result.Value;
        }
    }
}
