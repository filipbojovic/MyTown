using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface IRankBL
    {
        List<Rank> GetAllRanks();
        Rank GetRankForGivenPoints(int points);
        Rank AddNewRank(Rank rank, string image);
        bool DeleteRank(int rankID);
        Rank ChangeRankData(RankVM rank);
        bool ChangeRankLogo(int rankID, string image);
    }
}
