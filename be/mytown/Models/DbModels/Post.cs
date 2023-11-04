using mytown.Models.DbModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace mytown.Models
{
    public class Post
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int UserEntityID { get; set; }
        public DateTime Date { get; set; }
        public int CityID { get; set; }
        public int? CategoryID { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public DateTime? EndDate { get; set; }
        public int TypeID { get; set; }

        public virtual Category Category { get; set; }
        [ForeignKey("UserEntityID")]
        public virtual User User { get; set; }

        [ForeignKey("CityID")]
        public virtual City City { get; set; }

        [ForeignKey("UserEntityID")]
        public virtual Institution Institution { get; set; }
        [ForeignKey("TypeID")]
        public virtual PostType Type { get; set; }
        public virtual List<PostLike> Likess { get; set; }
    }
}
