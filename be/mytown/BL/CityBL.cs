using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using mytown.Models.ViewModels;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class CityBL : ICityBL
    {
        private readonly ICityDAL _iCityDAL;
        private readonly IPostDAL _iPostDAL;
        public CityBL(ICityDAL iCityDAL, IPostDAL iPostDAL)
        {
            _iCityDAL = iCityDAL;
            _iPostDAL = iPostDAL;
        }

        public List<City> GetAllCities()
        {
            return _iCityDAL.GetAllCities().Result.Value
                .OrderBy(c => c.Name)
                .ToList();
        }

        public List<CityStats> GetAllCitiesStats()
        {
            List<CityStats> list = new List<CityStats>();
            var posts = _iPostDAL.GetAllDbPosts().Result.Value;
            var cities = GetAllCities();

            foreach (var city in cities)
            {
                list.Add(new CityStats
                {
                    Id = city.Id,
                    Name = city.Name,
                    NumberOfChallenges = posts.
                        Where(p => p.TypeID == (int)Enums.PostEntityType.CHALLENGE && p.CityID == city.Id)
                        .Count()
                });
            }

            return list;
        }
    }
}
