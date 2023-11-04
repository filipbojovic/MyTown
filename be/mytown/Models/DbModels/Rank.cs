namespace mytown.Models.DbModels
{
    public class Rank
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int StartPoint { get; set; }
        public int? EndPoint { get; set; }
        public string Path { get; set; }
        public string FileName { get; set; }
    }
}
