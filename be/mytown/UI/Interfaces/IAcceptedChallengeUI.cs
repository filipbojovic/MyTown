using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface IAcceptedChallengeUI
    {
        AcceptedChallenge AddAcceptedChallenge(AcceptedChallenge challenge);
        bool DeleteAcceptedChallenge(int postEntityID, int userEntityID);
        List<AppAcceptedChallenge> GetAcceptedChallengesByUserID(int userID);
    }
}
