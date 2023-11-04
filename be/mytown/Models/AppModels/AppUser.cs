using System;
using System.ComponentModel.DataAnnotations;

namespace mytown.Models.AppModels
{
    public class AppUser
    {
        [Key]
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public int EcoFPoints { get; set; }
        public string RankPhotoURL { get; set; }
        public string RankName { get; set; }
        public string City { get; set; }
        public int CityID { get; set; }
        public int NumOfPosts { get; set; }
        public int NumOfAcceptedChallenges { get; set; }
        public int NumOfSolvedChallenges { get; set; }
        public DateTime BirthDay { get; set; }
        public int GenderID { get; set; }
        public DateTime? JoinDate { get; set; }
        public string ProfilePhotoURL { get; set; }
        public bool UnreadNotification { get; set; }
    }
}
