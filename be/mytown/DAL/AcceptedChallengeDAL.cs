using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class AcceptedChallengeDAL : IAcceptedChallengeDAL
    {
        private readonly AppDbContext _context;
        public AcceptedChallengeDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<AcceptedChallenge>> AddAcceptedChallenge(AcceptedChallenge challenge)
        {
            _context.AcceptedChallenge.Add(challenge);
            await _context.SaveChangesAsync();
            return challenge;
        }

        public async Task<ActionResult<bool>> DeleteAcceptedChallenge(int postEntityID, int userEntityID)
        {
            try
            {
                var challenge = await _context.AcceptedChallenge.FindAsync(postEntityID, userEntityID);
                challenge.Status = (int)Enums.ChallengeStatus.GAVE_UP;
                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }
        public async Task<ActionResult<List<Post>>> GetAcceptedChallengesByUserID(int userID)
        {
            var challenges = await _context.AcceptedChallenge.Where(ac => ac.UserEntityID == userID).Select(ac => ac.PostID).ToListAsync();
            return await _context.Post.Where(c => challenges.Contains(c.Id)).ToListAsync();
        }

        public async Task<ActionResult<AcceptedChallenge>> GetAcceptedChallengeByPK(int postEntityID, int userEntityID)
        {
            return await _context.AcceptedChallenge.FindAsync(postEntityID, userEntityID);
        }

        public async Task<ActionResult<bool>> ChangeStatus(int postEntityID, int userEntityID, int status)
        {
            var challenge = await _context.AcceptedChallenge.FindAsync(postEntityID, userEntityID);

            if (challenge != null)
            {
                challenge.Status = status;
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<ActionResult<int>> GetWithdrawalNumber(int userEntityID)
        {
            var res = await _context.AcceptedChallenge
                .Where(ac => ac.UserEntityID == userEntityID && ac.Status == (int)Enums.ChallengeStatus.GAVE_UP)
                .ToListAsync();
            return res.Count();
        }

        public async Task<ActionResult<List<int>>> UsersWhoAcceptedChallenge(int postEntityID, int userID)
        {
            return await _context.AcceptedChallenge
                .Where(ac => ac.PostID == postEntityID && ac.UserEntityID != userID)
                .Select(ac => ac.UserEntityID)
                .ToListAsync();
        }
    }
}
