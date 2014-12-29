package
{
    /**
     * object to carry numbers that tweak the difficulty of a level.
     * number of them get created by devhappyhour, get carried around
     * by FlxG.levels, and passed to PlayState for construction.
     */
    public class LevelSettings
    {
        public var maxPatients:Number; //number of patients on a bar
        public var patientStep:Number;  //pixels/second?
        public var pushBack:Number; //pixels
        public var patientGap:Number; //seconds
        public var probPatient:Number; //percent probability
        public var ptsPatient:Number;
		public var patientSpawnSpanMin:Number;
		public var patientSpawnSpanMax:Number;
		public var patientSpawnSpanMaxDecreaseRate:Number;
		public var tankVolumeMax:Number;
        
        public function LevelSettings(maxPatients:Number=3,
                                      patientStep:Number=30,
                                      pushBack:Number=20,
									  patientSpawnSpanMin:Number=5.0,
									  patientSpawnSpanMax:Number=10.0,
									  patientSpawnSpanMaxDecreaseRate=0.016666667,
                                      probPatient:Number=0.5,
                                      ptsPatient:Number=50,
									  tankVolumeMax:Number=200		// remember to change FlxG line 1139 when changing this
                                      )
        {
            this.maxPatients = maxPatients;
            this.patientStep = patientStep;
            this.pushBack = pushBack;
            this.patientGap = patientGap;
            this.probPatient = probPatient;
            this.ptsPatient=ptsPatient;
			this.patientSpawnSpanMax = patientSpawnSpanMax;
			this.patientSpawnSpanMin = patientSpawnSpanMin;
			this.patientSpawnSpanMaxDecreaseRate = patientSpawnSpanMaxDecreaseRate;
			this.tankVolumeMax = tankVolumeMax;
        }
    }
}
