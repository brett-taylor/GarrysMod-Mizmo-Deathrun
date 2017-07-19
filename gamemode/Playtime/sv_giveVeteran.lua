PlaytimeServer = PlaytimeServer or {};

function PlaytimeServer.CheckIfVeteran(ply, setting, newValue)
    // 30 hours. 60 minutes in an hour. 60*30
    if (setting == PlayerSettings.Enums.PLAY_TIME.Name) then
        if (tonumber(newValue) == 1800) then
            Notify.SendNotificationAll(ply:Nick().." became a Veteran!", 10);
        end

        if (tonumber(newValue) >= 1800) then
            if (ply:IsModerator() == false && ply:IsDonator() == false && ply:GetSetting(PlayerSettings.Enums.TAG_NAME.Name) == "NIL") then
                ply:SetSetting(PlayerSettings.Enums.TAG_NAME.Name, "Veteran");
                ply:SetSetting(PlayerSettings.Enums.TAG_COLOUR.Name, "66-217-244");
            end
        end
    end
end
hook.Add("MizmoSettingChanged", "MizmosCheckIfPlayerShouldBecomeVeteran", PlaytimeServer.CheckIfVeteran);