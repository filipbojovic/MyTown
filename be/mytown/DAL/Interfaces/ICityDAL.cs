using mytown.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface ICityDAL
    {
        Task<ActionResult<List<City>>> GetAllCities();
    }
}
