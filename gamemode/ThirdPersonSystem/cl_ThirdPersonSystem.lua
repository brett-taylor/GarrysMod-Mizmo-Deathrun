ThirdPersonSystemClient = {};
ThirdPersonSystemClient.IsInThirdPerson = false;

net.Receive("MizmoThirdPerson", function()
	ThirdPersonSystemClient.EnableThirdPerson(net.ReadBool());
end)

function ThirdPersonSystemClient.EnableThirdPerson(enabled)
	ThirdPersonSystemClient.IsInThirdPerson = enabled;
end

function ThirdPersonSystemClient.GetPlayerSetting()
	net.Start("MizmoRequestThirdPersonSetting");
 	net.SendToServer();
end
ThirdPersonSystemClient.GetPlayerSetting();

function ThirdPersonSystemClient.ThirdPersonView(ply, pos, angles, fov)
	-- Check the user actually wants third person.
	if (ThirdPersonSystemClient.IsInThirdPerson == false) then
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