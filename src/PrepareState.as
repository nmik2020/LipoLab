package
{    
    import flash.system.System;
    
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxText;
    
    /**
     * momentary screen with a little animation telling user to get ready.
     * displayed before going into playstate.
     */
    public class PrepareState extends FlxState
    { 
        public var cfg:Class = MeasuresConfig;

        private var tapping:FlxSprite;

        override public function create():void
        {
			add(new FlxText(0,0,100,"Inside Create")); 

            //blue background
            var bg:FlxSprite = new FlxSprite();
            bg.loadGraphic(Resources.titleScreen,false,false,FlxG.width, FlxG.height);
            bg.color=0x002449;
            add(bg);
            //prompts
            var prompter:FlxText = new FlxText(0, FlxG.height/4, FlxG.width, "GET READY TO SERVE");
            prompter.setFormat(null, cfg.fontSize, 0xdbff00, "center", 0);
            add(prompter);

            //animated sprite in center of screen
            tapping = new FlxSprite((FlxG.width - cfg.imgCfg.prepImg.width) / 2,
                    (FlxG.height - cfg.imgCfg.prepImg.height)/2);

            tapping.loadGraphic(Resources.prepareImg, 
                    true, false, cfg.imgCfg.prepImg.width, cfg.imgCfg.prepImg.height);

            //1 second to run animation
            tapping.addAnimation("yoink", [0, 1], 2, false);
            add(tapping);
            tapping.play("yoink");
        }

        //as soon as animation is done, start the level.
        override public function update():void
        {
            if (tapping.finished)
            {
                //uses those levelsettings objects to figure out what
                //level to start up.
				var temp:LevelSettings = new LevelSettings();
				// temp = FlxG.levels[FlxG.level];
				 
			FlxG.switchState( new PlayState(temp));
            }
            super.update();
        }

    }
}
