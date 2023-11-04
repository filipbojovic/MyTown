using System;
using System.Net.WebSockets;
using System.Text;
using System.Threading.Tasks;
using mytown.BL;
using mytown.BL.Interfaces;
using mytown.DAL;
using mytown.DAL.Interfaces;
using mytown.Data;
using mytown.SocketData;
using mytown.UI;
using mytown.UI.Interfaces;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;

namespace mytown
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //----------------------FOR TOKEN----------------------
            //services.AddCors(options =>
            //{
            //    options.AddPolicy("CorsPolicy", builder => builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader().AllowCredentials().Build());
            //});

            //------------------------------------------------------------------------------

            //-------------FOR WEB SOCKET------------------------
            services.AddWebSocketManager();

            services.AddCors(options => options.AddPolicy("MyPolicy", builder =>
            {
                builder.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader();
            }));

            //-----------------------------FOR FOREIGN KEY REFERENCE---------------------------------------------
            services.AddControllers().AddNewtonsoftJson(options =>
                options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            );
            //------------------------------------------------------------------------------------------------------

            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = Configuration["Jwt:Issuer"],
                        ValidAudience = Configuration["Jwt:Issuer"],
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
                    };
                });
            services.AddMvc();
            //----------------------END OF TOKEN----------------------

            services.AddControllers();

            //------------------CONNECT TO THE DB-------------------------------------
            var connection = Configuration.GetConnectionString("DBConnection");
            services.AddDbContext<AppDbContext>(options => options.UseSqlite(connection));
            //------------------END OF THE DB DEFINITION------------------------------

            WireLayers(services);
        }
        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IServiceProvider serviceProvider)
        {
            //-------------------for sending image through html req---------------------------
            app.UseStaticFiles();
            //-------------------------------end-----------------------------------------------

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else //added for image upload
            {
                app.UseHsts();
            }

            app.UseWebSockets();
            var wsOptions = new WebSocketOptions()
            {
                KeepAliveInterval = TimeSpan.FromSeconds(120),
                ReceiveBufferSize = 4 * 1024
            };
            // Whitelist the allowed websocket connection ips
            wsOptions.AllowedOrigins.Add("ip");

            app.UseWebSockets(wsOptions);
            app.MapWebSocketManager("/student", serviceProvider.GetService<NotificationWebSocketHandler>());
            //--------------------------websocket end---------------------------

            app.UseHttpsRedirection();

            app.UseCors("MyPolicy"); //to allow API on WEB

            app.UseRouting();

            //----------------------TOKEN----------------------
            app.UseAuthentication();
            //----------------------END OF TOKEN----------------------

            app.UseAuthorization();

            //--------------------FOR IMAGE UPLOAD------------------
            //app.Run(async (context) =>
            //{
            //    await context.Response.WriteAsync("Could Not Find Anything");
            //});

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            //-------------------------END---------------------------
        }

        private Task Echo(HttpContext context, WebSocket webSocket)
        {
            throw new NotImplementedException();
        }

        private static void WireLayers(IServiceCollection services)
        {
            services.AddTransient<IPostUI, PostUI>();
            services.AddTransient<IPostBL, PostBL>();
            services.AddTransient<IPostDAL, PostDAL>();

            services.AddTransient<ICategoryUI, CategoryUI>();
            services.AddTransient<ICategoryBL, CategoryBL>();
            services.AddTransient<ICategoryDAL, CategoryDAL>();

            services.AddTransient<IUserUI, UserUI>();
            services.AddTransient<IUserBL, UserBL>();
            services.AddTransient<IUserDAL, UserDAL>();

            services.AddTransient<IPostImageUI, PostImageUI>();
            services.AddTransient<IPostImageBL, PostImageBL>();
            services.AddTransient<IPostImageDAL, PostImageDAL>();

            services.AddTransient<IUserEntityImageUI, UserEntityImageUI>();
            services.AddTransient<IUserEntityImageBL, UserEntityImageBL>();
            services.AddTransient<IUserEntityImageDAL, UserEntityImageDAL>();

            //services.AddTransient<ICommentImageUI, CommentImageUI>();
            services.AddTransient<ICommentImageBL, CommentImageBL>();
            services.AddTransient<ICommentImageDAL, CommentImageDAL>();

            services.AddTransient<IAdministratorUI, AdministratorUI>();
            services.AddTransient<IAdministratorBL, AdministratorBL>();
            services.AddTransient<IAdministratorDAL, AdministratorDAL>();

            services.AddTransient<ICommentUI, CommentUI>();
            services.AddTransient<ICommentBL, CommentBL>();
            services.AddTransient<ICommentDAL, CommentDAL>();

            services.AddTransient<ICommentLikeUI, CommentLikeUI>();
            services.AddTransient<ICommentLikeBL, CommentLikeBL>();
            services.AddTransient<ICommentLikeDAL, CommentLikeDAL>();

            services.AddTransient<IInstitutionUI, InstitutionUI>();
            services.AddTransient<IInstitutionBL, InstitutionBL>();
            services.AddTransient<IInstitutionDAL, InstitutionDAL>();

            services.AddTransient<IPostLikeUI, PostLikeUI>();
            services.AddTransient<IPostLikeBL, PostLikeBL>();
            services.AddTransient<IPostLikeDAL, PostLikeDAL>();

            services.AddTransient<IUserEntityUI, UserEntityUI>();
            services.AddTransient<IUserEntityBL, UserEntityBL>();
            services.AddTransient<IUserEntityDAL, UserEntityDAL>();

            services.AddTransient<ICityUI, CityUI>();
            services.AddTransient<ICityBL, CityBL>();
            services.AddTransient<ICityDAL, CityDAL>();

            services.AddTransient<IAcceptedChallengeUI, AcceptedChallengeUI>();
            services.AddTransient<IAcceptedChallengeBL, AcceptedChallengeBL>();
            services.AddTransient<IAcceptedChallengeDAL, AcceptedChallengeDAL>();

            services.AddTransient<ICommentNotificationDAL, CommentNotificationDAL>();

            services.AddTransient<IPostNotificationDAL, PostNotificationDAL>();

            services.AddTransient<INotificationBL, NotificationBL>();
            services.AddTransient<INotificationUI, NotificationUI>();

            services.AddTransient<IRankUI, RankUI>();
            services.AddTransient<IRankBL, RankBL>();
            services.AddTransient<IRankDAL, RankDAL>();

            services.AddTransient<IPostReportUI, PostReportUI>();
            services.AddTransient<IPostReportBL, PostReportBL>();
            services.AddTransient<IPostReportDAL, PostReportDAL>();

            services.AddTransient<ICommentReportUI, CommentReportUI>();
            services.AddTransient<ICommentReportBL, CommentReportBL>();
            services.AddTransient<ICommentReportDAL, CommentReportDAL>();

            services.AddTransient<IPostTypeBL, PostTypeBL>();
            services.AddTransient<IPostTypeDAL, PostTypeDAL>();
        }
    }
}
