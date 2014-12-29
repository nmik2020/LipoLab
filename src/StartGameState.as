package
{
        import org.flixel.FlxG;
        import org.flixel.FlxSound;
        import org.flixel.FlxSprite;
        import org.flixel.FlxState;
        import org.flixel.FlxText;

    /**
     * To be displayed upon starting the game, or after ending a game.
     */
    public class StartGameState extends FlxState
    {
        private var title:FlxText;
        private var prompter:FlxText;
        public var cfg:Class = MeasuresConfig;

        override public function create():void
        {
			FlxG.playMusic(Resources.backgroundScore,1);
            add(new FlxSprite(0,0, Resources.titleScreen));
            FlxG.mouse.show();

            //reset level, lives, and scores
            FlxG.level = 0;
            FlxG.score = 0;
			FlxG.money = 0;
			//No: of gurney hits is set to index 1
            FlxG.scores[1] = 3;

        }

        override public function update():void
        {
            //start the game
            if (FlxG.mouse.justReleased() || FlxG.keys.justPressed("SPACE")) 
            {
				var temp:LevelSettings = new LevelSettings();				
				FlxG.switchState( new PlayState(temp));
            }
            super.update();
        }
    }
}
