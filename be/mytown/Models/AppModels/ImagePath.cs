using System.ComponentModel.DataAnnotations;

namespace mytown.Models.AppModels
{
    public class ImagePath
    {
        [Key]
        public int Id { get; set; }
        public string Path { get; set; }
    }
}
