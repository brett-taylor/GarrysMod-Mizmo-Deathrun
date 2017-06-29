CameraController = {}
CameraController.SentRequestToEndCutscene = false;

function CameraController.SendRequestToEndCutscene()
	if (CameraController.SentRequestToEndCutscene == false) then 
		CameraController.SentRequestToEndCutscene = true;
		net.Start("Mizmo-RequestToEndCutScene");
		net.SendToServer();
	end
end

net.Receive("Mizmo-TriggerCutScene", function()
	local cutsceneData = net.ReadTable();
	CameraController.CutsceneSystem.StartCutScene(cutsceneData.Name, cutsceneData.Nodes, false);
end);

net.Receive("Mizmo-EndCutScene", function()
	CameraController.SentRequestToEndCutscene = false;
	CameraController.CutsceneSystem.EndCutScene()
end);