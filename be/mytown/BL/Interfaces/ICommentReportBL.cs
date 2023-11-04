using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface ICommentReportBL
    {
        List<CommentReport> GetAllCommentReports();
        CommentReport AddCommentReport(CommentReport report);
        bool MarkCommentReportAsRead(int reportID);
    }
}
