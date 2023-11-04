namespace mytown.Data
{
    public static class Enums
    {
        public static string defaultProfilePhotoURL = "/profile.png";
        public static int withdrawalPoints = 5;
        public enum UserType
        {
            USER = 1,
            ADMINISTRATOR = 2,
            INSTITUTION = 3
        }

        public enum PostEntityType
        {
            CHALLENGE = 1,
            USER_POST = 2,
            INSTITUTION_POST = 3
        }

        public enum ImageType
        {
            POST_IMAGE = 1,
            USER_ENTITY_IMAGE = 2,
            COMMENT_IMAGE = 3,
            PROFILE_DEFAULT = 7
        }

        public enum ChallengeStatus
        {
            GAVE_UP = -1,
            NOT_SOLVED_YET = 0,
            SOLVED = 1
        }

        public enum NotificationType
        {
            POST_LIKE = 1,
            COMMENT_LIKE = 2,
            NEW_COMMENT = 3,
            COMMENT_REPLY = 4,
            NEW_PROPOSAL = 5, //notify author of challenge that new proposal is added
            ADDED_PROPOSAL = 6 //to notify users who accepted challenge that new proposal is added
        }
    }
}
