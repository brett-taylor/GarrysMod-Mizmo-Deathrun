ThirdPersonSystemClient = {};

function ThirdPersonSystemClient.ThirdPersonView(ply, pos, angles, fov)
	-- Check the user actually wants third person.
	if (tonumber(ply:GetNWString(PlayerSettings.Enums.THIRD_PERSON.Name)) == 0) then
		return;
	end

	-- Checks the user is not in a cut scene.
	if (CameraController.CutsceneSystem.InCutscene == true) then
		return;
	end

	local view = {};
	view.origin = pos - (angles:Forward() * 100);
	view.angles = angles;
	view.fov = fov;
	view.drawviewer = true;

	return view;
end
hook.Add("CalcView", "MyCalcView", ThirdPersonSystemClient.ThirdPersonView);