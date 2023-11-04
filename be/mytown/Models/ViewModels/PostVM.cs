using System;

namespace mytown.Models.ViewModels
{
    public class PostVM
    {
        public int Id { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
