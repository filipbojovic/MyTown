using System;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReportController : ControllerBase
    {
        private readonly IPostReportUI _iPostReportUI;
        private readonly ICommentReportUI _iCommentReportUI;

        public ReportController(IPostReportUI iPostReportUI, ICommentReportUI iCommentReportUI)
        {
            _iPostReportUI = iPostReportUI;
            _iCommentReportUI = iCommentReportUI;
        }

        [Authorize(Roles = "User")]
        [HttpPost("postReport")]
        public IActionResult AddPostReport(PostReport report)
        {
            try
            {
                _iPostReportUI.AddPostReport(report);
                return CreatedAtAction("AddPostReport", new { id = report.Id }, report);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
        [Authorize(Roles = "User")]
        [HttpPost("commentReport")]
        public IActionResult AddCommentReport(CommentReport report)
        {
            try
            {
                _iCommentReportUI.AddCommentReport(report);
                return CreatedAtAction("AddCommentReport", new { id = report.Id }, report);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("appReport")]
        public IActionResult GetAllAppReports()
        {
            try
            {
                return Ok(_iPostReportUI.GetAllAppReports());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
        [Authorize(Roles = "Admin")]
        [HttpPost("markPostReportAsRead")]
        public IActionResult MarkPostReportAsRead(int reportID)
        {
            try
            {
                return Ok(_iPostReportUI.MarkPostReportAsRead(reportID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
        [Authorize(Roles = "Admin")]
        [HttpPost("markCommentReportAsRead")]
        public IActionResult MarkCommentReportAsRead(int reportID)
        {
            try
            {
                return Ok(_iCommentReportUI.MarkCommentReportAsRead(reportID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

    }
}