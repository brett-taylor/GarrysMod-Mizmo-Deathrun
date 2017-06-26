CameraController = {}

net.Receive( "TriggerCutScene", function()
	local cutsceneData = net.ReadTable();
	CameraController.CutsceneSystem.StartCutScene(cutsceneData.Nodes, false);
end)