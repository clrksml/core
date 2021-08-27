local VM = CORE.VM

local Maps, Votes = file.Find("maps/*.bsp", "GAME"), {}

hook.Add("PostGamemodeLoaded", "VM_PostGamemodeLoaded", function()
	local map = file.Read("last_map.txt", "DATA")
	
	for k, v in pairs(Maps) do
		v = string.Replace(v, ".bsp", "")
		
		Maps[k] = v
		
		if v == map then
			Maps[k] = nil
		end
	end
end)

hook.Add("ShutDown", "VM_ShutDown", function()
	file.Write("last_map.txt", game.GetMap():lower())
end)

hook.Add("PlayerInitialSpawn", "VM_PlayerInitialSpawn", function(ply)
	net.Start("vm_sendmaps")
		net.WriteTable(Maps)
	net.Send(ply)
end)

net.Receive("vm_update", function(len, ply)
	if !ply then return end
	
	local map = tonumber(net.ReadFloat())
	
	if !Votes[map][ply] then
		Votes[map][ply] = 1
		
		net.Start("vm_update")
			net.WriteTable(Votes)
		net.Broadcast()
	end
end)
