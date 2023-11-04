using System;
using mytown.Data;
using mytown.Models;
using mytown.Models.ViewModels;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserUI _iUserUI;
        private readonly IConfiguration _config;
        private readonly IUserEntityImageUI _iUserEntityImageUI;
        public UserController(IUserUI iUserUI, IConfiguration config, IUserEntityImageUI iUserEntityImageUI)
        {
            _iUserUI = iUserUI;
            _config = config;
            _iUserEntityImageUI = iUserEntityImageUI;
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public IActionResult GetAllUsers()
        {
            try
            {
                return Ok(_iUserUI.GetAllUsers());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("appUsers")]
        public IActionResult GetAllAppUsers()
        {
            try
            {
                return Ok(_iUserUI.GetAllAppUsers());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [Route("login")]
        [HttpPost]
        public IActionResult LoginValidation(string email, string password)
        {
            try
            {
                var user = _iUserUI.LoginValidation(email, password);

                if (user != null)
                {
                    var tokenStr = Token.GenerateJSONWebToken(user, _config);
                    return Ok(tokenStr);
                }
                else
                    return NotFound("Bad combination email/password");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpPost("registration")]
        public IActionResult AddNewUser(User user, String password)
        {
            try
            {
                var res = _iUserUI.AddUser(user, password);
                if (res != null)
                    return CreatedAtAction("addNewUser", new { id = user.Id }, user);
                else
                    return Conflict();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Admin, Institution")]
        [HttpGet("{id}")]
        public IActionResult GetUserByID(int id)
        {
            var res = _iUserUI.GetUserByID(id);
            if (res != null)
                return Ok(res);
            else
                return NotFound(res);
        }

        [Authorize(Roles = "User, Admin, Institution")]
        [HttpGet("profile/{id}")]
        public IActionResult GetAppUserByID(int id)
        {
            var res = _iUserUI.GetAppUserByID(id);
            if (res != null)
                return Ok(res);
            else
                return NotFound(res);
        }

        [Authorize(Roles = "User")]
        [HttpPut("updateUserInfo")]
        public IActionResult UpdateUserInfo(UserVM userVM)
        {
            try
            {
                var res = _iUserUI.UpdateUserInfo(userVM);
                if (res != null)
                    return CreatedAtAction("UpdateUserInfo", res);
                else
                    return Conflict();
            }
            catch (DbUpdateConcurrencyException e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPut("updateUserPassword")]
        public IActionResult UpdateUserPassword(int userID, string oldPassword, string newPassword)
        {
            try
            {
                var res = _iUserUI.UpdateUserPassword(userID, oldPassword, newPassword);
                if (res)
                    return NoContent();
                else
                    return Conflict("Bad password");
            }
            catch (DbUpdateConcurrencyException e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("changeProfilePhoto")]
        public IActionResult ChangeProfilePhoto([FromForm(Name = "file")] IFormFile image, [FromForm(Name = "userEntityID")] int userEntityID)
        {
            try
            {
                var res = _iUserEntityImageUI.ChangeUserProfilePicture(image, userEntityID);
                if (res)
                    return CreatedAtAction("ChangeProfilePhoto", image);
                else
                    return UnprocessableEntity();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User")]
        [HttpPost("deleteProfilePhoto/{userEntityID}")]
        public IActionResult DeleteProfilePhoto(int userEntityID)
        {
            try
            {
                var res = _iUserEntityImageUI.DeleteUserProfilePhoto(userEntityID);
                if (!res)
                    return NotFound("User doest not have profile photo");

                return Ok("Deleted");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "User, Admin")]
        [HttpGet("top10")]
        public IActionResult Top10Users()
        {
            try
            {
                return Ok(_iUserUI.GetTop10UsersByEcoFPoints());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("filterUsers")]
        public IActionResult GetFilteredUsers(string filterText, int cityID)
        {
            try
            {
                return Ok(_iUserUI.GetFilteredUsersAdminPage(filterText, cityID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet("userExistance")]
        public IActionResult CheckUserExistance(int userID)
        {
            try
            {
                return Ok(_iUserUI.CheckUserExistance(userID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}