using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class CommentReportDAL : ICommentReportDAL
    {
        private readonly AppDbContext _context;

        public CommentReportDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<CommentReport>> AddCommentReport(CommentReport report)
        {
            _context.CommentReport.Add(report);
            await _context.SaveChangesAsync();
            return report;
        }

        public async Task<ActionResult<List<CommentReport>>> GetAllCommentReports()
        {
            return await _context.CommentReport
                .Include(cr => cr.ReportedUser)
                .Include(cr => cr.Comment)
                .Include(cr => cr.Post)
                .Include(cr => cr.Sender)
                .ToListAsync();
        }

        public async Task<ActionResult<bool>> MarkCommentReportAsRead(int reportID)
        {
            var rep = _context.CommentReport.FindAsync(reportID);
            rep.Result.Read = true;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
