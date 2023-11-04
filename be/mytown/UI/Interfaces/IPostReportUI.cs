using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface IPostReportUI
    {
        PostReport AddPostReport(PostReport report);
        List<PostReport> GetAllPostReports();
        List<AppReport> GetAllAppReports();
        bool MarkPostReportAsRead(int reportID);
    }
}
