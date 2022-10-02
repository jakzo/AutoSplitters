//Load remover in testing, created by Meta and Sychke
//Current issues: only looks for steam executable, the loading values are different despite same hashchecks of UnityPlayer.dll for the steam version

state("BONELAB_Steam_Windows64", "Steam v1.10")
{
    int loadingCheck : "UnityPlayer.dll", 0x1A01CA4; // checking for value 32762 and 32763
}

// loading 32762, 32763

init
{
    switch (modules.First().ModuleMemorySize) 
    {
        case 675840: 
            version = "Steam v1.10";
            break;
		default:
			print("Unknown version detected");
			return false;
    }
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | BONELAB",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

onStart
{
	// This makes sure the timer always starts at 0.00
	timer.IsGameTimePaused = true;
}

update
{
	//DEBUG CODE, REMOVE COMMENTS TO ACTIVATE
	//print(current.loadingCheck.ToString()); 
	//print(current.objective.ToString());
}

isLoading
{
	return (current.loadingCheck == 32762) || (current.loadingCheck == 32763);
}

exit
{
	timer.IsGameTimePaused = true;
}
