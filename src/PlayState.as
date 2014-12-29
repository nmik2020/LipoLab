package
{

	
	import org.flixel.FlxG;
	import org.flixel.FlxMonitor;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class PlayState extends FlxState
	{
		public var cfg:Class = MeasuresConfig;
		
		//speeds
		private var speedfactor:Number;
		private var playerStep:Number = 2;
		
		//points for events
		private var collectMugPoints:Number = 100;
		private var collectMoneyPoints:Number = 1500;
		private var tankVolumeMax:Number;
		
		private var pushOutPatientPoints:Number;
		//level settings
		private var maxPatients:Number;
		private var patientStep:Number; 
		private var patientGap:Number; //seconds
		private var probPatient:Number; //percent probability
		private var curPatient:Gurney; // current Patient or Gurney
		private var reachedLipometer:Boolean = false;
		private var createdGurneys:Boolean = false
		//position
	
		//time till next wave
		private var countDown:Number;
		
		//ARRAYS
		private var bars:Array;
		//groups
		//sprites
		private var taps:Array;
		//objects
		private var tchs:Array; //touch points for switching.
		//points
		private var tapperPositions:Array;
		private var patientPositions:Array;
		
		//counters
		//private var patientsOut:Number = 0;
		private var patientCount:Number = 0;
		
		//state flags
		private var isSwitching:Boolean=false;
		private var isPumping:Boolean=false;
		private var gameIsOver:Boolean=false;

		
		//displays
		private var gurneyHits:FlxText;
		private var scoreDisp:FlxText;
		private var lipoSuctionDisp:FlxText;
		private var debugDisp:FlxText;
		private var mon:FlxMonitor;		
		private var player:Player;
		private var gurneySpawners:Array;
		private var levelSettings:LevelSettings;
		private var patientsLost:FlxText;
		private var patientsSaved:FlxText;
		private var lipoValue:FlxText;
		
		//Input
		private var pressedTapper:Boolean;
		private var releasedTapper:Boolean;
		private var resetGame:Boolean ;	
		private var choseTapUp:Boolean;
		private var choseTapDown:Boolean ;
		private var goLeft:Boolean ;
		private var goRight:Boolean ;
		
		/**
		 * get all the settings for the level to be played.
		 */
		public function PlayState(ls:LevelSettings)
		{
			super();
			maxPatients = ls.maxPatients;
			patientStep = ls.patientStep;
			patientGap = ls.patientGap;
			probPatient = ls.probPatient;
			pushOutPatientPoints = ls.ptsPatient;		
			speedfactor = cfg.speedFactor;
			playerStep = cfg.playerCfg.step;
			levelSettings = ls;
			tankVolumeMax = ls.tankVolumeMax;
		}
		
		//life counter.
		public function get lives():Number
		{
			return FlxG.scores[1];
		}
		
		public function set lives(value:Number):void
		{
			FlxG.scores[1]=value;
		}
		
		//lipo meter bounds
		public function get lipoMeterBound():Number
		{
			return FlxG.lipoMeter;
		}
		
		public function set lipoMeterBound(value:Number):void
		{
			FlxG.lipoMeter=value;
		}
		/**
		 * sets up the place.
		 */
		override public function create():void
		{
			FlxG.score = 0;
			
			//create bar background
			add(new FlxSprite(0, 0, Resources.barScreen));
			var pos:FlxPoint;

			FlxG.mouse.hide();
			//set Gurney hits
			patientsLost = new FlxText(0, cfg.textCfg.lifeCounter.y, cfg.textCfg.lifeCounter.w, "Patients Lost :");
			patientsLost.setFormat(null, cfg.fontSize, 0xff0000, "right");
			add(patientsLost);
			
			//display scores
			patientsSaved = new FlxText(0, cfg.textCfg.scoreDisp.y, cfg.textCfg.scoreDisp.w, "Money Earned : ");
			patientsSaved.setFormat(null, cfg.fontSize, 0x2593ff, "right");
			add(patientsSaved);
			
			lipoValue = new FlxText(0, cfg.textCfg.lipoDisp.y, cfg.textCfg.lipoDisp.w, "LipoMeter :");
			lipoValue.setFormat(null, cfg.fontSize, 0xffff66, "right");
			add(lipoValue);
			
			//set Gurney hits
			gurneyHits = new FlxText(100, cfg.textCfg.lifeCounter.y , cfg.textCfg.lifeCounter.w, (3 - lives).toString() + " / 3");
			gurneyHits.setFormat(null, cfg.fontSize, 0xff0000, "right");
			add(gurneyHits);
			
			//display scores
			scoreDisp = new FlxText(100, cfg.textCfg.scoreDisp.y, cfg.textCfg.scoreDisp.w, "$" + FlxG.money.toString());
			scoreDisp.setFormat(null, cfg.fontSize, 0x2593ff, "right");
			add(scoreDisp);
			
			lipoSuctionDisp = new FlxText(cfg.textCfg.lipoDisp.x + 100, cfg.textCfg.lipoDisp.y, cfg.textCfg.lipoDisp.w, (levelSettings.tankVolumeMax - FlxG.lipoMeter).toString() + " / " + levelSettings.tankVolumeMax.toString());
			lipoSuctionDisp.setFormat(null, cfg.fontSize, 0xffff66, "right");
			add(lipoSuctionDisp);
			
			//set the countdown for patients.
			countDown = patientGap; 
			
			//arrays that contain information about the bars and their locations and object groups.
			bars = cfg._bars;
			taps = new Array();
			tchs = new Array();
			gurneySpawners = new Array();
			
			tapperPositions = new Array();
			patientPositions = new Array();
			
			var tapOffsets:Array = cfg._tapOffsets;
			
			// generate the bar groups and position arrays.
			var gurney:Gurney;
			for (var i:int = 0; i < bars.length; i++)
			{
				//position the bar-switch and tap-pull touch areas
				tchs[i] = new FlxObject(bars[i].right+tapOffsets[i], bars[i].top - cfg.tapCfg.vOffset,
					FlxG.width - (bars[i].right+tapOffsets[i]), bars[i].height+cfg.tapCfg.vOffset);
				//add(tchs[i]);

				//where the player starts when getting to a bar
				tapperPositions[i] = new FlxPoint(bars[i].right + tapOffsets[i] - cfg.playerCfg.hOffset, bars[i].top - cfg.playerCfg.vOffset);
				//inital positions for patients
				patientPositions[i] = new FlxPoint(bars[i].left, bars[i].top - cfg.patientCfg.vOffset);
				gurneySpawners[i] = new GurneySpawner(levelSettings, i, bars[i].top - cfg.patientCfg.vOffset, this);
			}
		
			player = new Player(tapperPositions[0]);
			add(player.PlayerLane1);
			add(gurneySpawners[0].barPatients);
			add(gurneySpawners[0].barPatientsHealth);
			add(player.PlayerLane2);
			add(gurneySpawners[1].barPatients);
			add(gurneySpawners[1].barPatientsHealth);
			add(player.PlayerLane3);
			add(gurneySpawners[2].barPatients);
			add(gurneySpawners[2].barPatientsHealth);
		}
		

		private function fadeOutSmoke(smoke:FatSmoke):void {
			while(smoke.alpha != 0)
			 smoke.alpha -= 0.01;
			smoke.kill();

		}
		
		private function checkOverlapBetweenDoctorAndPatient():void{
			/*
			Lipometer section
			*/
			if(player.currentLaneNum == 2 && player.x >= 660)
			{
				reachedLipometer = true;
			}
			else 
			{
				reachedLipometer = false;
			}

		}
		
		private function addInput():void {
			pressedTapper = !isPumping && 
				(FlxG.keys.SPACE);
			
			releasedTapper = isPumping && (FlxG.keys.justReleased("SPACE"));
			resetGame =  gameIsOver && (FlxG.keys.justPressed("R"));
			
			choseTapUp = !isSwitching && (FlxG.keys.justPressed("UP"));
			
			choseTapDown = !isSwitching && (FlxG.keys.justPressed("DOWN"));
			
			goLeft = (FlxG.keys.LEFT);
			goRight = (FlxG.keys.RIGHT);
		}
		
		//make sure text displays are up to date
		private function displayScores():void {
			gurneyHits.text = (3 - lives).toString() + " / 3";
			scoreDisp.text = "$" + FlxG.money.toString();
			if(levelSettings.tankVolumeMax - FlxG.lipoMeter >= 200)
			{
				lipoSuctionDisp.text = "Meter Full";
			}
			else
			{
				lipoSuctionDisp.text = (levelSettings.tankVolumeMax - FlxG.lipoMeter).toString() + " / " + levelSettings.tankVolumeMax.toString();
			}
		}
		
		// Remove all fat -- Function of Lipometer Station
		private function removeFatOnTap():void {
			if(pressedTapper && reachedLipometer && lipoMeterBound <tankVolumeMax)
			{
				if(lipoMeterBound < tankVolumeMax)
				{
					lipoMeterBound++;
					FlxG.money++;
				}
			}
		}
		
		private function restartGame():void {
			if(resetGame)
			{
				var temp:LevelSettings = new LevelSettings();				
				FlxG.switchState( new PlayState(temp));
				lives = 3;
				lipoMeterBound = 200;
			}
		}
		

		override public function update():void
		{

			checkOverlapBetweenDoctorAndPatient();
			displayScores();
			addInput();
			removeFatOnTap();
			restartGame();
			//trace("Player x : " +player.x + "y : "+ player.y);
			if(pressedTapper)
			{
				trace("X: " + player.x);
				trace("Y: " + player.y);
			}
			if(choseTapUp || choseTapDown || goLeft || goRight)
			{
				if(choseTapDown && (player.currentLaneNum < 2 || player.playerFacing != 1))
				{
					player.Move(1);
				}
				if(choseTapUp && (player.currentLaneNum > 0 || player.playerFacing != 0))
				{
					player.Move(0);
				}
				if(goLeft)
				{
					player.Move(2);
				}
				if(goRight)
				{
					player.Move(3)
				}
				
				/*if(choseTapUp || choseTapDown)
				{
					player.Move(choseTapUp? 0:1);
				}*/
				
				switch(player.playerFacing)
				{
					case 2:
						player.play("movingRight");
						break;
					case 3:
						player.play("movingLeft");
						break;
					default:
						break;
				}
			}
			else if ((FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") ))
			{
				player.facing = FlxSprite.RIGHT;
				player.frame = 0;
				player.finished=true;
				switch(player.playerFacing)
				{
					case 2:
						player.play("RightStation");
						break;
					case 3:
						player.play("LeftStation");
						break;
					default:
						break;
				}
			}
			
			/*--IMPORTANT.--*/
			super.update();
			var contacted:Boolean = false;
			player.hasThingAbove = false;
			player.hasThingBelow = false;
			
			for(var i:int = 0; i < bars.length; i++)
			{
				gurneySpawners[i].Update(FlxG.elapsed);
				// Loop through all living gurneys and check collisions
				for(var j:int = 0; j < gurneySpawners[i].barPatients.length; j++)
				{
					var currentGurney:Gurney = gurneySpawners[i].barPatients.members[j];
					if(currentGurney && currentGurney.alive && currentGurney.overlaps(player))
					{
						switch(player.playerFacing)
						{
							case 0:
								if(currentGurney.y <= player.actualY)
								{
									contacted = true;
									player.hasThingAbove = true;
									if(pressedTapper && lipoMeterBound!=0)
									{  
										lipoMeterBound--
										if(currentGurney.fatContent > 0) 
										{
											currentGurney.fatContent--;
											//trace(currentGurney.fatContent);
										}
										else if(currentGurney.fatContent == 0)
										{
											FlxG.score++;
											var smoke:FatSmoke = new FatSmoke( currentGurney.x , currentGurney.y- 20);
											add(smoke);
											currentGurney.kill();
											if(FlxG.score % 10 == 0)
											{
												if(cfg.speedFactorMax > cfg.speedFactor)
												{
													cfg.speedFactor += cfg.speedFactorDiff;
												}
											}
										}
									}
								}
								break;
							case 1:
								if(currentGurney.y >= player.actualY)
								{
									contacted = true;
									player.hasThingBelow = true;
									if(pressedTapper && lipoMeterBound!=0)
									{  
										lipoMeterBound--
										if(currentGurney.fatContent > 0) 
										{
											currentGurney.fatContent--;
											//trace(currentGurney.fatContent);
										}
										else if(currentGurney.fatContent == 0)
										{
											FlxG.score++;
											var smoke1:FatSmoke = new FatSmoke( currentGurney.x , currentGurney.y - 20);
											add(smoke1);
											currentGurney.kill();
											if(FlxG.score % 10 == 0)
											{
												if(cfg.speedFactorMax > cfg.speedFactor)
												{
													cfg.speedFactor += cfg.speedFactorDiff;
												}
											}
										}
									}
								}
								break
							default:
								break;
						}
					}
				}
			}
			
		}
		
		
		/**
		 * throws up the game over display
		 */
		public function displayGameOver():void
		{
			FlxG.switchState( new GameOverState());

		}
		
		public function gurneyCrossedRight(gurney:Gurney):Boolean
		{
			//trace("Gurney : "+gurney.whichBar);
				lives--;
				if(lives <= 0)
				{
					lives = 3
						lipoMeterBound = 200;
					displayGameOver();
				}	
				//trace("Gurney crossed right");
				return true;	
		}
	
	}
}