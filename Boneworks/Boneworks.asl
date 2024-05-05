//	Autosplitter created by Radioactiv03 and Sychke, currently maintained by Sychke
//	Boneworks Speedrunning Discord Server: https://discord.gg/MW2zUcV2Fv

//	levelNumber is the ID of the current level
// 	Main Menu = 1, CutsceneOne = 2, BreakRoom = 3, Museum = 4, Streets = 5, Runoff = 6, Sewers = 7, Warehouse = 8,
//	Central Station = 9, Tower = 10, Time Tower = 11, CutsceneTwo = 12, Dungeon = 13, Arena = 14, Throne Room = 15

state("BONEWORKS"){	//levelNumber should always be accurate
	int levelNumber : "GameAssembly.dll", 0x01E7E4E0, 0xB8, 0x590;
}

init{
	var module = modules.First(x => x.ModuleName =="vrclient_x64.dll");

    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
	
	vars.loadingPointer = scanner.Scan(new SigScanTarget(3, "488B??????????FF????440F????4885??74??8B") { 
    OnFound = (process, scanners, addr) => addr + 0xC + process.ReadValue<int>(addr)
    });
	if (vars.loadingPointer == IntPtr.Zero)
    {
            throw new Exception("Game engine not initialized - retrying");
    }
	
	vars.isLoading = new MemoryWatcher<bool>(new DeepPointer(vars.loadingPointer,0xC64));
	
	vars.stillLoading = 0;
	vars.levelNumGreater = 0;
}

update{
	vars.isLoading.Update(game);
}

isLoading{
	return vars.isLoading.Current;
}

start{
	//Starts if the levelNumber is greater than 1 and isLoading is true
	if (current.levelNumber > 1){
		return vars.isLoading.Current;
	}
}

//THIS CODE COULD PROBABLY BE CLEANED UP CONSIDERABLY TO ACCOMPLISH THE SAME THING
//ITS FUNCTIONAL, IT'S AN AUTOSPLITTER, WHO CARES, I DON'T, I'M LEAVING IT THE SAME AS BEFORE
split{
	//Checks if the new levelNumber is greater than the old levelNumber
	if (current.levelNumber > old.levelNumber){
		vars.levelNumGreater = 1;
	}
	//If you are in throne room and 
	if (current.levelNumber == 1 && old.levelNumber == 15 && vars.isLoading.Current){
		return true;
	}
	//When the new levelNumber is greater than the old levelNumber and you are loading, it will split once
	else if (vars.levelNumGreater == 1 && vars.stillLoading == 0 && vars.isLoading.Current){
		vars.stillLoading = 1;
		return true;
	}
	//Activates when you stop loading
	else if (vars.stillLoading == 1 && vars.isLoading.Current){
		vars.stillLoading = 0;
		vars.levelNumGreater = 0;
	}
}

reset{
	//Allows restarting a level, but does not work in Throne Room
	if (current.levelNumber < old.levelNumber && old.levelNumber != 15){
		return true;
	}
}

exit{
	timer.IsGameTimePaused = true;
}
