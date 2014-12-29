package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * To be displayed after running out of lives.
	 */
	public class GameOverState extends FlxState
	{
		
		public var cfg:Class = MeasuresConfig;
		
		private var over:FlxText;
		private var saved:FlxSave;
		private var scores:Array;
		private var highScored:Boolean = false;
		private var newScore:Object;

		
		
		private var newInitials:Array;
		
		
		override public function create():void
		{
			FlxG.mouse.show();	
			var score:Object;
			var textItem:FlxText;
			var ypos:Number;
			var xpos:Number;

			//textItem = new FlxText(0, FlxG.height / 20, FlxG.width, "You saved " +FlxG.score + " patients");
			
				
				//positioning line for the two lower pieces of text
			var bottomLine:Number = cfg.textCfg.scoreItem.s * 9 + cfg.textCfg.scoreItem.y0 + cfg.fontSize;
			var hLowLine:Number = Math.round(bottomLine + (FlxG.height - bottomLine) / 2);
			if(FlxG.score <= 5){
				textItem = new FlxText(0, FlxG.height / 20, FlxG.width, " You are a pathetic doctor. You should go back to medical school ");
				textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
		
			}else if (FlxG.score > 5 && FlxG.score <= 10){
				textItem = new FlxText(0, FlxG.height / 20, FlxG.width, "You saved " +FlxG.score + " patients");
				textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
			}
			else{
				textItem = new FlxText(0, FlxG.height / 20, FlxG.width, "You saved " +FlxG.score + " patients. You will change the world");
				textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
			}
			textItem.text += "\nAnd you earned $" + FlxG.money + " from their fat!";
			add(textItem);
		
	/*		textItem = new FlxText(0, hLowLine - cfg.fontSize, FlxG.width, "But you could not save the rest");
			textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
			add(textItem);*/
				
			textItem = new FlxText(0, hLowLine + 1, FlxG.width, "Press space or click to save others, and earn more $$!");
			textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
			add(textItem);		
		}
		
		override public function update():void        
		{
			 if (FlxG.keys.justPressed("SPACE") || FlxG.mouse.justPressed()) //no new highscore.
			{
				//FlxG.switchState(new StartGameState());
				
				var temp:LevelSettings = new LevelSettings();				
				FlxG.switchState( new PlayState(temp));
				FlxG.scores[2] = 1.0;
				FlxG.reloadReplay(true);
				cfg.speedFactor = cfg.speedFactorOrigin;
			}
			super.update();
		}
		
		
	}
}