package
{	

	public class IsomatricMapper
	{
		public var screenWidth:Number;
		public var screenHeight:Number;
		public var baseWidth:Number;
		public var topWidth:Number;
		public var yOffset:Number;
		public var xOffset:Number;
		public var groundHeight:Number;
		public var gridWidth:Number;
		private static var _instance:IsomatricMapper;
		
		public static function getInstance():IsomatricMapper{
			if(!_instance){
				new IsomatricMapper();
			} 
			return _instance;
		}
		
		public function IsomatricMapper(baseW:Number=810, topW:Number=455, groundH:Number=330, 
										screenW:Number=960, screenH:Number=540, yOff:Number=210, 
										xOff:Number=75)
		{
			if(_instance){
				throw new Error("Singleton... use getInstance()");
			} 
			_instance = this;
			groundHeight = groundH;
			screenWidth = screenW;
			screenHeight = screenH;
			baseWidth = baseW;
			topWidth = topW; 
			yOffset = yOff;
			xOffset = xOff;
			gridWidth = baseW / 10;
		}
		
		public function BoundaryOffset(posY:Number):Number
		{
			var yPos:Number = posY - yOffset;
			var result:Number = 0;
			result = ((baseWidth - topWidth) / 2) / groundHeight * (groundHeight - yPos) + xOffset;
			return result;
		}
		
		public function CurrentRatio(posY:Number):Number
		{
			var yPos:Number = posY - yOffset;
			var ratio:Number = (topWidth / baseWidth) * (yPos / groundHeight + 1);
			return ratio;
		}
		
		public function VerticalMovementXDiff(posX:Number, posY:Number, yDiff:Number):Number
		{
			var yPos:Number = posY - yOffset;
			var xLength:Number = baseWidth * CurrentRatio(posY) / 2;
			var relativeXPos:Number; 
			relativeXPos = -(posX - screenWidth / 2) / xLength;
			var tanAng:Number = (baseWidth - topWidth) / 2 / groundHeight;
			var tanAngX:Number = tanAng * relativeXPos;
			var result:Number = tanAngX * yDiff;
			return result;
		}
		
		public function DeadLineXPos(posY:Number, deadLine:Number):Number
		{
			var xLength:Number = baseWidth * CurrentRatio(posY) / 2;
			return xLength * (deadLine - 0.5) + screenWidth / 2;
		}
	}
	
}