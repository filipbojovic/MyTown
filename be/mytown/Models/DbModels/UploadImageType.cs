using System.ComponentModel.DataAnnotations;

namespace mytown.Models
{
    public class UploadImageType
    {
        [Key]
        public int Id { get; set; }
        public string Name { get; set; }
    }
}
