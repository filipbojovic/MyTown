using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class PostDAL : IPostDAL
    {
        private readonly AppDbContext _context;

        public PostDAL(AppDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<Post>> AddPost(Post post)
        {
            _context.Post.Add(post);
            await _context.SaveChangesAsync();

            return post;
        }

        public async Task<ActionResult<bool>> ChangePostData(PostVM newPost)
        {
            var post = await _context.Post.FindAsync(newPost.Id);

            if (post == null)
                return false;

            if (newPost.Title != null)
                post.Title = newPost.Title;
            if (newPost.Description != null)
                post.Description = newPost.Description;
            if (newPost.EndDate != null)
                post.EndDate = newPost.EndDate;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<bool>> DeletePost(int postID)
        {
            var post = await _context.Post.FindAsync(postID);

            if (post == null)
                return false;

            _context.Post.Remove(post);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<List<Post>>> GetAllDbPosts()
        {
            return await _context.Post
                .Include(p => p.Category)
                .Include(p => p.User)
                .Include(p => p.User.AcceptedChallenges)
                .Include(p => p.User.ProfilePhoto)
                .Include(p => p.Institution)
                .Include(p => p.Institution.Logo)
                .Include(p => p.Likess)
                .Include(p => p.City)
                .OrderByDescending(p => p.Id)
                .ToListAsync();
        }

        public async Task<ActionResult<Post>> GetDbPostByID(int id)
        {
            return await _context.Post
                .Include(p => p.Category)
                .Include(p => p.User)
                .Include(p => p.User.AcceptedChallenges)
                .Include(p => p.User.ProfilePhoto)
                .Include(p => p.Institution)
                .Include(p => p.Institution.Logo)
                .Include(p => p.Likess)
                .Include(p => p.City)
                .FirstOrDefaultAsync(p => p.Id == id);
        }

        public async Task<ActionResult<int>> GetNumberOfPostsByUserID(int userEntityID)
        {
            var posts = await _context.Post
                .Where(p => p.UserEntityID == userEntityID)
                .ToListAsync();
            return posts.Count();
        }

        public async Task<ActionResult<List<Post>>> GetPostsByUserID(int userID)
        {
            return await _context.Post
                .Include(p => p.Category)
                .Include(p => p.User)
                .Include(p => p.User.AcceptedChallenges)
                .Include(p => p.User.ProfilePhoto)
                .Include(p => p.Institution)
                .Include(p => p.Institution.Logo)
                .Include(p => p.Likess)
                .Include(p => p.City)
                .Where(p => p.UserEntityID == userID)
                .ToListAsync();
        }

        public async Task<ActionResult<int>> GetPostTypeID(int postID)
        {
            var post = await _context.Post.FindAsync(postID);
            //_context.Entry(post).State = EntityState.Detached;
            return post.TypeID;
        }

        public async Task<ActionResult<bool>> PostExistance(int postID)
        {
            var post = await _context.Post.FindAsync(postID);
            if (post != null)
                return true;
            else
                return false;
        }
    }
}
