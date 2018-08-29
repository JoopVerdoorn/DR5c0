using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

//! inherit from the view that contains the commonlogic
class PowerView extends CiqView {
    var mlastaltitude = 0;
    var mElevationDiff = 0;
    var mrealElevationGain = 0;
    var mrealElevationLoss = 0;
    var mrealElevationDiff = 0;
	
	//! it's good practice to always have an initialize, make sure to call your parent class here!
    function initialize() {
        CiqView.initialize();
    }

    //! Calculations we need to do every second even when the data field is not visible
    function compute(info) {
        //! If enabled, switch the backlight on in order to make it stay on
        if (uBacklight) {
             Attention.backlight(true);
        }

		//! We only do some calculations if the timer is running
		if (mTimerRunning) {  
			jTimertime = jTimertime + 1;
			//!Calculate lapheartrate
            mHeartrateTime		 = (info.currentHeartRate != null) ? mHeartrateTime+1 : mHeartrateTime;				
           	mElapsedHeartrate    = (info.currentHeartRate != null) ? mElapsedHeartrate + info.currentHeartRate : mElapsedHeartrate;
        }
    }

    //! Store last lap quantities and set lap markers
    function onTimerLap() {
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

 	    Garminfont_value = Ui.loadResource(Rez.Fonts.Garmin4);
 	    
	   
	}

}