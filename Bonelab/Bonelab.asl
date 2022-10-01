//Load remover in testing, created by Meta and Sychke

state("BONELAB_Steam_Windows64", "Steam v1.10")
{
    int loading : "UnityPlayer.dll", 0x1A01CA4; // checking for value 32762
}

// loading 32762

init
{
    vars.loading = false;

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
//DEBUG CODE 
//print(current.loading.ToString()); 
//print(current.objective.ToString());

        //Use cases for each version of the game listed in the State method
		switch (version) 
	{
		case "Steam v1.10":
			vars.loading = current.loading == 32762;
			break;
	}

}

isLoading
{
    return vars.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}