using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class NotificationBL : INotificationBL
    {
        private readonly ICommentNotificationDAL _iCommentNotificationDAL;
        private readonly IPostNotificationDAL _iPostNotificationDAL;

        public NotificationBL(ICommentNotificationDAL iCommentNotificationDAL, IPostNotificationDAL iPostNotificationDAL)
        {
            _iCommentNotificationDAL = iCommentNotificationDAL;
            _iPostNotificationDAL = iPostNotificationDAL;
        }

        public bool AddCommentNotification(CommentNotification commentNotif)
        {
            return _iCommentNotificationDAL.AddCommentNotification(commentNotif) != null;
        }

        public bool AddPostNotification(PostNotification entityNotif)
        {
            return _iPostNotificationDAL.AddPostNotification(entityNotif) != null;
        }

        public bool DeleteCommentNotification(int commentID, int PostID, int userID, int notificationTypeID)
        {
            return _iCommentNotificationDAL.DeleteCommentNotification(commentID, PostID, userID, notificationTypeID).Result.Value;
        }

        public bool DeletePostNotification(int PostID, int userID, int notificationType)
        {
            return _iPostNotificationDAL.DeletePostNotification(PostID, userID, notificationType).Result.Value;
        }

        public bool CheckUnreadNotification(int userID)
        {
            var commentNotifications = _iCommentNotificationDAL.GetAllCommentNotificationsByUserID(userID).Result.Value;
            var postNotifications = _iPostNotificationDAL.GetAllPostNotificationsByUserID(userID).Result.Value;
            return (commentNotifications.Where(c => c.Read == false).Count() > 0 || postNotifications.Where(p => p.Read == false).Count() > 0);
        }
        
        public bool MakeAllNotificationsAsRead(int userID)
        {
            return (_iCommentNotificationDAL.MakeAllNotificationsRead(userID).Result.Value 
                && _iPostNotificationDAL.MakeAllNotificationsRead(userID).Result.Value);
        }



        public List<AppNotification> GetAllNotificationsByUserID(int userEntityID)
        {
            var notifications = _iCommentNotificationDAL.GetAllCommentNotificationsByUserID(userEntityID).Result.Value;

            var commentNotificationsByPost = notifications.Where(cn => cn.NotificationTypeID == (int)Enums.NotificationType.NEW_COMMENT
                || cn.NotificationTypeID == (int)Enums.NotificationType.NEW_PROPOSAL || cn.NotificationTypeID == (int)Enums.NotificationType.ADDED_PROPOSAL)
                .GroupBy(c => new {c.PostID, c.NotificationTypeID });

            var commentNotifications = notifications.Where(cn => cn.NotificationTypeID != (int)Enums.NotificationType.NEW_COMMENT
                && cn.NotificationTypeID != (int)Enums.NotificationType.NEW_PROPOSAL && cn.NotificationTypeID != (int)Enums.NotificationType.ADDED_PROPOSAL)
                .GroupBy(c => new { c.CommentID, c.PostID, c.NotificationTypeID }); 

            var PostNotifications = _iPostNotificationDAL
                .GetAllPostNotificationsByUserID(userEntityID)
                .Result
                .Value
                .GroupBy(c => new { c.PostID, c.NotificationTypeID });

            List<AppNotification> appNotifications = new List<AppNotification>();

            //-----------------grouping comments by post----------------------------------------------------
            foreach (var item in commentNotificationsByPost) //list of lists
            {
                var itemList = item.ToList().OrderByDescending(i => i.Date).ToList();
                var newestNotif = item.OrderByDescending(i => i.Date).ToList().FirstOrDefault();
                int entityType = newestNotif.Post.TypeID; //challenge or default post
                string header;
                string commentType = "";
                if (item.Count() > 2)
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.NEW_COMMENT:
                            commentType = " su prokomentarisali Vašu objavu.";
                            break;
                        case (int)Enums.NotificationType.NEW_PROPOSAL:
                            commentType = " su postavili rešenja Vašeg izazova.";
                            break;
                        case (int)Enums.NotificationType.ADDED_PROPOSAL:
                            commentType = " su postavili rešenja izazova koji pratite.";
                            break;
                        default: break;
                    }
                    int userCount = item.Count() - 1;
                    header = newestNotif.Sender.FirstName + " " + newestNotif.Sender.LastName
                        + " i " + userCount + " drugih korisnika " + commentType;
                }
                else if (item.Count() == 2)
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.NEW_COMMENT:
                            commentType = " su prokomentarisali Vašu objavu.";
                            break;
                        case (int)Enums.NotificationType.NEW_PROPOSAL:
                            commentType = " su postavili rešenja Vašeg izazova.";
                            break;
                        case (int)Enums.NotificationType.ADDED_PROPOSAL:
                            commentType = " su postavili rešenja izazova koji pratite.";
                            break;
                        default:
                            break;
                    }
                    header = itemList[0].Sender.FirstName + " " + itemList[0].Sender.LastName + " i " + itemList[1].Sender.FirstName + " " + itemList[1].Sender.LastName
                        + commentType;
                }
                else
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.NEW_COMMENT:
                            commentType =
                                newestNotif.Sender.Gender.Name.Equals("Male") ? " je prokomentarisao Vašu objavu." : " je prokomentarisala Vašu objavu.";
                            break;
                        case (int)Enums.NotificationType.NEW_PROPOSAL:
                            commentType =
                                newestNotif.Sender.Gender.Name.Equals("Male") ? " je postavio rešenje Vašeg izazova." : " je postavila rešenje Vašeg izazova.";
                            break;
                        case (int)Enums.NotificationType.ADDED_PROPOSAL:
                            commentType =
                                newestNotif.Sender.Gender.Name.Equals("Male") ? " je postavio rešenje izazova koji pratite." : " je postavila rešenje izazova koji pratite.";
                            break;
                        default:
                            break;
                    }
                    header = newestNotif.Sender.FirstName + " " + newestNotif.Sender.LastName + commentType;
                }

                appNotifications.Add(new AppNotification
                {
                    Header = header,
                    PostID = item.Key.PostID,
                    Date = newestNotif.Date,
                    UserProfilePhoto = new ImagePath 
                    { Path = newestNotif.Sender.ProfilePhoto != null ? 
                        newestNotif.Sender.ProfilePhoto.Path + newestNotif.Sender.ProfilePhoto.Name :
                        Enums.defaultProfilePhotoURL
                    },
                });
            }

            //-----------------------grouping comments by like, reply and addedProposal----------------------------
            foreach (var item in commentNotifications) //list of lists
            {
                var itemList = item.ToList().OrderByDescending(i => i.Date).ToList();
                var newestNotif = item.OrderByDescending(i => i.Date).ToList().FirstOrDefault();
                int entityType = newestNotif.Post.TypeID; //challenge or default post
                string header;
                string commentType = "";
                if(item.Count() > 2) 
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.COMMENT_LIKE:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? "su ocenili Vaše rešenje." : "su se izjasnili da im se sviđa Vaš komentar."; 
                            break;
                        case (int)Enums.NotificationType.COMMENT_REPLY:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? "su postavili odgovor na Vaše rešenje." : "su postavili odgovor na Vaš komentar."; 
                            break;
                        case (int)Enums.NotificationType.ADDED_PROPOSAL:
                            commentType = "su postavili rešenja izazova koji pratite.";
                            break;
                        default:break;
                    }
                    int userCount = item.Count() - 1;
                    header = newestNotif.Sender.FirstName + " " + newestNotif.Sender.LastName
                        + " i " + userCount + " drugih korisnika " + commentType;
                }
                else if(item.Count() == 2)
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.COMMENT_LIKE:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? " su ocenili Vaše rešenje." : " su se izjasnili da im se sviđa Vaš komentar.";
                            break;
                        case (int)Enums.NotificationType.COMMENT_REPLY:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? " su postavili odgovor na Vaše rešenje." : " su postavili odgovor na Vaš komentar.";
                            break;
                        case (int)Enums.NotificationType.ADDED_PROPOSAL:
                            commentType = "su postavili rešenja izazova koji pratite.";
                            break;
                        default:
                            break;
                    }
                    header = itemList[0].Sender.FirstName + " " + itemList[0].Sender.LastName +" i " + itemList[1].Sender.FirstName + " " + itemList[1].Sender.LastName
                        + commentType;
                }
                else
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.COMMENT_LIKE:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? " je ocenio Vaše rešenje." : " se izjasnio da mu se sviđa Vaš komentar.";
                            break;
                        case (int)Enums.NotificationType.COMMENT_REPLY:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? " je postavio odgovor na Vaše rešenje." : " je postavio odgovor na Vaš komentar.";
                            break;
                        default:
                            break;
                    }
                    header = newestNotif.Sender.FirstName + " " + newestNotif.Sender.LastName + commentType;
                }

                appNotifications.Add(new AppNotification
                {
                    Header = header,
                    PostID = item.Key.PostID,
                    Date = newestNotif.Date,
                    UserProfilePhoto = new ImagePath { Path = newestNotif.Sender.ProfilePhoto != null ? 
                    newestNotif.Sender.ProfilePhoto.Path + newestNotif.Sender.ProfilePhoto.Name : 
                    Enums.defaultProfilePhotoURL},
                });
            }
            //--------------------------------ENTITIES--------------------------------------
            foreach (var item in PostNotifications) //list of lists
            {
                var itemList = item.ToList().OrderByDescending(i => i.Date).ToList();
                var newestNotif = item.OrderByDescending(i => i.Date).ToList().FirstOrDefault();
                int entityType = newestNotif.Post.TypeID; //challenge or default post
                string header;
                string commentType = "";
                if (item.Count() > 2)
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.POST_LIKE:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? " su se izjasnili da im se sviđa Vaš izazov." : "su se izjasnili da im se sviđa Vaša objava.";
                            break;
                        default: break;
                    }
                    int userCount = item.Count() - 1;
                    header = newestNotif.Sender.FirstName + " " + newestNotif.Sender.LastName
                        + " i " + userCount + " drugih korisnika " + commentType;
                }
                else if (item.Count() == 2)
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.POST_LIKE:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ? " su se izjasnili da im se sviđa Vaš izazov." : "su se izjasnili da im se sviđa Vaša objava.";
                            break;
                        default:
                            break;
                    }
                    
                    header = itemList[0].Sender.FirstName + " " + itemList[0].Sender.LastName + " i " + itemList[1].Sender.FirstName + " " + itemList[1].Sender.LastName
                        + commentType;
                }
                else
                {
                    switch (item.Key.NotificationTypeID)
                    {
                        case (int)Enums.NotificationType.POST_LIKE:
                            commentType = entityType == (int)Enums.PostEntityType.CHALLENGE ?
                                (newestNotif.Sender.Gender.Name.Equals("Male") ? " se izjasnio da mu se sviđa Vaš izazov." : " se izjasnila da joj se sviđa Vaš izazov.") :
                                (newestNotif.Sender.Gender.Name.Equals("Male") ? " se izjasnio da mu se sviđa Vaša objava." : " se izjasnila da joj se sviđa Vaša objava.");
                            break;
                        default:
                            break;
                    }
                    header = newestNotif.Sender.FirstName + " " + newestNotif.Sender.LastName + commentType;
                }

                appNotifications.Add(new AppNotification
                {
                    Header = header,
                    PostID = item.Key.PostID,
                    Date = newestNotif.Date,
                    UserProfilePhoto = new ImagePath { Path = newestNotif.Sender.ProfilePhoto != null ?
                        newestNotif.Sender.ProfilePhoto.Path + newestNotif.Sender.ProfilePhoto.Name :
                        Enums.defaultProfilePhotoURL
                    },
                });
            }


            MakeAllNotificationsAsRead(userEntityID);
            return appNotifications.OrderByDescending(n => n.Date).ToList();
        }

    }
}
