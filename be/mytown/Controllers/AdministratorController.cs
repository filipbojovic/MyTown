using System;
using Microsoft.AspNetCore.Mvc;
using mytown.Data;
using mytown.Models.DbModels;
using mytown.UI.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Authorization;

namespace mytown.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdministratorController : ControllerBase
    {
        private readonly IAdministratorUI _iAdministratorUI;
        private readonly IInstitutionUI _iInstitutionUI;
        private readonly IConfiguration _config;
        public AdministratorController(IAdministratorUI iAdministratorUI, IInstitutionUI iInstitutionUI, IConfiguration config)
        {
            _iAdministratorUI = iAdministratorUI;
            _iInstitutionUI = iInstitutionUI;
            _config = config;
        }

        [HttpPost("login")]
        public IActionResult WebLoginValidation(string email, string password)
        {
            try
            {
                var admin = _iAdministratorUI.AdministratorValidation(email, password);

                if (admin != null)
                {
                    var tokenStr = Token.GenerateJSONWebTokenAdministrator(admin, _config);
                    return Ok(tokenStr);
                }
                else
                {
                    var institution = _iInstitutionUI.InstitutionValidation(email, password);
                    if (institution != null)
                    {
                        var tokenStr = Token.GenerateJSONWebTokenInstitution(institution, _config);
                        return Ok(tokenStr);
                    }
                    else
                        return NotFound(null);
                }
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public IActionResult GetAllAdministrators()
        {
            try
            {
                return Ok(_iAdministratorUI.GetAllAdministrators());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public IActionResult AddAdministrator(Administrator administrator)
        {
            try
            {
                var res = _iAdministratorUI.AddAdministrator(administrator.Email, administrator.Username, administrator.Password);
                if (res != null)
                    return CreatedAtAction("AddAdministrator", res);
                else
                    return Conflict();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("delete/{id}")]
        public IActionResult DeleteAdministrator(int userEntityID)
        {
            try
            {
                return Ok(_iAdministratorUI.DeleteAdministrator(userEntityID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("statistic")]
        public IActionResult GetDashboardStatistic()
        {
            try
            {
                return Ok(_iAdministratorUI.GetStatisticForDashboard());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("{adminID}")]
        public IActionResult GetAdministratorByID(int adminID)
        {
            try
            {
                return Ok(_iAdministratorUI.GetAdministratorByID(adminID));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("filterAdministrators")]
        public IActionResult GetFilteredUsers(string filterText)
        {
            try
            {
                return Ok(_iAdministratorUI.GetFilteredAdministrators(filterText));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("changeAdminPassword")]
        public IActionResult ChangeAdminPassword(int adminID, string oldPassword, string newPassword)
        {
            try
            {
                var res = _iAdministratorUI.ChangePassword(adminID, oldPassword, newPassword);
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
    }
}
