-- Console Command
concommand.Add("thirdpersonview", function(ply, cmd, args)
	ThirdPersonSystemClient.EnableThirdPerson(!ThirdPersonSystemClient.IsInThirdPerson);
end)

-- Ulx Command.