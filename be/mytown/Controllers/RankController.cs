using System;
using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RankController : ControllerBase
    {
        private readonly IRankUI _iRankUI;

        public RankController(IRankUI iRankUI)
        {
            _iRankUI = iRankUI;
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public IActionResult GetAllRanks()
        {
            try
            {
                return Ok(_iRankUI.GetAllRanks());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("rankData")]
        public IActionResult ChangeRankData(RankVM data)
        {
            try
            {
                var res = _iRankUI.ChangeRankData(data);
                if (res != null)
                    return CreatedAtAction("ChangeRankData", data);
                else
                    return NotFound();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("rankLogo")]
        public IActionResult ChangeRankLogo(RankLogoVM rankLogo)
        {
            try
            {
                var res = _iRankUI.ChangeRankLogo(rankLogo.Id, rankLogo.Image);
                if (res)
                    return CreatedAtAction("ChangeRankLogo", true);
                else
                    return NotFound("Logo does not exists.");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("{rankID}")]
        public IActionResult DeleteRank(int rankID)
        {
            try
            {
                var res = _iRankUI.DeleteRank(rankID);
                if (res)
                    return Ok();
                else
                    return NotFound("Logo does not exists.");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public IActionResult AddRank(Rank rank)
        {
            try
            {
                var res = _iRankUI.AddNewRank(rank, rank.Path);
                if (res != null)
                    return CreatedAtAction("AddRank", res);
                else
                    return BadRequest("Something went wrong.");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}