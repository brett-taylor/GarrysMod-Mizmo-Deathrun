include("DisplayElements/cl_fonts.lua")
include("DisplayElements/cl_hud.lua")
include("hexcolor.lua")
include("config.lua")
include("cl_derma.lua")
include("shared.lua")
include("mapvote/sh_mapvote.lua")
include("mapvote/cl_mapvote.lua")
include("roundsystem/sh_round.lua")
include("roundsystem/cl_round.lua")
include("sh_definerounds.lua")
include("zones/sh_zone.lua")
include("zones/cl_zone.lua")
include("sh_buttonclaiming.lua")
include("sh_pointshopsupport.lua")
include("CameraController/cl_CameraController.lua")
include("CameraController/cl_CutsceneSystem.lua");
include("CameraController/cl_CutsceneIntroductionOverlay.lua");

concommand.Add("dr_test_menu", function()
	local frame = vgui.Create("arizard_window")
	frame:SetSize(640,480)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Test Window Please Ignore")
end)

function DR:ChatMessage( msg )
	chat.AddText(DR.Colors.Text.Clouds, "[", DR.Colors.Text.Turq, "DEATHRUN", DR.Colors.Text.Clouds, "] ",msg)
end

net.Receive("DeathrunChatMessage", function(len, ply)
	DR:ChatMessage( net.ReadString() )
end)

LocalPlayer().mutelist = LocalPlayer().mutelist or {}

net.Receive("DeathrunSyncMutelist", function(len, ply)
	LocalPlayer().mutelist = net.ReadTable()
end)

CreateClientConVar("deathrun_teammate_fade_distance", 75, true, false)
CreateClientConVar("deathrun_thirdperson_opacity", 255, true, false)

hook.Add("PrePlayerDraw", "TransparencyPlayers", function( ply )

	if ply:GetRenderMode() ~= RENDERMODE_TRANSALPHA then
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	end

	local fadedistance = GetConVarNumber("deathrun_teammate_fade_distance") or 75

	local eyedist = LocalPlayer():EyePos():Distance( ply:EyePos() )
	local col = ply:GetColor()

	if eyedist < fadedistance and LocalPlayer() ~= ply then
		local frac = InverseLerp( eyedist, 5, fadedistance )
		
		col.a = Lerp( frac, 20, 255 )

		if ply:Team() ~= LocalPlayer():Team() then col.a = 255 end

		ply:SetColor( col )
	elseif LocalPlayer() == ply then
		col.a = GetConVarNumber("deathrun_thirdperson_opacity") or 255
		ply:SetColor( col )
	else
		col.a = 255
		ply:SetColor( col )
	end

end)

function GM:PreDrawViewModel( vm, ply, wep )
	local ply = LocalPlayer()
	if ply:GetObserverMode() == OBS_MODE_CHASE or ply:GetObserverMode() == OBS_MODE_ROAMING then
		return true
	end
end
function GM:PreDrawPlayerHands( hands, vm, ply, wep )
	if ply:GetObserverMode() == OBS_MODE_CHASE or ply:GetObserverMode() == OBS_MODE_ROAMING then
		return true
	end
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, filter)
	if ply:Team() == TEAM_GHOST then
		return true
	end
end

concommand.Add("+menu", function()
	RunConsoleCommand("deathrun_dropweapon")
end)
