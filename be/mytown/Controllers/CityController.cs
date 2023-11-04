using System;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CityController : ControllerBase
    {
        private readonly ICityUI _iCityUI;

        public CityController(ICityUI iCityUI)
        {
            _iCityUI = iCityUI;
        }

        public IActionResult GetAllCities()
        {
            try
            {
                return Ok(_iCityUI.GetAllCities());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}