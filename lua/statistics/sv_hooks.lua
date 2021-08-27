local STAT = CORE.STAT

/*hook.Add("InitPostEntity", "STAT_InitPostEntity", function()
	for k, v in pairs(STAT.stats) do
		STAT:Add(v)
	end
end)*/

hook.Add("PlayerInitialSpawn", "STAT_PlayerInitialSpawn", function(ply)
	--ply:LoadStats()
end)

hook.Add("PlayerDisconnected", "STAT_PlayerDisconnected", function(ply)
	--ply:SaveStats()
end)

hook.Add("ShutDown", "STAT_ShutDown", function()
	for _, ply in pairs(player.GetAll()) do
		--ply:SaveStats()
	end
end)

local LastThink = CurTime()
hook.Add("Think", "STAT_Think", function()
	if LastThink then
		for _, ply in pairs(player.GetAll()) do
			--ply:SaveStats()
		end

		LastThink = CurTime() + 60
	end
end)
