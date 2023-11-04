using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class AdministratorDAL : IAdministratorDAL
    {
        private readonly AppDbContext _context;
        private readonly IUserEntityDAL _iUserEntityDAL;

        public AdministratorDAL(AppDbContext context, IUserEntityDAL iUserEntityDAL)
        {
            _context = context;
            _iUserEntityDAL = iUserEntityDAL;
        }

        public async Task<ActionResult<List<Administrator>>> getAllAdministrators()
        {
            return await _context.Administrator.ToListAsync();
        }

        public async Task<ActionResult<Administrator>> AdministratorValidation(string username, string password)
        {
            var administrator = await _context.Administrator.Where(a => a.Username.Equals(username) || a.Email.Equals(username)).FirstOrDefaultAsync();

            if (administrator == null)
                return null;

            if (SHA256.Verify256SHA(password, administrator.Password))
                return administrator;
            else
                return null;
        }

        public async Task<ActionResult<bool>> AddAdministrator(Administrator administrator)
        {
            _context.Administrator.Add(administrator);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<List<Administrator>>> GetAllAdministrators()
        {
            return await _context.Administrator.ToListAsync();
        }

        public async Task<ActionResult<bool>> DeleteAdministrator(int userEntityID)
        {
            return await _iUserEntityDAL.DeleteUserEntity(userEntityID);
        }

        public async Task<ActionResult<Administrator>> GetAdministratorByID(int adminID)
        {
            return await _context.Administrator.FindAsync(adminID);
        }

        public async Task<ActionResult<bool>> ChangePassword(int adminID, string oldPassword, string newPassword)
        {
            var admin = GetAdministratorByID(adminID).Result.Value;
            if (admin == null)
                return false;

            var passCheck = SHA256.Verify256SHA(oldPassword, admin.Password);

            if (!passCheck)
                return false;

            var password = SHA256.CreateSHA256Hash(newPassword);
            admin.Password = password;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
