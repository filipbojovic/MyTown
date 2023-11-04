using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IPostReportDAL
    {
        Task<ActionResult<List<PostReport>>> GetAllPostReports();
        Task<ActionResult<PostReport>> AddPostReport(PostReport report);
        Task<ActionResult<bool>> MarkPostReportAsRead(int reportID);
    }
}
