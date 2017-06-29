function ulx.AddNewIntroductionNode(callingPlayer, shouldTeleport)
   	ulx.AddCutsceneNode(callingPlayer, CameraController:CalculateIntroductionSceneName(), shouldTeleport)
end

local addaintroductionnode = ulx.command("Camera Controller", "ulx addintroductionnode", ulx.AddNewIntroductionNode, "!addintroductionnode");
addaintroductionnode:defaultAccess(ULib.ACCESS_ADMIN);
addaintroductionnode:addParam{type=ULib.cmds.BoolArg}
addaintroductionnode:help("Adds a new node to the introduction cutscene of that map.");

function ulx.AddCutsceneNode(callingPlayer, nameOfCutscene, shouldTeleport)
	CameraController.Data.AddNewCutscenePosition(nameOfCutscene, callingPlayer:EyePos(), callingPlayer:EyeAngles(), shouldTeleport);
end

local addnewcutscenenode = ulx.command("Camera Controller", "ulx addcutscenenode", ulx.AddCutsceneNode, "!addcutscenenode");
addnewcutscenenode:defaultAccess(ULib.ACCESS_ADMIN);
addnewcutscenenode:addParam{type=ULib.cmds.StringArg}
addnewcutscenenode:addParam{type=ULib.cmds.BoolArg}
addnewcutscenenode:help("Adds a new node to the cutscene specified.");