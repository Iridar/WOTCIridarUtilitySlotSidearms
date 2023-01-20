//-----------------------------------------------------------
//	Class:	WOTCIridarUtilitySlotSidearms_MCMScreenListener
//	Author: Iridar
//	
//-----------------------------------------------------------

class WOTCIridarUtilitySlotSidearms_MCMScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local WOTCIridarUtilitySlotSidearms_MCMScreen MCMScreen;

	if (ScreenClass==none)
	{
		if (MCM_API(Screen) != none)
			ScreenClass=Screen.Class;
		else return;
	}

	MCMScreen = new class'WOTCIridarUtilitySlotSidearms_MCMScreen';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}
