using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models.DbModels
{
    public class PostLike
    {
        public int PostID { get; set; }
        public int UserID { get; set; }

        [ForeignKey("UserID")]
        public virtual User User { get; set; }
        public virtual Post Post { get; set; }
    }
}
