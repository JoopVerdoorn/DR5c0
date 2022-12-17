using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//! inherit from the view that contains the commonlogic
class DeviceView extends PowerView {
	var myTime;
	var strTime;
	
	//! it's good practice to always have an initialize, make sure to call your parent class here!
    function initialize() {
        PowerView.initialize();
    }

	function onUpdate(dc) {
		//! call the parent function in order to execute the logic of the parent
		PowerView.onUpdate(dc);

		//! Draw separator lines
        dc.setColor(mColourLine, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);

        //! Horizontal thirds
        dc.drawLine(20,   25,  195, 25);
        dc.drawLine(0,   78,  215, 78);
        dc.drawLine(0,   141, 215, 141);

        //! Top vertical divider
        dc.drawLine(107, 26,  107, 79);

        //! Centre vertical divider
 		dc.drawLine(107, 63, 107, 141);

		//! Display metrics
        dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);

		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);

		//! Show military clock with current time in top
		myTime = Toybox.System.getClockTime(); 
    	strTime = myTime.hour.format("%02d") + ":" + myTime.min.format("%02d"); 		
		dc.drawText(98, -4, Graphics.FONT_NUMBER_MILD, strTime, Graphics.TEXT_JUSTIFY_CENTER);

		for (var i = 1; i < 6; ++i) {
	    	if ( i == 1 ) {			//!upper row, left
	    		Formatting(dc,i,fieldValue[i],fieldFormat[i],fieldLabel[i],"060,056,065,015,062,060,032");
	       	} else if ( i == 2 ) {	//!upper row, right
	    		Formatting(dc,i,fieldValue[i],fieldFormat[i],fieldLabel[i],"160,056,160,111,062,160,032");
	       	} else if ( i == 3 ) {  //!middle row, left
	    		Formatting(dc,i,fieldValue[i],fieldFormat[i],fieldLabel[i],"060,115,000,000,000,060,085");
	       	} else if ( i == 4 ) {  //!middle row, right
	    		Formatting(dc,i,fieldValue[i],fieldFormat[i],fieldLabel[i],"160,115,000,000,000,160,085");
	       	} else if ( i == 5 ) {	//!lower row, left
	    		Formatting(dc,i,fieldValue[i],fieldFormat[i],fieldLabel[i],"140,159,138,086,165,065,168");
       		}       	
		}


		//! Top battery indicator
	 	var stats = Sys.getSystemStats();
		var pwr = stats.battery;
		var mBattcolor = (pwr > 15) ? mColourFont : Graphics.COLOR_RED;
		dc.setColor(mBattcolor, Graphics.COLOR_TRANSPARENT);
		dc.fillRectangle(125, 3, 15, 19);
		dc.fillRectangle(128, 1, 9, 3);
		
		dc.setColor(mColourBackGround, Graphics.COLOR_TRANSPARENT);
		var Endstatuspwrbr = 0.15*(100-pwr)  ;
		var Startstatuspwrbr = 5  ;
		dc.fillRectangle(127, Startstatuspwrbr, 11, Endstatuspwrbr);
	   
	}

}