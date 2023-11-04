using mytown.BL.Interfaces;
using mytown.DAL.Interfaces;
using mytown.Models.DbModels;
using mytown.Models.ViewModels.Statistic;
using System.Collections.Generic;
using System.Linq;

namespace mytown.BL
{
    public class PostTypeBL : IPostTypeBL
    {
        private readonly IPostTypeDAL _iPostTypeDAL;
        private readonly IPostBL _iPostBL;

        public PostTypeBL(IPostTypeDAL iPostTypeDAL, IPostBL iPostBL)
        {
            _iPostTypeDAL = iPostTypeDAL;
            _iPostBL = iPostBL;
        }

        public List<PostType> GetAllPostTypes()
        {
            return _iPostTypeDAL.GetAllPostTypes().Result.Value;
        }

        public List<TypeStats> GetPostTypeStats()
        {
            var types = GetAllPostTypes();
            var posts = _iPostBL.GetAllDbPosts().Result.Value;

            List<TypeStats> list = new List<TypeStats>();

            foreach (var item in types)
                list.Add(new TypeStats
                {
                    Id = item.Id,
                    Name = item.Name,
                    NumOfPosts = posts.Where(p => p.TypeID == item.Id).Count()
                });

            return list;
        }
    }
}
