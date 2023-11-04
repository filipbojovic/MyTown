using mytown.Models.ViewModels.Statistic;
using System.Collections.Generic;

namespace mytown.Models.ViewModels
{
    public class AdministratorStats
    {
        public List<UserStats> Users { get; set; }
        public List<CityStats> Cities { get; set; }
        public List<CategoryStats> Categories { get; set; }
        public List<TypeStats> Types { get; set; }
        public int NumberOfPosts { get; set; }
        public int NumberOfChallenges { get; set; }
        public int NumberOfUsers { get; set; }
    }
}
