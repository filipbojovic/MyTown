using mytown.Models;
using mytown.Models.ViewModels;
using System.Collections.Generic;

namespace mytown.BL.Interfaces
{
    public interface ICityBL
    {
        List<City> GetAllCities();
        List<CityStats> GetAllCitiesStats();
    }
}
