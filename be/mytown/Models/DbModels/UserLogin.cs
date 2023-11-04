namespace mytown.Models
{
    public class UserLogin
    {
        public int Id { get; set; }
        public int UserID { get; set; }
        public byte[] Password { get; set; }
        public byte[] Salt { get; set; }
        public int Parallelism { get; set; }
        public int Iterations { get; set; }
        public int Memory { get; set; }
    }
}
