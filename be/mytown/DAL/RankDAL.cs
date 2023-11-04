using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.Models.DbModels;
using mytown.Models.ViewModels;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace mytown.DAL
{
    public class RankDAL : IRankDAL
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _environment;
        public RankDAL(AppDbContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        public async Task<ActionResult<Rank>> AddNewRank(Rank rank, string image)
        {
            _context.Add(rank);
            await _context.SaveChangesAsync();

            await AddRankImages(rank, image);

            return rank;
        }

        public async Task<ActionResult<bool>> AddRankImages(Rank rank, string image)
        {
            try
            {
                string mainFolder = "/rank/";

                if (image == "" || image == null)
                    return null;
                if (!Directory.Exists(_environment.WebRootPath + mainFolder))
                    Directory.CreateDirectory(_environment.WebRootPath + mainFolder);

                if (!Directory.Exists(_environment.WebRootPath + mainFolder))
                    Directory.CreateDirectory(_environment.WebRootPath + mainFolder);

                rank.Path = mainFolder;
                rank.FileName = rank.Id.ToString() + ".png";
                await _context.SaveChangesAsync();

                //adding to server
                byte[] bytes = Convert.FromBase64String(image);
                var path = mainFolder + rank.Id.ToString() + ".png";
                var filePath = Path.Combine(_environment.WebRootPath + path);
                System.IO.File.WriteAllBytes(filePath, bytes);
                return true;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public async Task<ActionResult<Rank>> ChangeRankData(RankVM data)
        {
            var rank = await _context.Rank.FindAsync(data.Id);

            if (rank == null)
                return null;

            rank.Name = data.Name;
            rank.StartPoint = data.StartPoint;
            rank.EndPoint = data.EndPoint;

            await _context.SaveChangesAsync();
            return rank;
        }

        public async Task<ActionResult<bool>> ChangeRankLogo(int rankID, string image)
        {
            var rank = await _context.Rank.FindAsync(rankID);

            if (rank == null)
                return false;

            byte[] bytes = Convert.FromBase64String(image);
            var path = rank.Path + rank.Id.ToString() + ".png";
            var filePath = Path.Combine(_environment.WebRootPath + path);
            System.IO.File.WriteAllBytes(filePath, bytes);
            return true;
        }

        public async Task<ActionResult<bool>> DeleteRank(int rankID)
        {
            var rank = await _context.Rank.FindAsync(rankID);

            if (rank == null)
                return false;

            _context.Rank.Remove(rank);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<ActionResult<List<Rank>>> GetAllRanks()
        {
            return await _context.Rank.ToListAsync();
        }
    }
}
