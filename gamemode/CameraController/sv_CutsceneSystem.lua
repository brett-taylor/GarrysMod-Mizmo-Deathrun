CameraController = {}

util.AddNetworkString("TriggerCutScene");

function CameraController.RunCutscene(ply, cutsceneName)
	local cutscene = CameraController.Data.LoadCutSceneFromDatabase(cutsceneName);
	if (cutscene ~= nil) then
		net.Start("TriggerCutScene");
			net.WriteTable(cutscene);
		net.Send(ply);
	end
end

function CameraController.CalculateIntroductionSceneName()
	return game.GetMap().."-introduction";
end

concommand.Add("loadcutscene", function(ply, cmd, args)
	player.GetAll()[1]:RunCutscene(CameraController.CalculateIntroductionSceneName());
end)

concommand.Add("printcutscene", function(ply, cmd, args)
	CameraController.Data.SaveCutsceneDataToFile(CameraController.CalculateIntroductionSceneName());
end);