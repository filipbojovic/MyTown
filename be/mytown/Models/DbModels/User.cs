using mytown.Models.DbModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models
{
    [Table("User")]
    public class User
    {
        [Key]
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string  Email { get; set; }
        public int CityID { get; set; }
        public int? ProfilePhotoID { get; set; }
        public DateTime BirthDay { get; set; }
        public int GenderID { get; set; }
        public DateTime? JoinDate { get; set; }
        public string Password { get; set; }
        public string FullName { get { return FirstName +" " +LastName; } }

        [ForeignKey("GenderID")]
        public GenderType Gender { get; set; }
        public virtual City City { get; set; }
        [ForeignKey("ProfilePhotoID")]
        public virtual UserEntityImage ProfilePhoto { get; set; }
        public virtual List<AcceptedChallenge> AcceptedChallenges { get; set; }
        public virtual List<Post> Posts { get; set; }
        public virtual List<Comment> Comments { get; set; }
        [ForeignKey("Id")]
        public virtual UserEntity UserEntity { get; set; }
    }
}

