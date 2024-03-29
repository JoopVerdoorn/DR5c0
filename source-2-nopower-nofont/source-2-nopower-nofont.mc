using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

//! inherit from the view that contains the commonlogic
class PowerView extends CiqView {
    var mfillColour = Graphics.COLOR_LT_GRAY;
    hidden var Watchtype = 1111;
//!    hidden var watchType = mySettings.partNumber;
		
	//! it's good practice to always have an initialize, make sure to call your parent class here!
    function initialize() {
        CiqView.initialize();
    }


    //! Store last lap quantities and set lap markers
    function onTimerLap() {
		LapactionNoPower ();
	}

	//! Store last lap quantities and set lap markers after a step within a structured workout
	function onWorkoutStepComplete() {
		LapactionNoPower ();
	}
	
    //! Current activity is ended
    function onTimerReset() {
        mPrevElapsedDistance        = 0;
        mLaps                       = 1;
        mLastLapDistMarker          = 0;
        mLastLapTimeMarker          = 0;
        mLastLapTimerTime           = 0;
        mLastLapElapsedDistance     = 0;
        mStartStopPushed            = 0;
        mLastLapHeartrateMarker     = 0;
        mLastLapElapsedHeartrate    = 0;        
        mLastLapTimerTimeHR     	= 0;     
    }

	function onUpdate(dc) {
		//! call the parent function in order to execute the logic of the parent
		CiqView.onUpdate(dc);
		var info = Activity.getActivityInfo();

        var i = 0; 
	    for (i = 1; i < 6; ++i) {
	        if (metric[i] == 55) {   
            	if (info.currentSpeed == null or info.currentSpeed==0) {
            		fieldValue[i] = 0;
            	} else {
            		fieldValue[i] = (info.currentSpeed > 0.001) ? 100/info.currentSpeed : 0;
            	}
            	fieldLabel[i] = "s/100m";
        	    fieldFormat[i] = "2decimal";        	    
	        } 
		}

		//! Determine required finish time and calculate required pace 	
        var mRacehour = uRacetime.substring(0, 2);
        var mRacemin = uRacetime.substring(3, 5);
        var mRacesec = uRacetime.substring(6, 8);
        mRacehour = mRacehour.toNumber();
        mRacemin = mRacemin.toNumber();
        mRacesec = mRacesec.toNumber();
        mRacetime = mRacehour*3600 + mRacemin*60 + mRacesec;
		
        //! Calculate ETA
        if (info.elapsedDistance != null && info.timerTime != null) {
            if (uETAfromLap == true ) {
            	if (mLastLapTimerTime > 0 && mLastLapElapsedDistance > 0 && mLaps > 1) {
            		if (uRacedistance > info.elapsedDistance) {
            			mETA = info.timerTime/1000 + (uRacedistance - info.elapsedDistance)/ mLastLapSpeed;
            		} else {
            			mETA = 0;
            		}
            	}
            } else {
            	if (info.elapsedDistance > 5) {
            		mETA = uRacedistance / (1000*info.elapsedDistance/info.timerTime);
            	}
            }
        }


		//! Display colored labels on screen for FR645
		if (Watchtype == 2886 or Watchtype == 3003) {
			for (i = 1; i < 6; ++i) {
			   	if ( i == 1 ) {			//!upper row, left    	
	    			Coloring2(dc,i,fieldValue[i],"018,029,100,019");
		   		} else if ( i == 2 ) {	//!upper row, right
			   		Coloring2(dc,i,fieldValue[i],"120,029,100,019");
		       	} else if ( i == 3 ) {  //!lower row, left
	    			Coloring2(dc,i,fieldValue[i],"000,093,119,019");
	      		} else if ( i == 4 ) {  //!middle row, right
		    		Coloring2(dc,i,fieldValue[i],"120,093,120,019");
			   	} else if ( i == 5 ) {	//!lower row, middle
			 		Coloring2(dc,i,fieldValue[i],"010,175,100,043");		 		
	    		}
	    	}       	
		} 
	   
	}
	
	
	function Coloring2(dc,counter,testvalue,CorString) {
		var info = Activity.getActivityInfo();
        var x = CorString.substring(0, 3);
        var y = CorString.substring(4, 7);
        var w = CorString.substring(8, 11);
        var h = CorString.substring(12, 15);
        x = x.toNumber();
        y = y.toNumber();
        w = w.toNumber();
        h = h.toNumber(); 
		if (metric[counter] == 13 or metric[counter] == 14 or metric[counter] == 15) {
			if (mETA < mRacetime) {
    	    	mfillColour = Graphics.COLOR_GREEN;
        	} else {
        		mfillColour = Graphics.COLOR_RED;
        	}
			dc.setColor(mfillColour, Graphics.COLOR_TRANSPARENT);
        	dc.fillRectangle(x, y, w, h);
        }
	}

	function LapactionNoPower () {
        var info = Activity.getActivityInfo();
        mLastLapTimerTime       	= jTimertime - mLastLapTimeMarker;
        mLastLapElapsedDistance 	= (info.elapsedDistance != null) ? info.elapsedDistance - mLastLapDistMarker : 0;
        mLastLapDistMarker      	= (info.elapsedDistance != null) ? info.elapsedDistance : 0;
        mLastLapTimeMarker      	= jTimertime;

        mLastLapTimerTimeHR			= mHeartrateTime - mLastLapTimeHRMarker;
        mLastLapElapsedHeartrate 	= (info.currentHeartRate != null) ? mElapsedHeartrate - mLastLapHeartrateMarker : 0;
        mLastLapHeartrateMarker     = mElapsedHeartrate;
        mLastLapTimeHRMarker        = mHeartrateTime;
        mLaps++;
    }

}