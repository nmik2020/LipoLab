package
{
	import org.flixel.FlxSprite;

    public class FatSmoke extends FlxSprite
    {
        public static var cfg:Class = MeasuresConfig;
        public var targetY:Number;



        public function FatSmoke(initX:Number, initY:Number)
        {
            super(initX, initY);
            loadGraphic(Resources.beerMugSprite, false, false, cfg.mugCfg.width, cfg.mugCfg.height);
        }

        override public function update():void
        {
			super.update();
			if(alpha != 0)
				alpha -= 0.01;
			else
				kill();
        }


    }
}
