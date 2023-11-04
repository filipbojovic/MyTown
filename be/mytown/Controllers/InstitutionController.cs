using System;
using mytown.Data;
using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InstitutionController : ControllerBase
    {
        private readonly IInstitutionUI _iInstitutionUI;
        private readonly IUserEntityImageUI _iUserEntityImageUI;
        private readonly IConfiguration _config;
        public InstitutionController(IInstitutionUI iInstitutionUI, IUserEntityImageUI iUserEntityImageUI, IConfiguration config)
        {
            _iInstitutionUI = iInstitutionUI;
            _iUserEntityImageUI = iUserEntityImageUI;
            _config = config;
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public IActionResult getAllInstitutions()
        {
            try
            {
                return Ok(_iInstitutionUI.getAllInstitutions());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpPost("login")]
        public IActionResult InstitutionValidation(string email, string password)
        {
            try
            {
                Institution user = _iInstitutionUI.InstitutionValidation(email, password);
                if (user != null)
                {
                    var tokenStr = Token.GenerateJSONWebTokenInstitution(user, _config);
                    return Ok(tokenStr);
                }
                else
                    return NotFound("Bad password");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public IActionResult AddInstitution(Institution institution)
        {
            try
            {
                var res = _iInstitutionUI.AddInstitution(institution, institution.Password);
                if (res != null)
                    return CreatedAtAction("AddInstitution", res);
                else
                    return Conflict();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("delete")]
        public IActionResult DeleteInstitution(int userEntityID)
        {
            try
            {
                return Ok(_iInstitutionUI.DeleteInstitution(userEntityID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Institution")]
        [HttpPost("changePassword")]
        public IActionResult ChangePassword(int userEntityID, string oldPassword, string newPassword)
        {
            try
            {
                var res = _iInstitutionUI.ChangePassword(userEntityID, oldPassword, newPassword);
                if (res)
                    return NoContent();
                else
                    return Conflict("Bad password");
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Institution")]
        [HttpPost("changeData")]
        public IActionResult ChangeData(int userEntityID, string name, int headquaterID, string address, string email, string phone)
        {
            try
            {
                var res = _iInstitutionUI.ChangeData(userEntityID, name, headquaterID, address, email, phone);
                if (res)
                    return NoContent();
                else
                    return Conflict();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Institution, Admin")]
        [HttpGet("getAppInstitution/{userEntityID}")]
        public IActionResult GetAppInstitution(int userEntityID)
        {
            try
            {
                return Ok(_iInstitutionUI.GetAppInstitution(userEntityID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Institution")]
        [HttpPost("changeProfilePhoto")]
        public IActionResult ChangeInstitutionProfilePhoto(InstitutionProfilePhotoVM inst)
        {
            try
            {
                return Conflict(_iUserEntityImageUI.ChangeInstitutionProfilePhoto(inst.UserEntityID, inst.Image));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("appInstitutions")]
        public IActionResult GetAllAppInstitutions()
        {
            try
            {
                return Ok(_iInstitutionUI.GetAllAppInstitutions());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("filterInstitutions")]
        public IActionResult GetFilteredUsers(string filterText, int cityID)
        {
            try
            {
                return Ok(_iInstitutionUI.GetFilteredInstitutions(filterText, cityID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}