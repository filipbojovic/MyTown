using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class RankBL : IRankBL
    {
        private readonly IRankDAL _iRankDAL;

        public RankBL(IRankDAL iRankDAL)
        {
            _iRankDAL = iRankDAL;
        }

        public Rank AddNewRank(Rank rank, string image)
        {
            return _iRankDAL.AddNewRank(rank, image).Result.Value;
        }

        public Rank ChangeRankData(RankVM rank)
        {
            return _iRankDAL.ChangeRankData(rank).Result.Value;
        }

        public bool ChangeRankLogo(int rankID, string image)
        {
            return _iRankDAL.ChangeRankLogo(rankID, image).Result.Value;
        }

        public bool DeleteRank(int rankID)
        {
            return _iRankDAL.DeleteRank(rankID).Result.Value;
        }

        public List<Rank> GetAllRanks()
        {
            return _iRankDAL.GetAllRanks().Result.Value;
        }

        public Rank GetRankForGivenPoints(int points)
        {
            var ranks = _iRankDAL.GetAllRanks();
            if (points < 0)
                points = 0;
            var rank = ranks
                .Result
                .Value
                .Where(r => (r.StartPoint <= points && r.EndPoint >= points) || (r.StartPoint <= points && r.EndPoint == null))
                .FirstOrDefault();

            if (rank == null)
                rank = ranks.Result.Value.OrderByDescending(r => r.StartPoint).First();
            return rank;
        }
    }
}
