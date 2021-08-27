local STORE = CORE.STORE

concommand.Add("store", function(ply, cmd, args)
	if !IsValid(ply) then return end
	if !args[1] then return end
	
	args[2] = tonumber(args[2])
	args[3] = tonumber(args[3])
	
	/*if args[1] == "open" then
		if ply.OpenedStore == 0 then
			ply.OpenedStore = 1
			
			net.Start("store_new")
				net.WriteFloat(1)
			net.Send(ply)
		end
	end*/
	
	if args[1] == "buy" then
		ply:BuyItem(args[2], args[3])
	end
	
	if args[1]  == "equip" then
		ply:EquipItem(args[2], args[3], true)
	end
	
	if args[1]  == "unequip" then
		ply:UnEquipItem(args[2], args[3])
	end
end)
