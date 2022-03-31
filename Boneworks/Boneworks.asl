// currentLevel: The id of the current level
// 	Main Menu = 1, CutsceneOne = 2, BreakRoom = 3, Museum = 4, Streets = 5, Runoff = 6, Sewers = 7, Warehouse = 8, Central Station = 9,
//	Tower = 10, Time Tower = 11, CutsceneTwo = 12, Dungeon = 13, Arena = 14, Throne Room = 15

state("BONEWORKS"){ //This should default to CurrentUpdate values
	int levelNumber : "GameAssembly.dll", 0x01E7E4E0, 0xB8, 0x590;
	int loadingCheck : "vrclient_x64.dll", 0x00423A88, 0x8, 0xD5C;
}

init{
	vars.stillLoading = 0;
	vars.levelNumGreater = 0;
}

isLoading{
	return current.loadingCheck == 1;
}

start{
	if (current.levelNumber > 1){
		if (current.loadingCheck == 1){
			return true;
		}
	}
}

split{
	if (current.levelNumber > old.levelNumber){
		vars.levelNumGreater = 1;
	}
	if ((vars.levelNumGreater == 1) && (vars.stillLoading == 0) && (current.loadingCheck == 1)){
		vars.stillLoading = 1;
		return true;
	}
	else if ((vars.stillLoading == 1) && current.loadingCheck == 0){
		vars.stillLoading = 0;
		vars.levelNumGreater = 0;
	}
}

reset{
	if (current.levelNumber == 1){
		return true;
	}
}
