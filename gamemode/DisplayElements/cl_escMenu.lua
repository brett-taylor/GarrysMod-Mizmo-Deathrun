EscapeMenu = {};
EscapeMenu.Panel = nil;

hook.Add("PreRender", "emenu_render", function()
	/*if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
		gui.HideGameUI()
		if (EscapeMenu.Panel == nil) then
			EscapeMenu.CreateMenu();
		elseif (EscapeMenu.Panel ~= nil) then
			EscapeMenu.Panel:Remove();
			EscapeMenu.Panel = nil;
		end
	end*/
end)

function EscapeMenu.CreateMenu()
	EscapeMenu.Panel = vgui.Create("DMizmoMainMenu");
end