using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface ICommentReportDAL
    {
        Task<ActionResult<List<CommentReport>>> GetAllCommentReports();
        Task<ActionResult<CommentReport>> AddCommentReport(CommentReport report);
        Task<ActionResult<bool>> MarkCommentReportAsRead(int reportID);
    }
}
