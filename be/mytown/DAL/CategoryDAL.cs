using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class CategoryDAL : ICategoryDAL
    {
        private readonly AppDbContext _context;

        public CategoryDAL(AppDbContext context)
        {
            _context = context;
        }
        public async Task<ActionResult<IEnumerable<Category>>> GetAllCategories()
        {
            return await _context.Category.ToListAsync();
        }
        public async Task<ActionResult<Category>> getCategoryByID(int id)
        {
            return await _context.Category.FindAsync(id);
        }
    }
}
