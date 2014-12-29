
package  
{



    import org.flixel.*;


	[SWF(width="960", height="540", backgroundColor="#000000", frameRate=60)]
	public class DeveloperHappyHour extends FlxGame
	{
       public static var WIDTH:int = 960, HEIGHT:int = 540;

		public function DeveloperHappyHour()
		{

            super(WIDTH, HEIGHT, StartGameState, 1);
            var cfg:MeasuresConfig = new MeasuresConfig();
			var temp:LevelSettings = new LevelSettings();				
			FlxG.switchState( new PlayState(temp));
            FlxG.scores[2] = 1.0;

            //this makes it easy ... incrementing FlxG.level to advance through the array.
            //order: maxPatrons, patronStep, pushBack, patronGap, probPatron
            FlxG.levels.push(new LevelSettings(1, 10, 50, 10, 0.4, 3));
            FlxG.levels.push(new LevelSettings(1, 20, 40, 10, 0.5, 4));
            FlxG.levels.push(new LevelSettings(2, 20, 45, 10, 0.5, 5));
            FlxG.levels.push(new LevelSettings(2, 20, 40, 10, 0.5, 6));
            FlxG.levels.push(new LevelSettings(2, 20, 35, 10, 0.5, 7));
		}

		
		
	}
}
