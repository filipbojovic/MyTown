using mytown.Models;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IAcceptedChallengeDAL
    {
        Task<ActionResult<AcceptedChallenge>> AddAcceptedChallenge(AcceptedChallenge challenge);
        Task<ActionResult<bool>> DeleteAcceptedChallenge(int postEntityID, int userEntityID);
        Task<ActionResult<List<Post>>> GetAcceptedChallengesByUserID(int userID);
        Task<ActionResult<AcceptedChallenge>> GetAcceptedChallengeByPK(int postEntityID, int userEntityID);
        Task<ActionResult<bool>> ChangeStatus(int postEntityID, int userEntityID, int status);
        Task<ActionResult<int>> GetWithdrawalNumber(int userEntityID);
        Task<ActionResult<List<int>>> UsersWhoAcceptedChallenge(int postEntityID, int userID);
    }
}
