include("Util/sh_colours.lua")
include("Util/sh_lerpColour.lua");
include("Util/sh_sendMessage.lua");
include("Util/sh_playerTags.lua");
include("Util/sh_groups.lua");
include("Util/sh_itemRarity.lua");
include("Util/cl_DisplayStuff.lua");
include("Util/sh_ChatColours.lua");

include("PlayerSettings/sh_playerSettingsEnums.lua")

include("DisplayElements/cl_fonts.lua")
include("DisplayElements/vgui/DMizmoFrame.lua")
include("DisplayElements/vgui/DMizmoButton.lua")
include("DisplayElements/vgui/DMizmoMainMenu.lua")
include("DisplayElements/vgui/DMizmoScroll.lua")
include("DisplayElements/vgui/DMizmoAvatar.lua")
include("DisplayElements/vgui/DMizmoTextEntry.lua")

include("DisplayElements/vgui/Shop/DMizmoShopFrame.lua")
include("DisplayElements/vgui/Shop/DMizmoShopInventory.lua")
include("DisplayElements/vgui/Shop/DMizmoShopCatButton.lua")
include("DisplayElements/vgui/Shop/DMizmoShopHeaderInfo.lua")
include("DisplayElements/vgui/Shop/DMizmoShopModelViewer.lua")
include("DisplayElements/vgui/Shop/DMizmoItem.lua")
include("DisplayElements/vgui/Shop/DMizmoItemModelVariant.lua")
include("DisplayElements/vgui/Shop/DMizmoItemMaterialVariant.lua")
include("DisplayElements/vgui/Shop/DMizmoItemTextVariant.lua")
include("DisplayElements/vgui/Shop/DMizmoShopLoading.lua")
include("DisplayElements/vgui/Shop/DMizmoShopAlert.lua")
include("DisplayElements/vgui/Shop/DMizmoShopTypeButton.lua")
include("DisplayElements/vgui/Shop/DMizmoShopTypePick.lua")
include("DisplayElements/vgui/Shop/DMizmoShopTab.lua")
include("DisplayElements/vgui/Shop/DMizmoShopItemData.lua")
include("DisplayElements/vgui/Shop/DMizmoShopFunctionButton.lua")

include("DisplayElements/cl_hud.lua")
include("DisplayElements/cl_voicehud.lua")
include("DisplayElements/cl_scoreboard.lua")
include("DisplayElements/cl_betapopup.lua");
include("DisplayElements/cl_escMenu.lua");

include("ButtonClaiming/cl_showButtonClaimed.lua");

include("config.lua")
include("shared.lua")
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

include("Knives/add_tfa_skins.lua");
include("Knives/csgo_knife_snd_init.lua");

include("UniqueRounds/cl_uniqueRounds.lua");

include("ChatSystem/cl_chat.lua");

include("DropWeapon/cl_dropweapon.lua");

include("Mapvote/mapvote.lua");
include("Mapvote/cl_mapvote.lua");

include( "Jukebox/lua/shared_settings.lua" )
include( "Jukebox/lua/client_base.lua" )
include( "Jukebox/lua/client_player.lua" )
include( "Jukebox/lua/client_hud.lua" )
include( "Jukebox/lua/vgui_base.lua" )
include( "Jukebox/lua/vgui_allsongs.lua" )
include( "Jukebox/lua/vgui_queue.lua" )
include( "Jukebox/lua/vgui_options.lua" )
include( "Jukebox/lua/vgui_request.lua" )
include( "Jukebox/lua/vgui_request_quick.lua" )
include( "Jukebox/lua/vgui_admin_requests.lua" )

include( "LevelSystem/cl_levelsystem.lua" )

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