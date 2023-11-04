using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IRankDAL
    {
        Task<ActionResult<List<Rank>>> GetAllRanks();
        Task<ActionResult<Rank>> AddNewRank(Rank rank, string image);
        Task<ActionResult<bool>> AddRankImages(Rank rank, string image);
        Task<ActionResult<bool>> DeleteRank(int rankID);
        Task<ActionResult<Rank>> ChangeRankData(RankVM rank);
        Task<ActionResult<bool>> ChangeRankLogo(int rankID, string image);
    }
}
