util.AddNetworkString("Mizmo-TriggerCutScene");
util.AddNetworkString("Mizmo-EndCutScene");
util.AddNetworkString("Mizmo-RequestToEndCutScene");
CameraController = {}
CameraController.CachedIntroductionScene = nil;

function CameraController.CalculateIntroductionSceneName()
	return game.GetMap().."-introduction";
end

function CameraController.RunCutscene(ply, cutsceneData)
	if (cutsceneData ~= nil) then
		net.Start("Mizmo-TriggerCutScene");
			net.WriteTable(cutsceneData);
		net.Send(ply);
	end
end

function CameraController.RunCutsceneName(ply, cutsceneName)
	CameraController.RunCutscene(ply, CameraController.Data.LoadCutSceneFromDatabase(cutsceneName))
end

function CameraController.RunCutsceneIntroduction(ply)
	if (CameraController.CachedIntroductionScene ~= nil) then
		if (CameraController.CachedIntroductionScene.Name == CameraController.CalculateIntroductionSceneName()) then
			CameraController.RunCutscene(ply, CameraController.CachedIntroductionScene);
		end
	else
		CameraController.CachedIntroductionScene = CameraController.Data.LoadCutSceneFromDatabase(CameraController.CalculateIntroductionSceneName());
		CameraController.RunCutscene(ply, CameraController.CachedIntroductionScene);
	end
end

function CameraController.EndCutscene(ply)
	net.Start("Mizmo-EndCutScene");
	net.Send(ply);
end

function CameraController.EndCutsceneForAll()
	net.Start("Mizmo-EndCutScene");
	net.Broadcast();
end

net.Receive("Mizmo-RequestToEndCutScene", function(length, ply)
	CameraController.EndCutscene(ply);
end);

function CameraController.OnPlayerInitialSpawn(ply)
	CameraController.RunCutsceneIntroduction(ply);
end
hook.Add("PlayerInitialSpawn", "MizmoIntroductionCutSceneTrigger", CameraController.OnPlayerInitialSpawn);

function CameraController.OnPrepBegin()
	CameraController.EndCutsceneForAll()
end
hook.Add("DeathrunBeginPrep", "MizmoCutsceneCancelPrepBegan", CameraController.OnPrepBegin);