//	Autosplitter created by DerkO9 and Sychke, currently maintained by Sychke
//	Boneworks Speedrunning Discord Server: https://discord.gg/MW2zUcV2Fv

//	levelNumber matches the ID of the current level
// 	Main Menu = 1, CutsceneOne = 2, BreakRoom = 3, Museum = 4, Streets = 5, Runoff = 6, Sewers = 7, Warehouse = 8,
//	Central Station = 9, Tower = 10, Time Tower = 11, CutsceneTwo = 12, Dungeon = 13, Arena = 14, Throne Room = 15

//	loadingCheck value instructions
//	Open Cheat Engine, select BONEWORKS.exe process, select vrclient_x64.dll under Memory Scan Options, First Scan for 0, 
//	Next Scan for 1 during a level load, add the address to address list, pointer scan for this address, set Max Level to 2,
//	untick Max Different Offsets Per Node, hit OK, find offsets 8 and D84, adjust loadingCheck address with the new base address.

state("BONEWORKS"){	//levelNumber should always be accurate, loadingCheck will need to be updated with new SteamVR versions
	int levelNumber : "GameAssembly.dll", 0x01E7E4E0, 0xB8, 0x590;
	int loadingCheck : "vrclient_x64.dll", 0x003D3278, 0x8, 0xD84;
}

init{
	vars.stillLoading = 0;
	vars.levelNumGreater = 0;
}

isLoading{
	return current.loadingCheck == 1;
}

start{
	//Starts when the level number is above 1(Main Menu) and when loading
	if (current.levelNumber > 1){
		if (current.loadingCheck == 1){
			return true;
		}
	}
}

split{
	//Checks if the new levelNumber is greater than the old levelNumber
	if (current.levelNumber > old.levelNumber){
		vars.levelNumGreater = 1;
	}
	//If you are in Throne Room and load in to the Main Menu via level list or hitting button, it will split
	if (current.levelNumber == 1 && old.levelNumber == 15 && current.loadingCheck == 1){
		return true;
	}
	//When the new levelNumber is greater than the old levelNumber and you are loading, it will split once
	else if ((vars.levelNumGreater == 1) && (vars.stillLoading == 0) && (current.loadingCheck == 1)){
		vars.stillLoading = 1;
		return true;
	}
	//Activates when you stop loading
	else if ((vars.stillLoading == 1) && current.loadingCheck == 0){
		vars.stillLoading = 0;
		vars.levelNumGreater = 0;
	}
}

reset{
	//You can restart a level without Livesplit resetting. This does not work in Throne Room because it will just split
	if (current.levelNumber < old.levelNumber && old.levelNumber != 15){
		return true;
	}
}
