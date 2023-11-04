using mytown.BL.Interfaces;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class PostReportUI : IPostReportUI
    {
        private readonly IPostReportBL _iPostReportBL;

        public PostReportUI(IPostReportBL iPostReportBL)
        {
            _iPostReportBL = iPostReportBL;
        }

        public PostReport AddPostReport(PostReport report)
        {
            return _iPostReportBL.AddPostReport(report);
        }

        public List<AppReport> GetAllAppReports()
        {
            return _iPostReportBL.GetAllAppReports();
        }

        public List<PostReport> GetAllPostReports()
        {
            return _iPostReportBL.GetAllPostReports();
        }

        public bool MarkPostReportAsRead(int reportID)
        {
            return _iPostReportBL.MarkPostReportAsRead(reportID);
        }
    }
}
