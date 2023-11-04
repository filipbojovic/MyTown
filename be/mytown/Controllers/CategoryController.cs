using System.Collections.Generic;
using System.Threading.Tasks;
using mytown.Models;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly ICategoryUI _iCategoryUI;

        public CategoryController(ICategoryUI iCategoryUI)
        {
            _iCategoryUI = iCategoryUI;
        }

        [Authorize(Roles = "User, Institution, Admin")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Category>>> GetAllCategories()
        {
            return await _iCategoryUI.GetAllCategories();
        }
    }
}