using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class PostTypeDAL : IPostTypeDAL
    {
        private readonly AppDbContext _context;

        public PostTypeDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<List<PostType>>> GetAllPostTypes()
        {
            return await _context.PostType.ToListAsync();
        }
    }
}
