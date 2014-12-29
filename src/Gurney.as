package
{
    import org.flixel.FlxG;
    import org.flixel.FlxPoint;

    /**
     * a patient/gurney is a kind of bar thing that makes the player lose
     * only if it reaches the right edge of the bar.
     * it can also be pushed back by mugs.
     */
    public class Gurney extends BarThing
    {
        public static var lengthSheetPart:Number = 4;

        public static var cfg:Class = MeasuresConfig;
		private var isoMapper:IsomatricMapper = IsomatricMapper.getInstance();

        //statics reping times/speeds
        private var speedfactor:Number;

        
        public var targetX:Number;

        public var deltaX:Number=1;
        private var animTime:Number;
        private var psi:Number; //Patron Start Index

		private var calledDieRight:Boolean = false;
        public var collideRight:Boolean;
        public var bottom:Number;
        public var right:Number;
		public var spawnPt:FlxPoint;
		//fatContent is the number of space button taps required to heal the patient
		public var fatContent:Number;
		public var ratio:Number;
		
		public var healthMeter:BarThing;

        public function Gurney(initY:Number, leftBound:Number, rightBound:Number)
        {
			spawnPt = new FlxPoint(isoMapper.BoundaryOffset(initY) - 100 * isoMapper.CurrentRatio(initY), initY);
			healthMeter = new BarThing(spawnPt.x + 25 * isoMapper.CurrentRatio(y), spawnPt.y, leftBound, rightBound);
            super(spawnPt.x, spawnPt.y, leftBound, rightBound);
            speedfactor = FlxG.scores[2];
            deltaX = cfg.patientCfg.deltaX;
			ratio = isoMapper.CurrentRatio(y);
			scale.x *= ratio;
			scale.y *= ratio;
			width *= ratio;
			height *= ratio;
			fatContent = randomRange(1,40);
            //this is going to have to hold every single patient sprite, the way I see it.
            loadGraphic(Resources.patientSprite, false, false, cfg.patientCfg.width, cfg.patientCfg.height);
			healthMeter.loadGraphic(Resources.healthMeter, false, false, cfg.healthCfg.width, cfg.healthCfg.height);
			healthMeter.origin.x = 0;
			healthMeter.scale.x = fatContent / 40 * isoMapper.CurrentRatio(healthMeter.y);
            var numPatrons:Number = 1;
            var whichPatron:Number = Math.floor(Math.random() * (numPatrons + 1));
            psi = 0;
			addAnimation("walk", [0], cfg.patientCfg.walkFps, false);

            addAnimationCallback(onAnimationChange);
 
        }
		
		override public function prepare():void
		{
			super.prepare();
			startPos = spawnPt;
		}
        
		private function randomRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
        override public function update():void
        {
   			var deadLine:Number = isoMapper.DeadLineXPos(y, 0.6);
            //move to the targetX. if we're there, start animating.
            if(x < deadLine)
			{
				x += deltaX * ratio * cfg.speedFactor;
				healthMeter.x = x + 25 * isoMapper.CurrentRatio(y);;
			}
			else
			{
				//if(!calledDieRight){
				//	dieRight();
				//	calledDieRight = true;
				//}
				if(alive)
				{
					dieRight();
					healthMeter.dieRight();
				}
			}
            super.update();
			healthMeter.scale.x = fatContent / 40 * isoMapper.CurrentRatio(healthMeter.y);
        }

        /**
         * because a patient going off the left doesn't end the game...
         */
        override public function dieLeft():void
        {
            super.dieLeft();
            //we need these so that this doesn't screw up if reused.
            animTime = 0;
        }
		
		override public function dieRight():void
		{
			super.dieRight();
			animTime = 0;
		}

        /**
         * corrects position and sets flags as the animation cycle proceeds.
         */
        public function onAnimationChange(name:String, fNum:uint, fIdx:uint):void
        {
            y = startPos.y;
            if (name == "catch")
                y+=cfg.patientCfg.correction;

        }
    }
}
