using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models.DbModels
{
    public class Institution
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int? LogoID { get; set; } 
        public int HeadquaterID { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public DateTime JoinDate { get; set; }
        public string Password { get; set; }

        [ForeignKey("HeadquaterID")]
        public virtual City City { get; set; }

        [ForeignKey("LogoID")]
        public UserEntityImage Logo { get; set; }
        public virtual List<Post> Posts { get; set; }
        public virtual List<Comment> Comments{ get; set; }
        [ForeignKey("Id")]
        public virtual UserEntity UserEntity { get; set; }
    }
}
