using Newtonsoft.Json.Linq;

namespace mytown.Models.ViewModels
{
    public class NotificationVM
    {
        public JObject Notification{ get; set; }
        public JObject SecondNotification { get; set; }
    }
}
