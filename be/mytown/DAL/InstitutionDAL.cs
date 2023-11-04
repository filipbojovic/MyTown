using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class InstitutionDAL : IInstitutionDAL
    {
        private readonly AppDbContext _context;
        private readonly IUserEntityDAL _iUserEntityDAL;
        private readonly IUserDAL _iUserDAL;
        private readonly IAdministratorDAL _iAdministratorDAL;

        public InstitutionDAL(AppDbContext context, IUserEntityDAL iUserEntityDAL, IUserDAL iUserDAL, IAdministratorDAL iAdministratorDAL)
        {
            _context = context;
            _iUserEntityDAL = iUserEntityDAL;
            _iUserDAL = iUserDAL;
            _iAdministratorDAL = iAdministratorDAL;
        }

        public async Task<ActionResult<Institution>> AddInstitution(Institution institution)
        {
            _context.Institution.Add(institution);
            await _context.SaveChangesAsync();
            return institution;
        }

        public async Task<ActionResult<bool>> ChangeData(int userEntityID, string name, int headquaterID, string address, string email, string phone)
        {
            var userToEdit = await _context.Institution.FindAsync(userEntityID);
            if (userToEdit == null)
                return false;

            var users = _iUserDAL.GetAllUsers().Result.Value;
            var admins = _iAdministratorDAL.GetAllAdministrators().Result.Value;
            var institutions = getAllInstitutions().Result.Value;

            if (users.Where(u => u.Email.ToLower().Equals(email.ToLower())).FirstOrDefault() != null
                || admins.Where(a => a.Email.ToLower().Equals(email.ToLower())).FirstOrDefault() != null
                    || institutions.Where(i => i.Email.ToLower().Equals(email.ToLower()) && i.Id != userEntityID).FirstOrDefault() != null)
                return false;

            try
            {
                if (name != null)
                    userToEdit.Name = name;
                if (headquaterID != 0)
                    userToEdit.HeadquaterID = headquaterID;
                if (address != null)
                    userToEdit.Address = address;
                if (email != null)
                    userToEdit.Email = email;
                if (phone != null)
                    userToEdit.Phone = phone;
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public async Task<ActionResult<bool>> ChangePassword(int userEntityID, string oldPassword, string newPassword)
        {
            var userToEdit = await _context.Institution.FindAsync(userEntityID);
            if (userToEdit == null)
                return false;

            var passCheck = SHA256.Verify256SHA(oldPassword, userToEdit.Password);

            if (!passCheck)
                return false;

            var password = SHA256.CreateSHA256Hash(newPassword);
            userToEdit.Password = password;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<bool>> DeleteInstitution(int userEntityID)
        {
            return await _iUserEntityDAL.DeleteUserEntity(userEntityID);
        }

        public async Task<ActionResult<List<Institution>>> getAllInstitutions()
        {
            return await _context.Institution
                .Include(i => i.Logo)
                .Include(i => i.City)
                .ToListAsync();
        }

        public async Task<ActionResult<Institution>> GetInstitutionByID(int userEntityID)
        {
            return await _context.Institution
                .Include(i => i.Logo)
                .Include(i => i.City)
                .Where(i => i.Id == userEntityID)
                .FirstOrDefaultAsync();
        }
    }
}
