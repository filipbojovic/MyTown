using mytown.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.UI.Interfaces
{
    public interface ICategoryUI
    {
        Task<ActionResult<IEnumerable<Category>>> GetAllCategories();
    }
}
