include("Util/sh_colours.lua")
include("Util/sh_lerpColour.lua");
include("Util/sh_sendMessage.lua");
include("Util/sh_playerTags.lua");
include("Util/sh_groups.lua");

include("PlayerSettings/sh_playerSettingsEnums.lua")

include("DisplayElements/cl_fonts.lua")
include("DisplayElements/cl_hud.lua")
include("DisplayElements/cl_voicehud.lua")
include("DisplayElements/cl_scoreboard.lua")

include("ButtonClaiming/cl_showButtonClaimed.lua");

include("config.lua")
include("shared.lua")
include("mapvote/sh_mapvote.lua")
include("mapvote/cl_mapvote.lua")
include("roundsystem/sh_round.lua")
include("roundsystem/cl_round.lua")
include("sh_definerounds.lua")
include("zones/sh_zone.lua")
include("zones/cl_zone.lua")

include("CameraController/cl_cameraController.lua")
include("CameraController/cl_cutsceneSystem.lua");
include("CameraController/cl_cutsceneIntroductionOverlay.lua");

include("ThirdPersonSystem/cl_thirdPersonSystem.lua");

include("Playtime/cl_playtime.lua");

include("Pointshop/cl_init.lua");

include("EndOfRound/cl_endRound.lua");

include("Autojump/cl_autojump.lua");
include("Autojump/sh_autojump.lua");

include("NotificationSystem/cl_notificationSystemAlert.lua");
include("NotificationSystem/cl_notificationSystemMenu.lua");

include("DisplayElements/cl_betapopup.lua");

include("Knives/add_tfa_skins.lua");
include("Knives/csgo_knife_snd_init.lua");

include("UniqueRounds/cl_uniqueRounds.lua");

include("ChatSystem/cl_chat.lua");

PS:Initialize();

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
