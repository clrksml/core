local AC = CORE.AC
local ADMIN = CORE.ADMIN

if GetGlobalString("ac_netaddress"):len() < 8 then
	SetGlobalString("ac_netaddress", string.Salt(math.random(8,32)))
end

util.AddNetworkString(GetGlobalString("ac_netaddress"))

local reason = [[ 
Banned for cheating.
You can appeal this decision by visiting our website]]

AC.Ignore = { "lua_cookiespew", "replay_togglereplaytips", "ttt_cl_traitorpopup", "ttt_cl_traitorpopup_close", "ttt_toggle_disguise", "gm_showhelp", "gm_showteam", "gm_showspare1", "gm_showspare2" }

if !AC.Binds then
	AC.Binds = util.JSONToTable(file.Read("binds.txt", "DATA") or "")
end

if !AC.Hooks then
	AC.Hooks = util.JSONToTable(file.Read("hooks.txt", "DATA") or "")
end

net.Receive(GetGlobalString("ac_netaddress"), function(len, ply)
	local key, val = util.Base64Decode(net.ReadString()) or "", util.Base64Decode(net.ReadString()) or ""
	
	if key:len() == 0 and  val:len() == 0 then
		if ply:GetLevel() < 1 then
			ply:Kick("Oops")
			return
		end
	end
	
	net.Start(GetGlobalString("ac_netaddress"))
		net.WriteFloat(math.random(0,2))
	net.Send(ply)
	
	if string.find(key, "cl_trigger_first_notification") or string.find(val, "cl_trigger_first_notification") then return end
	
	print( ply, key, val )
	
	for k, v in pairs(AC.Ignore) do
		if key == v then
			return
		end
		
		if key:find(v) then
			return
		end
	end
	
	if key == "bind" then
		if val:find("say") then return end
		
		if !table.HasValue(AC.Binds, val) then
			file.Write("binds.txt", util.TableToJSON(AC.Binds, true))
			table.insert(AC.Binds, val)
		end
		
		return
	end
	
	if key == "hook" then
		if !table.HasValue(AC.Hooks, val) then
			file.Write("hooks.txt", util.TableToJSON(AC.Hooks, true))
			table.insert(AC.Hooks, val)
		end
		
		return
	end
	
	if key == "files" then
		local str2, str2= string.Split(val, ";")[1], string.Split(val, ";")[2]
		--print(str2, str)
	end
	
	if key == "dfiles" then
		local sid, file, hash, crc, str = tostring(ply:SteamID64()), string.Split(val, ";")[1], string.Split(val, ";")[2], string.Split(val, ";")[3], string.Split(val, ";")[4]
		
		file = string.Replace(file, ".lua", "")
		file = string.Replace(file, "/", "_")
		
		_G.file.CreateDir(sid)
		
		_G.file.Write(sid.. "/" .. file .. ".txt", file .. "\tbad: " .. hash .. " != good: " .. crc .. "\n\n" .. str)
		
		return
	end
	
	if key:find(".") then
		local lib, func = string.Explode(".", key)[1], string.Explode(".", key)[2]
		print(ply, lib, func)
		
		return
	end
	
	if key:lower():find("bind") then
		local str = string.SplitAt(key, 5)
		
		if str == "bind " then
			str = string.Replace(key, 'bind "', '')
			local tbl = string.Explode(" ", str)
			str = str[1]
			str = string.Replace(str, '"', '')
			
			CORE.ADMIN:NotifyStaff(Color(255, 20, 20), "[AntiCheat][Unconfirmed] ", Color(255, 20, 20), " " .. ply:Nick() .. " " .. key .. " " .. val)
			
			return
		end
	end
	
	AC:DoBan( ply, key, val )
end)

function AC:DoBan( ply, key, val )
	if ply:GetLevel() > 1 then return end // mods, admins, and managers are safe.
	
	CORE.ADMIN:NotifyStaff(Color(255, 20, 20), "[AntiCheat][Confirmed] ", Color(255, 20, 20), " " .. ply:Nick() .. " " .. key .. " " .. val)
	
	file.Append("core/anticheat/cheaters.txt", ply:SteamID64() .. " - " ..  key .. " : " .. val .."\n")
	
	mysql:DoQuery("INSERT INTO `bans` (`sid`, `name`, `reason`, `length`, `unban`, `admin`, `aid`) VALUES('" .. ply:SteamID64() .. "','" .. mysql:Escape(ply:Name()) .. "', '" .. mysql:Escape("Cheating") .. "', '" .. 0 .. "', '" .. os.time() .. "', '" .. mysql:Escape("Anti Cheat") .. "', '" .. mysql:Escape("76561198040190608") .. "')")
	
	ply:SendLua([[RunConsoleCommand('gamemenucommand', 'quit')]])
	
	if ply:IsValid() then
		ply:Kick("Cheating")
	end
end

hook.Add("StartCommand", "AC_StartCommand", function(ply, cmd)
	if !ply:IsPlayer() and !ply:Alive() then return end
	
	local ang = cmd:GetViewAngles()
	
	if ang.p > 90 or ang.p < -90 then
		cmd:SetViewAngles(Angle(ply.LastViewAngle))
		
		if ply.LastStartCommand then
			ply.LastStartCommand = true
		else
			AC:DoBan(ply, "aimbot", "viewangles")
		end
	end
	
	ply.LastViewAngle = ang
end)

hook.Add("Tick", "AC_Tick", function()
	for _, ply in pairs(player.GetAll()) do
		if ply.LastName.name and ply:Nick() != ply.LastName.name then
			if ply.LastName.time > CurTime() then
				if ply.LastName.count > 1 then
					AC:DoBan(ply, "name", "spam")
				else
					ply.LastName.count = ply.LastName.count + 1
				end
			else
				ply.LastName.count = 0
			end
		end
	end
end)

hook.Add("OnEntityCreated", "AC_OnEntityCreated", function(ply)
	if ply:IsValid() and ply:IsPlayer() then
		
		ply.Auth = CurTime()
		ply.LastName = { name = ply:Nick(), time = CurTime() + 2, count = 0 }
	end
end)
