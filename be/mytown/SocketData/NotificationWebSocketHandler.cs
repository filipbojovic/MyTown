using mytown.Models.DbModels;
using Microsoft.Extensions.DependencyInjection;
using System.Net.WebSockets;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using mytown.Data;
using System.Text;
using mytown.DAL;
using mytown.Models.AppModels;
using mytown.Models.ViewModels;

namespace mytown.SocketData
{
    public class NotificationWebSocketHandler : WebSocketHandler
    {
        private readonly IServiceScopeFactory _service;
        private readonly CommentNotificationDAL _commentNotificationDAL;
        private readonly PostNotificationDAL _PostNotificationDAL;
        private readonly PostDAL _postDAL;
        private readonly AcceptedChallengeDAL _acceptedChallengeDAL;
        public AppDbContext _context;

        public NotificationWebSocketHandler(WebSocketConnectionManager webSocketConnectionManager, IServiceScopeFactory service) : base(webSocketConnectionManager)
        {
            _service = service;
            _context = _service.CreateScope().ServiceProvider.GetService<AppDbContext>();
            _commentNotificationDAL = new CommentNotificationDAL(_context);
            _PostNotificationDAL = new PostNotificationDAL(_context);
            _acceptedChallengeDAL = new AcceptedChallengeDAL(_context);
            _postDAL = new PostDAL(_context);
        }

        public override async Task ReceiveAsync(WebSocket socket, WebSocketReceiveResult result, byte[] buffer) //kada primi zahtev, odgovori
        {
            CommentNotification data = JsonConvert.DeserializeObject<CommentNotification>(Encoding.ASCII.GetString(buffer, 0, result.Count));

            if (data.SenderID == 0)
                await SendMessageAsync(data.ReceiverID.ToString(), JObject.FromObject(new { ReceiverID = 2 }));
            else if (data.NotificationTypeID == (int)Enums.NotificationType.POST_LIKE)
            {
                PostNotification postNotification = new PostNotification
                {
                    ReceiverID = data.ReceiverID,
                    SenderID = data.SenderID,
                    PostID = data.PostID,
                    NotificationTypeID = data.NotificationTypeID,
                    Date = data.Date,
                    Read = false
                };

                var notification = GetPostNotificationAsync(postNotification);
                await SendMessageAsync(postNotification.ReceiverID.ToString(), notification.Result);

            }
            else
            {
                var notifs = GetCommentNotificationAsync(data).Result;
                var notification = notifs.Notification;
                await SendMessageAsync(data.ReceiverID.ToString(), notification);

                if (data.NotificationTypeID == (int)Enums.NotificationType.NEW_PROPOSAL)
                {
                    var userIDs = await _acceptedChallengeDAL.UsersWhoAcceptedChallenge(data.PostID, data.SenderID);
                    foreach (var item in userIDs.Value)
                        await SendMessageAsync(item.ToString(), notifs.SecondNotification);
                }
            }
        }

        private async Task<NotificationVM> GetCommentNotificationAsync(CommentNotification commentNotif)
        {
            await _commentNotificationDAL.AddCommentNotification(commentNotif); //add notification to database
            var fullInfo = await _commentNotificationDAL.GetCommentNotificationByID(commentNotif.Id); //get notification data back with ID and other stuffs like full UserData

            string notificationText;
            int postType = _postDAL.GetPostTypeID(commentNotif.PostID).Result.Value;
            switch (commentNotif.NotificationTypeID)
            {
                case (int)Enums.NotificationType.COMMENT_LIKE:
                    notificationText = postType == (int)Enums.PostEntityType.CHALLENGE ?
                        (fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " je ocenio Vaše rešenje." : " je ocenila Vaše rešenje.") :
                        (fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " se izjasnio da mu se sviđa Vaš komentar." : " se izjasnila da joj se sviđa Vaš komentar.");
                    break;
                case (int)Enums.NotificationType.COMMENT_REPLY:
                    notificationText = postType == (int)Enums.PostEntityType.CHALLENGE ?
                        (fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " je postavio odgovor na Vaše rešenje." : " je postavila odgovor na Vaše rešenje.") :
                        (fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " je postavio odgovor na Vaš komentar." : " je postavila odgovor na Vaš komentar.");
                    break;
                case (int)Enums.NotificationType.NEW_COMMENT:
                    notificationText =
                        fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " je prokomentarisao Vašu objavu." : " je prokomentarisala Vašu objavu.";
                    break;
                case (int)Enums.NotificationType.NEW_PROPOSAL:
                    notificationText =
                        fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " je postavio rešenje Vašeg izazova." : " je postavila rešenje Vašeg izazova.";
                    break;
                case (int)Enums.NotificationType.ADDED_PROPOSAL:
                    notificationText =
                        fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " je postavio rešenje izazova koji pratite." : " je postavila rešenje izazova koji pratite.";
                    break;
                default:
                    notificationText = "";
                    break;
            }

            AppNotification appN = new AppNotification
            {
                Header = fullInfo.Value.Sender.FirstName + " " + fullInfo.Value.Sender.LastName + notificationText,
                PostID = fullInfo.Value.PostID,
                Date = fullInfo.Value.Date,
                PostImage = null,
                NotificationType = fullInfo.Value.NotificationTypeID,
                UserProfilePhoto = new ImagePath
                {
                    Path = fullInfo.Value.Sender.ProfilePhoto != null ?
                    fullInfo.Value.Sender.ProfilePhoto.Path + fullInfo.Value.Sender.ProfilePhoto.Name :
                    Enums.defaultProfilePhotoURL
                }
            };

            AppNotification appN2 = new AppNotification
            {
                Header = fullInfo.Value.Sender.FirstName + " " + fullInfo.Value.Sender.LastName + (fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " je postavio rešenje izazova koji pratite." : " je postavila rešenje izazova koji pratite."),
                PostID = fullInfo.Value.PostID,
                Date = fullInfo.Value.Date,
                PostImage = null,
                NotificationType = (int)Enums.NotificationType.ADDED_PROPOSAL,
                UserProfilePhoto = new ImagePath
                {
                    Path = fullInfo.Value.Sender.ProfilePhoto != null ?
                    fullInfo.Value.Sender.ProfilePhoto.Path + fullInfo.Value.Sender.ProfilePhoto.Name :
                    Enums.defaultProfilePhotoURL
                }
            };
            return new NotificationVM
            {
                Notification = JObject.FromObject(appN),
                SecondNotification = appN.NotificationType == (int)Enums.NotificationType.NEW_PROPOSAL ? JObject.FromObject(appN2) : null
            };
        }

        private async Task<JObject> GetPostNotificationAsync(PostNotification postNotif)
        {
            await _PostNotificationDAL.AddPostNotification(postNotif); //add notification to database
            var fullInfo = await _PostNotificationDAL.GetPostNotificationByID(postNotif.Id); //get notification data back with ID and other stuffs like full UserData

            string message = fullInfo.Value.Post.TypeID == (int)Enums.PostEntityType.CHALLENGE ?
                (fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " se izjasnio da mu se sviđa Vaš izazov." : " se izjasnila da joj se sviđa Vaš izazov.") :
                (fullInfo.Value.Sender.Gender.Name.Equals("Male") ? " se izjasnio da mu se sviđa Vaša objava." : " se izjasnila da joj se sviđa Vaša objava.");

            AppNotification appN = new AppNotification
            {
                Header = "Korisniku " + fullInfo.Value.Sender.FirstName + " " + fullInfo.Value.Sender.LastName + message,
                PostID = fullInfo.Value.PostID,
                Date = fullInfo.Value.Date,
                PostImage = null,
                NotificationType = fullInfo.Value.NotificationTypeID,
                UserProfilePhoto = new ImagePath
                {
                    Path = fullInfo.Value.Sender.ProfilePhoto != null ?
                    fullInfo.Value.Sender.ProfilePhoto.Path + fullInfo.Value.Sender.ProfilePhoto.Name :
                    Enums.defaultProfilePhotoURL
                }
            };
            return JObject.FromObject(appN);
        }


    }
}
