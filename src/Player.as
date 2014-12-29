package
{
    import org.flixel.FlxGroup;
    import org.flixel.FlxPoint;
    import org.flixel.FlxSprite;

    public class Player extends FlxSprite
    {
        public static var cfg:Class = MeasuresConfig;

        public var isDancing:Boolean=false; 
        public var isDrinking:Boolean=false; 
        public var right:Number;
		public var isSwitching:Boolean = false;
		public var targetY:Number;
		private var isMovingUp:Boolean;
		private var speedFactor:Number;
		public var currentLaneNum:int;	//0, 1, 2
		public var laneIntervals:Number;
		private var isoMapper:IsomatricMapper = IsomatricMapper.getInstance();
		public var hasThingBelow:Boolean = false;
		public var hasThingAbove:Boolean = false;
		public var playerFacing:int = 1;	// 0 North, 1 South, 2 West, 3 East
		public var actualY:Number;
		public var originalWidth:Number;
		public var originalHeight:Number;
		
		public var PlayerLane1:FlxGroup;
		public var PlayerLane2:FlxGroup;
		public var PlayerLane3:FlxGroup;
		
		//rects
		private var bars:Array;
		public var cfg:Class = MeasuresConfig;

        public function Player(pos:FlxPoint)
        {	
			PlayerLane1 = new FlxGroup();
			PlayerLane2 = new FlxGroup();
			PlayerLane3 = new FlxGroup();
			PlayerLane1.add(this);
			super(pos.x, pos.y - cfg.patientCfg.height * isoMapper.CurrentRatio(pos.y));
			originalWidth = cfg.playerCfg.width;
			originalHeight = cfg.playerCfg.height;
			width = originalWidth * isoMapper.CurrentRatio(pos.y);
			height = originalHeight * isoMapper.CurrentRatio(pos.y);
			speedFactor = cfg.doctorSpeedFactor;

            loadGraphic(Resources.bartenderSprite, true, true, cfg.playerCfg.width, cfg.playerCfg.height);
            addAnimation("standingFront", [2], cfg.playerCfg.switchFps , false);
			addAnimation("standingBack", [6], cfg.playerCfg.switchFps , false);
			addAnimation("LeftStation", [9], cfg.playerCfg.switchFps, false);
			addAnimation("RightStation", [14], cfg.playerCfg.switchFps, false);

			addAnimation("movingForward", [0,1,2,3,4,3,2,1], cfg.playerCfg.switchFps , true);
			addAnimation("movingBackward", [5,6,7,6], cfg.playerCfg.switchFps , true);
			addAnimation("movingLeft", [8,9,10,11,10,9], cfg.playerCfg.runFps, true);
			addAnimation("movingRight", [12,13,14,15,14,13], cfg.playerCfg.runFps, true);

			targetY = y;
			trace("TargetY: " + targetY);
			currentLaneNum = 0;
            bars = cfg._bars;
        }

        override public function update():void
        {
            super.update();
			if(isSwitching)
			{
				if(isMovingUp)
				{
					if(y > targetY)
					{
						SwitchingLane(0);
					}
					else
					{
						y = targetY;
						isSwitching = false;
						play("standingBack");
						currentLaneNum--;
					}
				}
				else
				{
					if(y < targetY)
					{
						SwitchingLane(1);
					}
					else
					{
						y = targetY;
						isSwitching = false;
						play("standingFront");
						currentLaneNum++;
					}
				}
			}
			
			// Check boundary
			/*if(y < isoMapper.yOffset - height / 2)
			{
				y = isoMapper.yOffset - height / 2;
			}
			else if(y > isoMapper.screenHeight - height)
			{
				y = isoMapper.screenHeight - height;
			}
			*/
			if(x < isoMapper.BoundaryOffset(actualY + isoMapper.yOffset) + 20)
			{
				x = isoMapper.BoundaryOffset(actualY + isoMapper.yOffset) + 20;
			}
			else if(x > isoMapper.DeadLineXPos(actualY, 0.9) + isoMapper.xOffset)
			{
				x = isoMapper.DeadLineXPos(actualY, 0.9) + isoMapper.xOffset;
			}
			actualY = y;
			var ratio:Number = isoMapper.CurrentRatio(actualY);
			scale.x = ratio;
			scale.y = ratio;
			width = originalWidth * ratio;
			height = originalHeight * ratio;
        }
		
		public function Move(dir:int):void
		{
			if(isSwitching)
			{
				return;
			}
			if(playerFacing != dir)
			{
				playerFacing = dir;
				if(dir == 0 || dir == 1)
					play((dir==0?"standingBack":"standingFront"));
				return;
			}
			var currRatio:Number = IsomatricMapper.getInstance().CurrentRatio(y);
			switch(dir)
			{
				case 0:
					if(currentLaneNum <= 0 || hasThingAbove)
					{
						return;
					}
					if(currentLaneNum == 1)
					{
						PlayerLane2.remove(this);
						PlayerLane1.add(this);
					}
					else
					{
						PlayerLane3.remove(this);
						PlayerLane2.add(this);
					}
					//currentLaneNum--;
					isSwitching = true;
					targetY = bars[currentLaneNum-1].top - cfg.tapCfg.vOffset - cfg.patientCfg.height * isoMapper.CurrentRatio(bars[currentLaneNum-1].top - cfg.tapCfg.vOffset);
					trace(targetY);
					trace(y);
					isMovingUp = true;
					play("movingBackward");
					break;
				case 1:
					if(currentLaneNum >= 2 || hasThingBelow)
					{
						return;
					}
					if(currentLaneNum == 1)
					{
						PlayerLane2.remove(this);
						PlayerLane3.add(this);
					}
					else
					{
						PlayerLane1.remove(this);
						PlayerLane2.add(this);
					}
					//currentLaneNum++;
					isSwitching = true;
					targetY = bars[currentLaneNum+1].top - cfg.tapCfg.vOffset - cfg.patientCfg.height * isoMapper.CurrentRatio(bars[currentLaneNum+1].top - cfg.tapCfg.vOffset);
					trace(targetY);
					trace(y);
					isMovingUp = false;
					play("movingForward");
					break;
				case 2:
					x -= speedFactor * currRatio;
					break;
				case 3:
					x += speedFactor * currRatio;
					break;
				default:
					break;
			}
		}
		
		public function SwitchingLane(dir:int):void
		{
			var currRatio:Number = IsomatricMapper.getInstance().CurrentRatio(actualY);
			switch(dir)
			{
				case 0:
					y -= speedFactor * currRatio;
					x += IsomatricMapper.getInstance().VerticalMovementXDiff(x + width / 2, actualY, speedFactor * currRatio);
					break;
				case 1:
					y += speedFactor * currRatio;
					x -= IsomatricMapper.getInstance().VerticalMovementXDiff(x + width / 2, actualY, speedFactor * currRatio);
					break;
				default:
					break;
			}
		}
    }
}
