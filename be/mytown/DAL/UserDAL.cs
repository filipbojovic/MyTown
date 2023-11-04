using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class UserDAL : IUserDAL
    {
        private readonly AppDbContext _context;

        public UserDAL(AppDbContext context)
        {
            _context = context;
        }
        public async Task<ActionResult<IEnumerable<User>>> GetAllUsers()
        {
            return await _context.User.Include(c => c.City).Include(c => c.ProfilePhoto).ToListAsync();
        }
        public async Task<ActionResult<User>> AddUser(User user)
        {
            _context.User.Add(user);
            await _context.SaveChangesAsync();
            return user;
        }
        public async Task<ActionResult<User>> GetUserByID(int id)
        {
            return await _context.User
                .Include(u => u.City)
                .Include(u => u.ProfilePhoto)
                .Include(u => u.AcceptedChallenges)
                .Include(u => u.Gender)
                .FirstOrDefaultAsync(p => p.Id == id);
        }

        public async Task<ActionResult<User>> UpdateUserInfo(UserVM userVM)
        {
            var userToEdit = await _context.User.FindAsync(userVM.Id);

            userToEdit.FirstName = userVM.FirstName;
            userToEdit.LastName = userVM.LastName;
            userToEdit.Email = userVM.Email;
            userToEdit.CityID = userVM.CityID;

            await _context.SaveChangesAsync();
            return userToEdit;
        }

        public async Task<ActionResult<bool>> UpdateUserPassword(int userID, string oldPassword, string newPassword)
        {
            var userToEdit = await _context.User.FindAsync(userID);
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

        public async Task<ActionResult<bool>> CheckUserExistance(int userID)
        {
            var user = await _context.User.FindAsync(userID);
            if (user == null)
                return false;
            else
                return true;
        }
    }
}
