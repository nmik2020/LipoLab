package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;

	public class GurneySpawner
	{
		public var cfg:Class = MeasuresConfig;
		private var pushOutPatientPoints:Number;
		//level settings
		private var maxPatients:Number;
		private var patientStep:Number; 
		private var currentTime:Number = 0;
		private var patientSpawnSpanMax:Number;
		private var patientSpawnSpanMin:Number;
		private var patientSpawnSpanMaxDecreaseRate:Number;
		private var currentPatientSpawnSpan:Number;
		
		private var probPatient:Number; //percent probability
		private var barNumber:int = 0;
		private var barPositionY:Number;
		public  var barPatients:FlxGroup;
		public  var barPatientsHealth:FlxGroup;
		private var state:PlayState;
		private var yPos:Number;
		private var leftBound:Number;
		private var rightBound:Number;
		
		
		public function GurneySpawner(ls:LevelSettings, barNum:int, posY:Number, state:PlayState)
		{
			maxPatients = ls.maxPatients;
			patientStep = ls.patientStep;
			patientSpawnSpanMin = ls.patientSpawnSpanMin;
			patientSpawnSpanMax = ls.patientSpawnSpanMax;
			patientSpawnSpanMaxDecreaseRate = ls.patientSpawnSpanMaxDecreaseRate;
			currentPatientSpawnSpan = Math.random() * (patientSpawnSpanMax - patientSpawnSpanMin) + patientSpawnSpanMin;
			probPatient = ls.probPatient;
			pushOutPatientPoints = ls.ptsPatient;
			barNumber = barNum;
			this.state = state;
			yPos = posY;
			leftBound = cfg._bars[barNumber].left;
			rightBound = cfg._bars[barNumber].right;
			barPatients = new FlxGroup();
			barPatientsHealth = new FlxGroup();
			SpawnGurney();
		}
		
		public function Update(deltaTime:Number):void
		{
			currentTime += deltaTime;
			if(patientSpawnSpanMax > patientSpawnSpanMin)
			{
				patientSpawnSpanMax -= patientSpawnSpanMaxDecreaseRate * deltaTime;
			}
			else
			{
				patientSpawnSpanMax = patientSpawnSpanMin;
			}
			if(currentTime >= currentPatientSpawnSpan)
			{
				// remove dead patients
				barPatients.remove(barPatients.getFirstDead());
				barPatientsHealth.remove(barPatientsHealth.getFirstDead());
				currentTime = 0;
				SpawnGurney();
			}
		}
		
		private function SpawnGurney():void
		{
			currentPatientSpawnSpan = Math.random() * (patientSpawnSpanMax - patientSpawnSpanMin) + patientSpawnSpanMin;
			var gurney:Gurney = new Gurney(yPos, leftBound, rightBound);
			gurney.whichBar = barNumber;
			gurney.onDieRight = state.gurneyCrossedRight;
			barPatients.add(gurney);
			barPatientsHealth.add(gurney.healthMeter);
			gurney.allowCollisions = FlxObject.ANY;
			gurney.prepare();
			gurney.healthMeter.prepare();
			gurney.play("walk");
		}
	}
}