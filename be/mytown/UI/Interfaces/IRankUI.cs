using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using System.Collections.Generic;

namespace mytown.UI.Interfaces
{
    public interface IRankUI
    {
        List<Rank> GetAllRanks();
        Rank AddNewRank(Rank rank, string image);
        bool DeleteRank(int rankID);
        Rank ChangeRankData(RankVM rank);
        bool ChangeRankLogo(int rankID, string image);
    }
}
