using mytown.Models.AppModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace mytown.Models
{
    public class AppPost
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int UserEntityID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int CityID { get; set; }
        public string CityName { get; set; }
        public List<ImagePath> ImageURLS { get; set; }
        public DateTime Date { get; set; }
        public int Likes { get; set; }
        public int Comments { get; set; }
        public string CategoryName { get; set; }
        public double Rating { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public bool LikedByUser { get; set; }
        public DateTime? EndDate { get; set; }
        public string UserProfilePhotoURL { get; set; }
        public bool AcceptedByTheUser { get; set; }
        public int SolvedByTheUser { get; set; }
        public int TypeID { get; set; }
    }
}
