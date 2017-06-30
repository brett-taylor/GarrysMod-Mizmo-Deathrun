function ulx.AddNewIntroductionNode(callingPlayer, shouldTeleport)
   	ulx.AddCutsceneNode(callingPlayer, CameraController:CalculateIntroductionSceneName(), shouldTeleport)
end

local addaintroductionnode = ulx.command("CameraController", "ulx addintroductionnode", ulx.AddNewIntroductionNode, "!addintroductionnode");
addaintroductionnode:defaultAccess(ULib.ACCESS_ADMIN);
addaintroductionnode:addParam{type=ULib.cmds.BoolArg}
addaintroductionnode:help("Adds a new node to the introduction cutscene of that map.");

function ulx.AddCutsceneNode(callingPlayer, nameOfCutscene, shouldTeleport)
	ulx.fancyLogAdmin(callingPlayer, "#A created a new cutscene node for cutscene: #s, which teleports: #s.", nameOfCutscene, shouldTeleport);
	CameraController.Data.AddNewCutscenePosition(nameOfCutscene, callingPlayer:EyePos(), callingPlayer:EyeAngles(), shouldTeleport);
end

local addnewcutscenenode = ulx.command("CameraController", "ulx addcutscenenode", ulx.AddCutsceneNode, "!addcutscenenode");
addnewcutscenenode:defaultAccess(ULib.ACCESS_ADMIN);
addnewcutscenenode:addParam{type=ULib.cmds.StringArg}
addnewcutscenenode:addParam{type=ULib.cmds.BoolArg}
addnewcutscenenode:help("Adds a new node to the cutscene specified.");

function ulx.SaveIntroductionToSqlDocument(callingPlayer, nameOfcutscene)
	 ulx.SaveCutsceneToSqlDocument(callingPlayer, CameraController:CalculateIntroductionSceneName());
end

local savecutsceneintroduction = ulx.command("CameraController", "ulx saveintroduction", ulx.SaveIntroductionToSqlDocument, "!saveintroduction");
savecutsceneintroduction:defaultAccess(ULib.ACCESS_ADMIN);
savecutsceneintroduction:help("Saves the cutscene information to an sql document.");

function ulx.SaveCutsceneToSqlDocument(callingPlayer, nameOfcutscene)
	ulx.fancyLogAdmin(callingPlayer, "#A saved the cutscene: #s.", nameOfcutscene);
	CameraController.Data.SaveCutsceneDataToFile(nameOfcutscene);
end

local savecutscene = ulx.command("CameraController", "ulx savecutscene", ulx.SaveCutsceneToSqlDocument, "!savecutscene");
savecutscene:defaultAccess(ULib.ACCESS_ADMIN);
savecutscene:addParam{type=ULib.cmds.StringArg}
savecutscene:help("Saves the cutscene information to an sql document.");

function ulx.SaveAllCutscenes(callingPlayer, nameOfcutscene)
	ulx.fancyLogAdmin(callingPlayer, "#A saved all cutscenes.");
	CameraController.Data.SaveAllCutscenes();
end

local saveallcutscenes = ulx.command("CameraController", "ulx saveallcutscenes", ulx.SaveAllCutscenes, "!saveallcutscenes");
saveallcutscenes:defaultAccess(ULib.ACCESS_ADMIN);
saveallcutscenes:help("Saves all the cutscenes to an sql document.");