using System.ComponentModel.DataAnnotations;

namespace mytown.Models.DbModels
{
    public class UserEntityImage
    {
        [Key]
        public int Id { get; set; }
        public int UserEntityID { get; set; }
        public string Path { get; set; }
        public string Name { get; set; }
    }
}
