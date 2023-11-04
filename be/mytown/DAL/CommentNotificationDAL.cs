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
    public class CommentNotificationDAL : ICommentNotificationDAL
    {
        private readonly AppDbContext _context;
        public CommentNotificationDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<CommentNotification>> AddCommentNotification(CommentNotification notification)
        {
            _context.CommentNotification.Add(notification);
            await _context.SaveChangesAsync();
            //_context.Entry(notification).State = EntityState.Detached;
            return notification;
        }

        public async Task<ActionResult<bool>> DeleteCommentNotification(int commentID, int PostID, int userEntityID, int notificationTypeID)
        {
            var notification = await _context.CommentNotification.
                Where(c => c.CommentID == commentID && c.PostID == PostID &&
                    c.SenderID == userEntityID && c.NotificationTypeID == notificationTypeID)
                .FirstOrDefaultAsync();
            if (notification == null)
                return false;
            _context.CommentNotification.Remove(notification);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<List<CommentNotification>>> GetAllCommentNotificationsByUserID(int userEntityID)
        {
            return await _context.CommentNotification
                .Where(n => n.ReceiverID == userEntityID)
                .Include(n => n.Sender.ProfilePhoto)
                .Include(n => n.Sender.Gender)
                .Include(n => n.Receiver.ProfilePhoto)
                .Include(n => n.Comment)
                .Include(n => n.Post)
                .ToListAsync();
        }

        public async Task<ActionResult<CommentNotification>> GetCommentNotificationByID(int commentNotificationID)
        {
            return await _context.CommentNotification
                .Where(c => c.Id == commentNotificationID)
                .Include(n => n.Sender.ProfilePhoto)
                .Include(n => n.Sender.Gender)
                .Include(n => n.Receiver.ProfilePhoto)
                .Include(n => n.Comment)
                .Include(n => n.Post)
                .FirstOrDefaultAsync();

        }

        public async Task<ActionResult<bool>> MakeAllNotificationsRead(int userID)
        {
            var notifs = GetAllCommentNotificationsByUserID(userID).Result.Value;

            foreach (var item in notifs)
                item.Read = true;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
