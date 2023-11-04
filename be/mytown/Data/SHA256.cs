using System;
using System.Text;

namespace mytown.Data
{
    public class SHA256
    {
        public static string CreateSHA256Hash(string password)
        {
            using (System.Security.Cryptography.SHA256 sha256Hash = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password));

                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }
        public static bool Verify256SHA(string password, string dbPassword)
        {
            string newPass = CreateSHA256Hash(password);
            return newPass.Equals(dbPassword);
        }

        public static string GenerateRandomPassword()
        {
            const string LOWER_CASE = "abcdefghijklmnopqursuvwxyz";
            const string UPPER_CAES = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            const string NUMBERS = "123456789";
            const int passwordSize = 8;

            char[] _password = new char[passwordSize];
            string charSet = ""; // Initialise to blank
            System.Random _random = new Random();
            int counter;

            charSet += LOWER_CASE;
            charSet += UPPER_CAES;
            charSet += NUMBERS;

            for (counter = 0; counter < passwordSize; counter++)
            {
                _password[counter] = charSet[_random.Next(charSet.Length - 1)];
            }

            return string.Join(null, _password);
        }
    }
}
