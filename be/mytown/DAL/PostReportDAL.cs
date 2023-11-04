using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class PostReportDAL : IPostReportDAL
    {
        private readonly AppDbContext _context;

        public PostReportDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<PostReport>> AddPostReport(PostReport report)
        {
            _context.PostReport.Add(report);
            await _context.SaveChangesAsync();
            return report;
        }

        public async Task<ActionResult<List<PostReport>>> GetAllPostReports()
        {
            return await _context.PostReport
                .Include(pr => pr.ReportedUser)
                .Include(pr => pr.Sender)
                .Include(pr => pr.Post)
                .ToListAsync();
        }

        public async Task<ActionResult<bool>> MarkPostReportAsRead(int reportID)
        {
            var rep = _context.PostReport.FindAsync(reportID);
            rep.Result.Read = true;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
