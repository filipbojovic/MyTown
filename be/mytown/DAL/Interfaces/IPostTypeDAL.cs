using mytown.Models.DbModels;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace mytown.DAL.Interfaces
{
    public interface IPostTypeDAL
    {
        Task<ActionResult<List<PostType>>> GetAllPostTypes();
    }
}
