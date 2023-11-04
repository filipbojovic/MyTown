using System;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserEntityController : ControllerBase
    {
        private readonly IUserEntityUI _iUserEntityUI;

        public UserEntityController(IUserEntityUI iUserEntityUI)
        {
            _iUserEntityUI = iUserEntityUI;
        }

        [HttpPost]
        public IActionResult AddUserEntity(UserEntity userEntity)
        {
            try
            {
                _iUserEntityUI.AddUserEntity(userEntity);
                return CreatedAtAction("AddUserEntity", new { id = userEntity.Id }, userEntity);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("delete/{id}")]
        public IActionResult DeleteUserEntity(int id)
        {
            try
            {
                var res = _iUserEntityUI.DeleteUserEntity(id);
                if (res)
                    return Ok(res);
                else
                    return NotFound(res);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpPost("resetUserPassword")]
        public IActionResult GenerateRandomPassword(string email, int userTypeID)
        {
            try
            {
                var res = _iUserEntityUI.GenerateUserPassword(email, userTypeID);
                if (res)
                    return CreatedAtAction("GenerateRandomPassword", true);
                else
                    return NotFound("User does not exists");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}