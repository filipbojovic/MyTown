using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface ICommentReportUI
    {
        CommentReport AddCommentReport(CommentReport report);
        List<CommentReport> GetAllCommentReports();
        bool MarkCommentReportAsRead(int reportID);
    }
}
