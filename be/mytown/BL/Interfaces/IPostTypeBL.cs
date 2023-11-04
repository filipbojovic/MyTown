using mytown.Models.DbModels;
using mytown.Models.ViewModels.Statistic;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface IPostTypeBL
    {
        List<PostType> GetAllPostTypes();
        List<TypeStats> GetPostTypeStats();
    }
}
