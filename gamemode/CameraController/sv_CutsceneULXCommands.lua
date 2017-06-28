function ulx.AddNewIntroductionNode(callingPlayer)
	local nameOfCutscene = CameraController:CalculateIntroductionSceneName();
   	ulx.AddCutsceneNode(callingPlayer, nameOfCutscene)
end

local addaintroductionnode = ulx.command("Camera Controller", "ulx addintroductionnode", ulx.AddNewIntroductionNode, "!addintroductionnode");
addaintroductionnode:defaultAccess(ULib.ACCESS_ADMIN);
addaintroductionnode:help("Adds a new node to the introduction cutscene of that map.");

function ulx.AddCutsceneNode(callingPlayer, nameOfCutscene)
	CameraController.Data.AddNewCutscenePosition(nameOfCutscene, callingPlayer:EyePos(), callingPlayer:EyeAngles());
end

local addnewcutscenenode = ulx.command("Camera Controller", "ulx addcutscenenode", ulx.AddCutsceneNode, "!addcutscenenode");
addnewcutscenenode:defaultAccess(ULib.ACCESS_ADMIN);
addnewcutscenenode:addParam{type=ULib.cmds.StringArg}
addnewcutscenenode:help("Adds a new node to the introduction cutscene of that map.");