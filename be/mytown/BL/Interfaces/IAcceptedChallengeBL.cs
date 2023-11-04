using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface IAcceptedChallengeBL
    {
        AcceptedChallenge AddAcceptedChallenge(AcceptedChallenge challenge);
        bool DeleteAcceptedChallenge(int postEntityID, int userEntityID);
        List<AppAcceptedChallenge> GetAcceptedChallengesByUserID(int userID);
        int GetWithdrawalNumber(int userEntityID);
    }
}
