CameraController.CutSceneSystem = {}
CameraController.CutSceneSystem.SpeedMultipler = 100;

CameraController.CutSceneSystem.InCutscene = false;
CameraController.CutSceneSystem.ReplayCutScene = false;
CameraController.CutSceneSystem.Positions = {}
CameraController.CutSceneSystem.CurrentStage = 1;
CameraController.CutSceneSystem.LerpPercentage = 0;
CameraController.CutSceneSystem.StartingPosition = nil;
CameraController.CutSceneSystem.EndingPosition = nil;
CameraController.CutSceneSystem.CurrentPosition = nil;
CameraController.CutSceneSystem.StartingAngle = nil;
CameraController.CutSceneSystem.EndingAngle = nil;
CameraController.CutSceneSystem.CurrentAngle = nil;

function CameraController.CutSceneSystem.StartCutScene(positionsTable, replayCutscene)
	CameraController.CutSceneSystem.InCutscene = true;
	CameraController.CutSceneSystem.Positions = positionsTable;
	CameraController.CutSceneSystem.ReplayCutScene  = replayCutscene;
	CameraController.CutSceneSystem.CurrentStage = 0;
	CameraController.CutSceneSystem.LerpPercentage = 0;
end

function CameraController.CutSceneSystem.EndCutScene()
 	CameraController.CutSceneSystem.ResetCutScene()
	CameraController.CutSceneSystem.Positions = {}
	CameraController.CutSceneSystem.InCutscene = false;
end

function CameraController.CutSceneSystem.ResetCutScene()
	CameraController.CutSceneSystem.CurrentStage = 0;
	CameraController.CutSceneSystem.LerpPercentage = 0;
	CameraController.CutSceneSystem.StartingPosition = nil;
	CameraController.CutSceneSystem.EndingPosition = nil;
	CameraController.CutSceneSystem.CurrentPosition = nil;
	CameraController.CutSceneSystem.StartingAngle = nil;
	CameraController.CutSceneSystem.EndingAngle = nil;
	CameraController.CutSceneSystem.CurrentAngle = nil;
end

function CameraController.CutSceneSystem.GenerateViewMatrix(ply, pos, angles, fov)
	if (CameraController.CutSceneSystem.InCutscene == true) then
		return CameraController.CutSceneSystem.GenerateViewMatrix(ply, pos, angles, fov);
	end
end
hook.Add("CalcView", "MizmoCutSceneGenerateViewMatrix", CameraController.CutSceneSystem.GenerateViewMatrix)

function CameraController.CutSceneSystem.GenerateViewMatrix(ply, pos, angles, fov)
	local matrix = {}
	matrix.origin = CameraController.CutSceneSystem.CurrentPosition;
	matrix.angles = CameraController.CutSceneSystem.CurrentAngle;
	matrix.fov = fov;
	matrix.drawviewer = true;
	return matrix;
end

function CameraController.CutSceneSystem.Think()
	-- If we arent in a cutscene return
	if (CameraController.CutSceneSystem.InCutscene == false) then
		return
	end

	-- Firstly check if our startingPosition and endingposition are null or equal together.
	if ((CameraController.CutSceneSystem.StartingPosition == nil || CameraController.CutSceneSystem.EndingPosition == nil) || CameraController.CutSceneSystem.StartngPosition == CameraController.CutSceneSystem.EndingPosition || CameraController.CutSceneSystem.LerpPercentage >= 1) then
		CameraController.CutSceneSystem.CurrentStage = CameraController.CutSceneSystem.CurrentStage + 1;

		-- Check the new values exist
		if (CameraController.CutSceneSystem.Positions[CameraController.CutSceneSystem.CurrentStage] == nil || CameraController.CutSceneSystem.Positions[CameraController.CutSceneSystem.CurrentStage + 1] == nil || CameraController.CutSceneSystem.CurrentStage > #CameraController.CutSceneSystem.Positions) then
			print(CameraController.CutSceneSystem.ReplayCutScene);
			if (CameraController.CutSceneSystem.ReplayCutScene == true) then
				CameraController.CutSceneSystem.ResetCutScene()
			else
				CameraController.CutSceneSystem.EndCutScene()
			end

			return;
		end
		
		CameraController.CutSceneSystem.LerpPercentage = 0;
		CameraController.CutSceneSystem.StartingPosition = CameraController.CutSceneSystem.Positions[CameraController.CutSceneSystem.CurrentStage][1];
		CameraController.CutSceneSystem.EndingPosition = CameraController.CutSceneSystem.Positions[CameraController.CutSceneSystem.CurrentStage + 1][1];
		CameraController.CutSceneSystem.CurrentPosition = nil;
		CameraController.CutSceneSystem.StartingAngle = CameraController.CutSceneSystem.Positions[CameraController.CutSceneSystem.CurrentStage][2];
		CameraController.CutSceneSystem.EndingAngle = CameraController.CutSceneSystem.Positions[CameraController.CutSceneSystem.CurrentStage + 1][2];
		CameraController.CutSceneSystem.CurrentAngle = nil;
	end

	-- If Both starting and ending positions are valid then lerp our progress abit using FrameTime()
	if (CameraController.CutSceneSystem.StartingPosition ~= nil && CameraController.CutSceneSystem.EndingPosition ~= nil) then
		local percentageToBeIncreasedBy = (FrameTime() * CameraController.CutSceneSystem.SpeedMultipler) / CameraController.CutSceneSystem.StartingPosition:Distance(CameraController.CutSceneSystem.EndingPosition);
		CameraController.CutSceneSystem.LerpPercentage = math.Clamp(CameraController.CutSceneSystem.LerpPercentage + percentageToBeIncreasedBy, 0, 1);
		CameraController.CutSceneSystem.CurrentPosition = LerpVector(CameraController.CutSceneSystem.LerpPercentage, CameraController.CutSceneSystem.StartingPosition, CameraController.CutSceneSystem.EndingPosition);
		CameraController.CutSceneSystem.CurrentAngle = LerpVector(CameraController.CutSceneSystem.LerpPercentage, CameraController.CutSceneSystem.StartingAngle, CameraController.CutSceneSystem.EndingAngle);
	end
end
hook.Add("Think", "MizmoCutsceneThink", CameraController.CutSceneSystem.Think);