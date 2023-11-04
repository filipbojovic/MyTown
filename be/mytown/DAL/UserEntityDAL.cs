using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Mvc;
using MimeKit;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class UserEntityDAL : IUserEntityDAL
    {
        private readonly AppDbContext _context;

        public UserEntityDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<UserEntity>> AddUserEntity(UserEntity userEntity)
        {
            _context.UserEntity.Add(userEntity);
            await _context.SaveChangesAsync();
            return userEntity;
        }

        public async Task<ActionResult<bool>> DeleteUserEntity(int userEntityID)
        {
            var userEntity = await _context.UserEntity.FindAsync(userEntityID);

            if (userEntity == null)
                return false;

            _context.UserEntity.Remove(userEntity);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<UserEntity>> GetUserEntityByID(int userEntityID)
        {
            return await _context.UserEntity.FindAsync(userEntityID);
        }

        public async Task<ActionResult<bool>> GenerateUserPassword(string email, int userTypeID)
        {
            dynamic user;

            user = _context.User
                    .Where(u => u.Email.Equals(email))
                    .FirstOrDefault();
            if (user == null)
            {
                user = _context.Administrator
                    .Where(u => u.Email.Equals(email))
                    .FirstOrDefault();

                if (user == null)
                {
                    user = _context.Institution
                        .Where(u => u.Email.Equals(email))
                        .FirstOrDefault();
                }
            }

            if (user != null)
            {

                string password = SHA256.GenerateRandomPassword();

                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("Moj grad", "mojgrad.srb.rs@gmail.com"));
                message.To.Add(new MailboxAddress("Moj grad", user.Email));
                message.Subject = "Moj grad - nova lozinka";
                message.Body = new TextPart("plain")
                {
                    Text = "Poštovani,\n\nZatražili ste da Vam pošaljemo novu lozinku pomoću koje možete da pristupite aplikaciji \"Moj Grad\".\n" +
                    "lozinka: " + password + "\n\n\nHvala Vam što koristite našu aplikaciju."
                };
                using (var client = new SmtpClient())
                {
                    client.Connect("smtp.gmail.com", 587, false);
                    client.Authenticate("mojgrad.srb.rs@gmail.com", "MojGrad123");
                    client.Send(message);
                    client.Disconnect(true);
                }

                string newPassword = SHA256.CreateSHA256Hash(password);

                user.Password = newPassword;
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
