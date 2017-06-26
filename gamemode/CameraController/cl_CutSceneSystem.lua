CameraController.CutsceneSystem = {}
CameraController.CutsceneSystem.SpeedMultipler = 100;

CameraController.CutsceneSystem.InCutscene = false;
CameraController.CutsceneSystem.ReplayCutScene = false;
CameraController.CutsceneSystem.Positions = {}
CameraController.CutsceneSystem.CurrentStage = 1;
CameraController.CutsceneSystem.LerpPercentage = 0;
CameraController.CutsceneSystem.StartingPosition = nil;
CameraController.CutsceneSystem.EndingPosition = nil;
CameraController.CutsceneSystem.CurrentPosition = nil;
CameraController.CutsceneSystem.StartingAngle = nil;
CameraController.CutsceneSystem.EndingAngle = nil;
CameraController.CutsceneSystem.CurrentAngle = nil;

function CameraController.CutsceneSystem.StartCutScene(positionsTable, replayCutscene)
	CameraController.CutsceneSystem.InCutscene = true;
	CameraController.CutsceneSystem.Positions = positionsTable;
	CameraController.CutsceneSystem.ReplayCutScene  = replayCutscene;
	CameraController.CutsceneSystem.CurrentStage = 0;
	CameraController.CutsceneSystem.LerpPercentage = 0;
end

function CameraController.CutsceneSystem.EndCutScene()
 	CameraController.CutsceneSystem.ResetCutScene()
	CameraController.CutsceneSystem.Positions = {}
	CameraController.CutsceneSystem.InCutscene = false;
end

function CameraController.CutsceneSystem.ResetCutScene()
	CameraController.CutsceneSystem.CurrentStage = 0;
	CameraController.CutsceneSystem.LerpPercentage = 0;
	CameraController.CutsceneSystem.StartingPosition = nil;
	CameraController.CutsceneSystem.EndingPosition = nil;
	CameraController.CutsceneSystem.CurrentPosition = nil;
	CameraController.CutsceneSystem.StartingAngle = nil;
	CameraController.CutsceneSystem.EndingAngle = nil;
	CameraController.CutsceneSystem.CurrentAngle = nil;
end

function CameraController.CutsceneSystem.GenerateViewMatrix(ply, pos, angles, fov)
	if (CameraController.CutsceneSystem.InCutscene == true) then
		return CameraController.CutsceneSystem.GenerateViewMatrix(ply, pos, angles, fov);
	end
end
hook.Add("CalcView", "MizmoCutSceneGenerateViewMatrix", CameraController.CutsceneSystem.GenerateViewMatrix)

function CameraController.CutsceneSystem.GenerateViewMatrix(ply, pos, angles, fov)
	local matrix = {}
	matrix.origin = CameraController.CutsceneSystem.CurrentPosition;
	matrix.angles = CameraController.CutsceneSystem.CurrentAngle;
	matrix.fov = fov;
	matrix.drawviewer = true;
	return matrix;
end

function CameraController.CutsceneSystem.Think()
	-- If we arent in a cutscene return
	if (CameraController.CutsceneSystem.InCutscene == false) then
		return
	end

	-- Firstly check if our startingPosition and endingposition are null or equal together.
	if ((CameraController.CutsceneSystem.StartingPosition == nil || CameraController.CutsceneSystem.EndingPosition == nil) || CameraController.CutsceneSystem.StartngPosition == CameraController.CutsceneSystem.EndingPosition || CameraController.CutsceneSystem.LerpPercentage >= 1) then
		CameraController.CutsceneSystem.CurrentStage = CameraController.CutsceneSystem.CurrentStage + 1;

		-- Check the new values exist
		if (CameraController.CutsceneSystem.Positions[CameraController.CutsceneSystem.CurrentStage] == nil || CameraController.CutsceneSystem.Positions[CameraController.CutsceneSystem.CurrentStage + 1] == nil || CameraController.CutsceneSystem.CurrentStage > #CameraController.CutsceneSystem.Positions) then
			if (CameraController.CutsceneSystem.ReplayCutScene == true) then
				CameraController.CutsceneSystem.ResetCutScene()
			else
				CameraController.CutsceneSystem.EndCutScene()
			end
			return;
		end
		
		CameraController.CutsceneSystem.LerpPercentage = 0;
		CameraController.CutsceneSystem.StartingPosition = CameraController.CutsceneSystem.Positions[CameraController.CutsceneSystem.CurrentStage].Position;
		CameraController.CutsceneSystem.EndingPosition = CameraController.CutsceneSystem.Positions[CameraController.CutsceneSystem.CurrentStage + 1].Position;
		CameraController.CutsceneSystem.CurrentPosition = nil;
		CameraController.CutsceneSystem.StartingAngle = CameraController.CutsceneSystem.Positions[CameraController.CutsceneSystem.CurrentStage].Angle;
		CameraController.CutsceneSystem.EndingAngle = CameraController.CutsceneSystem.Positions[CameraController.CutsceneSystem.CurrentStage + 1].Angle;
		CameraController.CutsceneSystem.CurrentAngle = nil;
	end

	-- If Both starting and ending positions are valid then lerp our progress abit using FrameTime()
	if (CameraController.CutsceneSystem.StartingPosition ~= nil && CameraController.CutsceneSystem.EndingPosition ~= nil) then
		local percentageToBeIncreasedBy = (FrameTime() * CameraController.CutsceneSystem.SpeedMultipler) / CameraController.CutsceneSystem.StartingPosition:Distance(CameraController.CutsceneSystem.EndingPosition);
		CameraController.CutsceneSystem.LerpPercentage = math.Clamp(CameraController.CutsceneSystem.LerpPercentage + percentageToBeIncreasedBy, 0, 1);
		CameraController.CutsceneSystem.CurrentPosition = LerpVector(CameraController.CutsceneSystem.LerpPercentage, CameraController.CutsceneSystem.StartingPosition, CameraController.CutsceneSystem.EndingPosition);
		CameraController.CutsceneSystem.CurrentAngle = LerpVector(CameraController.CutsceneSystem.LerpPercentage, CameraController.CutsceneSystem.StartingAngle, CameraController.CutsceneSystem.EndingAngle);
	end

	hook.Run("MizmoInCutscene");
end
hook.Add("Think", "MizmoCutsceneThink", CameraController.CutsceneSystem.Think);