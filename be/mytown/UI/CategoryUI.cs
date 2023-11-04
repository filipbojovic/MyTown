using mytown.BL.Interfaces;
using mytown.Models;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.UI
{
    public class CategoryUI : ICategoryUI
    {
        private readonly ICategoryBL _iCategoryBL;

        public CategoryUI(ICategoryBL iCategoryBL)
        {
            _iCategoryBL = iCategoryBL;
        }

        public async Task<ActionResult<IEnumerable<Category>>> GetAllCategories()
        {
            return await _iCategoryBL.GetAllCategories();
        }
    }
}
