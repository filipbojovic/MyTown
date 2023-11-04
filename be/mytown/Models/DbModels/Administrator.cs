using System;
using System.ComponentModel.DataAnnotations;

namespace mytown.Models.DbModels
{
    public class Administrator
    {
        [Key]
        public int Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public DateTime JoinDate { get; set; }
        public string Password { get; set; }
        public bool Head { get; set; }
    }
}
