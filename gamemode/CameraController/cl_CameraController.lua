CameraController = {}

concommand.Add("cutscene", function(ply, cmd, args)
	CameraController.CutSceneSystem.StartCutScene(TestPositions, true);
end)

concommand.Add("endcutscene", function(ply, cmd, args)
	CameraController.CutSceneSystem.EndCutScene();
end)

TestPositions = {}
TestPositions[1] = {Vector(817.042114, -1101.593506, 396.740967), Vector(6.951989, 84.126450, 0.000000), false}
TestPositions[2] = {Vector(876.105286, -388.392120, 396.556610), Vector(0.747988, 122.054390, 0.000000), false}
TestPositions[3] = {Vector(719.893921, -173.939911, 393.799438), Vector(5.280004, 42.898323, 0.000000), false}
TestPositions[4] = {Vector(884.710938, 2.449790, 389.450653), Vector(-0.483998, 117.258430, 0.000000), false}