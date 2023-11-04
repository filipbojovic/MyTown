using mytown.Data;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;

namespace bot_be.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ImageUploadController : ControllerBase
    {
        public static IWebHostEnvironment _environment;
        private readonly IPostImageUI _iUploadImageUI;
        private readonly AppDbContext _context;

        public ImageUploadController(IWebHostEnvironment enviroment, IPostImageUI iUploadImageUI, AppDbContext context)
        {
            _environment = enviroment;
            _iUploadImageUI = iUploadImageUI;
            _context = context;
        }

        [HttpGet("{id}")]
        public IActionResult GetImagesByPostID(int id)
        {
            return Ok(_iUploadImageUI.GetImagesByPostID(id));
        }
    }
}