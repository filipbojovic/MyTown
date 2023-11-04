using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface IPostReportBL
    {
        List<PostReport> GetAllPostReports();
        PostReport AddPostReport(PostReport report);
        List<AppReport> GetAllAppReports();
        bool MarkPostReportAsRead(int reportID);
    }
}
