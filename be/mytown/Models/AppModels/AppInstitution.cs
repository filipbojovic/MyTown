using System;

namespace mytown.Models.AppModels
{
    public class AppInstitution
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int HeadquaterID { get; set; }
        public string HeadquaterName { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public DateTime JoinDate { get; set; }
        public string ImageURL { get; set; }
        public int NumOfPosts { get; set; }
    }
}
