package
{
    import org.flixel.FlxRect;

    public class MeasuresConfig
    {
        public static var _bars:Array; 
        public static var _tapOffsets:Array;

        public static var patientCfg:Object, playerCfg:Object, tapCfg:Object, textCfg:Object, imgCfg:Object,mugCfg:Object, healthCfg:Object;
        
        public static var speedFactor:Number = 1.0;
		public static var speedFactorOrigin:Number = 1.0;
		public static var speedFactorMax:Number = 3.0;
		public static var speedFactorDiff:Number = 0.125;
		public static var doctorSpeedFactor:Number = 5.0; 

        public static var fontSize:Number = 15;

        /*static constructor. */
        {
            _bars = new Array();
            
            _bars[0] = new FlxRect(0, 215, 960, 37);
            _bars[1] = new FlxRect(0, 300, 960, 37);
			_bars[2] = new FlxRect(0, 430, 960, 37);

            _tapOffsets = [5, 7, 5];


            patientCfg = {
                width      : 130,
                height     : 105,
                vOffset    : 29,
                correction : 3.0,
                rantTime   : 1.0,
                deltaX     : 1.0,
                walkFps    : 6
            };
			healthCfg =	{
				width : 100,
				height: 5
			}
			mugCfg = {
				width      : 100,
				height     : 105
			};
            playerCfg = {
                width       : 128,
                height      : 128,
                step        : 2,
                throwFps    : 2,
                runFps      : 12,
                switchFps   : 25,
                hOffset     : 39,
                vOffset     : 12,
                slideOffset : 15
            };
			textCfg = {
				lifeCounter : {x: 0, y: 70, w: 200},
				scoreDisp   : {x: 0, y: 50, w: 200},
				lipoDisp    : {x: 0, y: 30, w: 200},
				scoreItem   : {x0:200, x1:250, x2:400, w0:50, w1:60, w2:200, y0:100, s:30},
				ptsLine     : {yinit: 155, w:460},
				prompter    : {y0:80, y1:110}
			};  
            tapCfg = {
                width   : 62,
                height  : 53,
                animFps : 16,
                vOffset : 10
            };
            imgCfg = {
                goImg   : {width: 61, height:48, vOffset:8},
                prepImg : {width: 50, height:68},
                openMug : {w:118, h:166, x:430, y:151},
                strip   : {x:340, offsets:[-2, -7, -7, -5, -7, 7]}
            };
        }        
    }
}
