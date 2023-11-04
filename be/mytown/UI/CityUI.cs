using mytown.BL.Interfaces;
using mytown.Models;
using mytown.UI.Interfaces;
using System.Collections.Generic;

namespace mytown.UI
{
    public class CityUI : ICityUI
    {
        private readonly ICityBL _iCityBL;

        public CityUI(ICityBL iCityBL)
        {
            _iCityBL = iCityBL;
        }

        public List<City> GetAllCities()
        {
            return _iCityBL.GetAllCities();
        }
    }
}
