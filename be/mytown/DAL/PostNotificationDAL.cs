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
    public class PostNotificationDAL : IPostNotificationDAL
    {
        private readonly AppDbContext _context;

        public PostNotificationDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<PostNotification>> AddPostNotification(PostNotification notification)
        {
            _context.PostNotification.Add(notification);
            await _context.SaveChangesAsync();
            //_context.Entry(notification).State = EntityState.Detached;
            return notification;
        }

        public async Task<ActionResult<bool>> DeletePostNotification(int PostID, int userEntityID, int notificationTypeID)
        {
            var notification = await _context.PostNotification.
                Where(e => e.PostID == PostID && e.SenderID == userEntityID && e.NotificationTypeID == notificationTypeID)
                .FirstOrDefaultAsync();
            if (notification == null)
                return false;
            _context.PostNotification.Remove(notification);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<List<PostNotification>>> GetAllPostNotificationsByUserID(int userEntityID)
        {
            return await _context.PostNotification
                .Where(n => n.ReceiverID == userEntityID)
                .Include(n => n.Sender.ProfilePhoto)
                .Include(n => n.Sender.Gender)
                .Include(n => n.Receiver.ProfilePhoto)
                .Include(n => n.Post)
                .ToListAsync();
        }
        public async Task<ActionResult<PostNotification>> GetPostNotificationByID(int postNotificationID)
        {
            return await _context.PostNotification
                .Where(c => c.Id == postNotificationID)
                .Include(c => c.Sender.ProfilePhoto)
                .Include(n => n.Sender.Gender)
                .Include(c => c.Receiver.ProfilePhoto)
                .Include(c => c.Post)
                .FirstOrDefaultAsync();
        }

        public async Task<ActionResult<bool>> MakeAllNotificationsRead(int userID)
        {
            var notifs = GetAllPostNotificationsByUserID(userID).Result.Value;

            foreach (var item in notifs)
                item.Read = true;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
