using mytown.BL.Interfaces;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class AcceptedChallengeUI : IAcceptedChallengeUI
    {
        private readonly IAcceptedChallengeBL _iAcceptedChallengeBL;

        public AcceptedChallengeUI(IAcceptedChallengeBL iAcceptedChallengeBL)
        {
            _iAcceptedChallengeBL = iAcceptedChallengeBL;
        }

        public AcceptedChallenge AddAcceptedChallenge(AcceptedChallenge challenge)
        {
            return _iAcceptedChallengeBL.AddAcceptedChallenge(challenge);
        }

        public bool DeleteAcceptedChallenge(int postEntityID, int userEntityID)
        {
            return _iAcceptedChallengeBL.DeleteAcceptedChallenge(postEntityID, userEntityID);
        }
        public List<AppAcceptedChallenge> GetAcceptedChallengesByUserID(int userID)
        {
            return _iAcceptedChallengeBL.GetAcceptedChallengesByUserID(userID);
        }
    }
}
