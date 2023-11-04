using mytown.Models;
using mytown.Models.AppModels;
using mytown.Models.DbModels;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace mytown.Data
{
    public class AppDbContext : IdentityDbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //optionsBuilder.UseSqlite(@"Data source = mojgrad.db");
        }

        public virtual DbSet<Post> Post { get; set; }
        public virtual DbSet<Category> Category { get; set; }
        public virtual DbSet<User> User { get; set; }
        public virtual DbSet<UploadImageType> ImageType { get; set; }
        public virtual DbSet<PostImage> PostImage { get; set; }
        public virtual DbSet<UserEntityImage> UserEntityImage { get; set; }
        public virtual DbSet<Administrator> Administrator { get; set; }
        public virtual DbSet<Comment> Comment { get; set; }
        public virtual DbSet<CommentLike> CommentLike { get; set; }
        public virtual DbSet<CommentImage> CommentImage { get; set; }
        public virtual DbSet<City> City { get; set; }
        public virtual DbSet<Institution> Institution { get; set; }
        public virtual DbSet<PostLike> PostLike { get; set; }
        public virtual DbSet<UserEntity> UserEntity { get; set; }
        public virtual DbSet<AcceptedChallenge> AcceptedChallenge { get; set; }
        public virtual DbSet<PostNotification> PostNotification { get; set; }
        public virtual DbSet<CommentNotification> CommentNotification { get; set; }
        public virtual DbSet<Rank> Rank { get; set; }
        public virtual DbSet<PostReport> PostReport { get; set; }
        public virtual DbSet<CommentReport> CommentReport { get; set; }
        public virtual DbSet<GenderType> GenderType { get; set; }
        public virtual DbSet<PostType> PostType { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Comment>()
                .HasKey(c => new { c.Id, c.PostID });

            builder.Entity<CommentLike>()
                .HasOne(l => l.Comment)
                .WithMany(c => c.Likes)
                .HasForeignKey(l => new { l.CommentID, l.PostID });

            builder.Entity<CommentImage>()
                .HasOne(ci => ci.Comment)
                .WithMany(c => c.Images)
                .HasForeignKey(ci => new { ci.CommentID, ci.PostID });

            builder.Entity<CommentLike>()
                .HasKey(l => new { l.CommentID, l.PostID, l.UserEntityID });

            builder.Entity<PostLike>()
                .HasKey(pl => new { pl.PostID, pl.UserID });
            builder.Entity<PostLike>()
                .HasOne(pl => pl.Post)
                .WithMany(p => p.Likess)
                .HasForeignKey(pl => pl.PostID);

            builder.Entity<AcceptedChallenge>()
                .HasKey(ac => new { ac.PostID, ac.UserEntityID });
            builder.Entity<AcceptedChallenge>()
                .HasOne(ac => ac.User)
                .WithMany(u => u.AcceptedChallenges)
                .HasForeignKey(ac => ac.UserEntityID);

            builder.Entity<CommentNotification>()
                .HasOne(c => c.Comment)
                .WithMany(com => com.CommentNotifications)
                .HasForeignKey(c => new { c.CommentID, c.PostID });

            builder.Entity<User>()
                .HasMany(u => u.Posts)
                .WithOne(p => p.User)
                .IsRequired(false);
            builder.Entity<Institution>()
                .HasMany(i => i.Posts)
                .WithOne(p => p.Institution)
                .IsRequired(false);

            builder.Entity<User>()
                .HasMany(u => u.Comments)
                .WithOne(c => c.User)
                .IsRequired(false);
            builder.Entity<Institution>()
                .HasMany(i => i.Comments)
                .WithOne(c => c.Institution)
                .IsRequired(false);

            builder.Entity<CommentReport>()
                .HasOne(cr => cr.Comment)
                .WithMany(c => c.Reports)
                .HasForeignKey(cr => new { cr.CommentID, cr.PostID });

            builder.Entity<Post>()
                .HasOne(p => p.Category)
                .WithMany(c => c.Posts)
                .HasForeignKey(p => p.CategoryID)
                .IsRequired(false);
        }
    }
}
