using mytown.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface ICategoryDAL
    {
        Task<ActionResult<IEnumerable<Category>>> GetAllCategories();
        Task<ActionResult<Category>> getCategoryByID(int id);
    }
}
