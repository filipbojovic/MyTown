using mytown.Models;
using mytown.Models.ViewModels.Statistic;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.BL.Interfaces
{
    public interface ICategoryBL
    {
        Task<ActionResult<IEnumerable<Category>>> GetAllCategories();
        List<CategoryStats> GetAllCategoryStats();
    }
}
