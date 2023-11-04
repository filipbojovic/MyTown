using mytown.Models.DbModels;
using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models.AppModels
{
    public class CommentLike
    {
        public int CommentID { get; set; }
        public int PostID { get; set; }
        public int UserEntityID { get; set; }
        public int Value { get; set; }

        public virtual Comment Comment { get; set; }

        [ForeignKey("UserEntityID")]
        public virtual User User { get; set; }
    }
}
