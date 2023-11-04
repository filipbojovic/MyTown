using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class CityDAL : ICityDAL
    {
        private readonly AppDbContext _context;

        public CityDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<List<City>>> GetAllCities()
        {
            return await _context.City.ToListAsync();
        }
    }
}
