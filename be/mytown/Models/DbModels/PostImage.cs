using System.ComponentModel.DataAnnotations;

namespace mytown.Models
{
    public class PostImage
    {
        [Key]
        public int Id { get; set; }
        public int PostID { get; set; }
        public string Path { get; set; }
        public string Name { get; set; }
    }
}
