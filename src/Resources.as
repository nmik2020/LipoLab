package
{
    import org.flixel.*;

    /**
     * Contains all of the embedded images, both full sized and scaled down versions.
     * has accessor functions for these images that return the image appropriate for the
     * type of build (mobile or desktop)
     */
    public class Resources
    {     

        [Embed(source="../build/assets/smoke.png")]
        private static var BeerMugSprite:Class;

		[Embed(source="../build/assets/backgroundScore.mp3")]	
		private static var BackgroundScore:Class;
		
      

        [Embed(source="../build/assets/fatty_near.png")]
		//[Embed(source="../build/assets/sprites-icon-patron1.png")]
        private static var PatientSprite:Class;



       // [Embed(source="../build/assets/character_test.png")]
		[Embed(source="../build/assets/sprites-player-new1.png")]
        private static var BartenderSprite:Class;
		
		[Embed(source="../build/assets/HealthMeter.png")]
		private static var HealthMeter:Class;
        


       
        //  Full screen image sprites
        [Embed(source="../build/assets/sprites-startscreen.png")]
        private static var TitleScreen:Class;

       // [Embed(source="../build/assets/sprites-barbg.png")]
		[Embed(source="../build/assets/liposuctionworld_1920.png")]
		private static var BarScreen:Class;


        public static function get barScreen():Class
        {

                return BarScreen;
        }

        public static function get titleScreen():Class
        {

                return TitleScreen;
        }

       
        public static function get bartenderSprite():Class
        {

                return BartenderSprite;
        }

       
		
		public static function get healthMeter():Class
		{
			return HealthMeter;
		}


        public static function get patientSprite():Class
        {

                return PatientSprite;
        }

        public static function get beerMugSprite():Class
        {

                return BeerMugSprite;
        }

		public static function get backgroundScore():Class
		{
			
			return BackgroundScore;
		}
    }
}
