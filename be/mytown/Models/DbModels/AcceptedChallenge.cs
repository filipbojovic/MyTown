using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models.DbModels
{
    public class AcceptedChallenge
    {
        public int PostID { get; set; }
        public int UserEntityID { get; set; }
        public int Status { get; set; }

        [ForeignKey("UserEntityID")]
        public virtual User User { get; set; }
    }
}
