function CameraController.CutsceneSystem.IntroductionOverlay()
	/*if (CameraController.CutsceneSystem.InCutscene == false) then
		return;
	end*/

	draw.SimpleTextOutlined("Mizmo-Gaming", "MizmoGaming-Intro-Big", ScrW() / 2, ScrH() / 2 - 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	draw.SimpleTextOutlined("Welcome To", "MizmoGaming-Intro-Small", ScrW() / 2, ScrH() / 2 - 150, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	draw.SimpleTextOutlined(">> Press Enter To Continue <<", "MizmoGaming-Intro-Subhead", ScrW() / 2, ScrH() / 2 - 55, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	return false;
end

hook.Add("HUDPaint", "MizmoIntroductionOverlay", CameraController.CutsceneSystem.IntroductionOverlay);