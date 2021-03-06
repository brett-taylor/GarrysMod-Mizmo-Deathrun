CameraController.CutsceneSystem.Introduction = {};
CameraController.CutsceneSystem.Introduction.Alpha = 50;

function CameraController.CutsceneSystem.Introduction.DrawOverlay()
	if (CameraController.CutsceneSystem.InCutscene == false) then
		return;
	end

	if (LocalPlayer():GetNWString(PlayerSettings.Enums.IS_DEBUGGING.Name) == "1") then
		draw.SimpleTextOutlined("In Cutscene: "..tostring(CameraController.CutsceneSystem.InCutscene), "MizmoGaming-Intro-Small", 5, 40, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined("Lerp: "..tostring(CameraController.CutsceneSystem.LerpPercentage), "MizmoGaming-Intro-Small", 5, 80, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined("C. Stage: "..tostring(CameraController.CutsceneSystem.CurrentStage), "MizmoGaming-Intro-Small", 5, 120, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined("Teleport: "..tostring(CameraController.CutsceneSystem.ShouldTeleport), "MizmoGaming-Intro-Small", 5, 160, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined("CurrentPosition: "..tostring(CameraController.CutsceneSystem.CurrentPosition), "MizmoGaming-Intro-Small", 5, 200, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
	end

	if (CameraController.CutsceneSystem.Name ~= game.GetMap().."-introduction") then
		return;
	end

	draw.SimpleTextOutlined("Mizmo-Gaming", "MizmoGaming-Intro-Big", ScrW() / 2, ScrH() / 2 - 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	draw.SimpleTextOutlined("Welcome To", "MizmoGaming-Intro-Small", ScrW() / 2, ScrH() / 2 - 145, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	draw.SimpleTextOutlined(">> Press Space To Continue <<", "MizmoGaming-Intro-Subhead", ScrW() / 2, ScrH() / 2 - 55, Color(255, 255, 255, CameraController.CutsceneSystem.Introduction.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, CameraController.CutsceneSystem.Introduction.Alpha))
	CameraController.CutsceneSystem.Introduction.Alpha = math.Clamp(math.abs(math.sin(CurTime() * 2)) * 255, 50, 255);
	
	surface.SetFont("MizmoGaming-Intro-Big");
	local widthOfHeading, heightOfHeading = surface.GetTextSize("Mizmo-Gaming");
	draw.SimpleTextOutlined("www.", "MizmoGaming-Intro-Small", ScrW() / 2 - (widthOfHeading / 2), ScrH() / 2 - heightOfHeading, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	draw.SimpleTextOutlined(".co.uk", "MizmoGaming-Intro-Small", ScrW() / 2 + (widthOfHeading / 2), ScrH() / 2 - heightOfHeading, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))

	return false;
end
hook.Add("HUDPaint", "MizmoIntroductionOverlay", CameraController.CutsceneSystem.Introduction.DrawOverlay);

function CameraController.CutsceneSystem.Introduction.Skip(ply, key)
	if (CameraController.CutsceneSystem.InCutscene == false) then
		return;
	end

	if (CameraController.CutsceneSystem.Name ~= game.GetMap().."-introduction") then
		return;
	end

	if (key == 2)then
		CameraController.SendRequestToEndCutscene();
	end
end
hook.Add("KeyPress", "MizmoIntroductionOveralKeyPressed", CameraController.CutsceneSystem.Introduction.Skip)