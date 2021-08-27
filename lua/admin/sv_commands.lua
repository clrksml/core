local ADMIN =  CORE.ADMIN

local string = string
local table = table
local player = player
local os = os
local team = team
local chat = chat
local timer = timer
local game = game
local file = file
local gmod = gmod
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local SortedPairs = SortedPairs

function ADMIN.Kick(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			local reason = table.concat(args, " ", 2) or ""
			
			if reason == "" then
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has kicked ", v:GetUserColor(), v:Nick(), color_white, " .")
				
				v:Kick("Kicked without a reason.")
			else
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has kicked ", v:GetUserColor(), v:Nick(), color_white, " for ", Color(20, 200, 200), reason .. ".")
				
				v:Kick("Kicked for " .. reason) 
			end
		end
	end
end
chat.Add("kick", ADMIN.Kick, "[player] [reason]", "Kicks a player", 2, 1)

function ADMIN.Ban(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		local length = (tonumber(args[2]) * 60) or 0
		local reason = table.concat(args, " ", 3) or "Banned without a reason"
		
		for k, v in pairs(target) do
			mysql:DoQuery("INSERT INTO `bans` (`sid`, `name`, `reason`, `length`, `unban`, `admin`, `aid`) VALUES('" .. v:SteamID64() .. "', '" .. mysql:Escape(v:Nick()) .. "', '" .. mysql:Escape(reason) .. "', '" .. length .. "', '" .. os.time() + length .. "', '" .. mysql:Escape(ply:Name()) .. "', '" .. mysql:Escape(ply:SteamID64()) .. "')")
			
			if length != 0 then
				length = length * 60
				length = ". Banned until " .. os.date("%I:%M%p - %m/%d/%Y", (os.time() + length))
			else
				length = ". Banned forever"
			end
			
			if length == ". Banned forever" then
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has permanently banned ", v:GetUserColor(), v:Nick(), color_white, " for ", Color(20, 200, 20), reason, color_white, ".")
			else
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has banned ", v:GetUserColor(), v:Nick(), color_white, " for ", Color(20, 200, 20), reason, Color(22, 223, 22), tostring(length), color_white, ".")
			end
			v:Kick("Banned for " .. reason .. ".\n" .. length)
		end
	end
end
chat.Add("ban", ADMIN.Ban, "[player] [time] [reason]", "Bans a player", 2, 3)

function ADMIN.BanID(ply, cmd, args)
	local target = { util.SteamIDTo64(args[1]) }
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			local length = (tonumber(args[2]) * 60) or 0
			local reason = table.concat(args, " ", 3) or "Banned without a reason"
			local name = ADMIN.Players[v]
			
			mysql:DoQuery("SELECT `sid` FROM `bans` WHERE `sid`='" .. v .. "'", function( data )
				if data and data[1] then
					mysql:DoQuery("UPDATE `bans` SET `reason`='" .. mysql:Escape(reason) .. "', `length`='" .. length .. "', `unban`='" .. os.time() + length .. "', `admin`='" .. mysql:Escape(ply:Name()) .. "', `aid`='" .. mysql:Escape(ply:SteamID64()) .. "' WHERE `sid`='" .. v .. "'")
					
					if length != 0 then
						length = ". Banned until " .. os.date("%I:%M%p - %m/%d/%Y", (os.time() + length))
					else
						length = ". Banned forever"
					end
					
					if length == ". Banned forever" then
						ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has permanently rebanned ", Color(20, 200, 20), name, color_white, " for ", Color(20, 200, 20), reason, color_white, ".")
					else
						ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has rebanned ", Color(20, 200, 20), name, color_white, " for ", Color(20, 200, 20), reason, Color(22, 223, 22), tostring(length), color_white, ".")
					end
					
					v:Kick("Banned for " .. reason .. ".\n" .. length)
				else
					mysql:DoQuery("INSERT INTO `bans` (`sid`, `name`, `reason`, `length`, `unban`, `admin`, `aid`) VALUES('" .. v .. "', '" .. mysql:Escape(name) .. "', '" .. mysql:Escape(reason) .. "', '" .. length .. "', '" .. os.time() + length .. "', '" .. mysql:Escape(ply:Nick()) .. "', '" .. ply:SteamID64() .. "')")
					
					if length != 0 then
						length = ". Banned until " .. os.date("%I:%M%p - %m/%d/%Y", (os.time() + length))
					else
						length = ". Banned forever"
					end
					
					if length == ". Banned forever" then
						ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has permanently banned ", Color(20, 200, 20), name, color_white, " for ", Color(20, 200, 20), reason, color_white, ".")
					else
						ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has banned ", Color(20, 200, 20), name, color_white, " for ", Color(20, 200, 20), reason, Color(22, 223, 22), tostring(length), color_white, ".")
					end
				end
			end)
		end
	end
end
chat.Add("banid", ADMIN.BanID, "[steamid] [time] [reason]", "Bans a player", 2, 3)

function ADMIN.Unban(ply, cmd, args)
	local target = args[1]
	local reason = table.concat(args, " ", 2) or "no reason given"
	
	if target:find("STEAM_") then
		target = util.SteamIDTo64(target)
	end
	
	mysql:DoQuery("SELECT `sid` FROM `bans` WHERE `sid`='" .. target .. "'", function( data )
		if data and data[1] then
			data = data[1]
			
			mysql:DoQuery("DELETE FROM `bans` WHERE `sid`='" .. target .. "'")
			
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has unbanned ", Color(20, 200, 20), data['name'], color_white, " for ", Color(20, 200, 20), reason, color_white, color_white, ".")
		end
	end)
	
	if ADMIN.Bans[target] then
		ADMIN.Bans[target] = nil
	end
end
chat.Add("unban", ADMIN.Unban, "[steamid] [reason]", "Unbans a player", 2, 2)

function ADMIN.Slay(ply, cmd, args)
	local target, rounds = ADMIN:FindPlayer(args[1], ply), args[2] or false
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if rounds and tonumber(rounds) >= 1 then
				rounds = rounds + tonumber(v:GetPData("slays", 0))
				v:SetPData("slays", tonumber(rounds))
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has queued ", v:GetUserColor(), v:Nick(), color_white, " to be slayed the next " .. rounds .. " round(s).")
			elseif rounds and tonumber(rounds) <= 0 then
				v:SetPData("slays", 0)
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has unqueued ", v:GetUserColor(), v:Nick(), color_white, " to be slayed.")
			else
				if GAMEMODE.round_state != ROUND_ACTIVE then
					ADMIN:Notify(ply, color_white, "Error - Couldn't slay player after the round ended.")
					return
				end
				
				v:Kill()
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " slayed ", v:GetUserColor(), v:Nick(), color_white, ".")
			end
		end
	end
end
chat.Add("slay", ADMIN.Slay, "[player] [rounds]", "Kills the player", 2, 1)

function ADMIN.Slap(ply, cmd, args)
	local target, dmg = ADMIN:FindPlayer(args[1], ply), tonumber(args[2]) or 0
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if GAMEMODE.round_state != ROUND_ACTIVE then
				ADMIN:Notify(ply, color_white, "Error - Couldn't slap player after the round ended.")
				return
			end
			
			if v:Alive() then
				v:SetHealth(math.Clamp(0, v:Health() - dmg, v:Health()))
				
				if v:Health() <= 0 then
					v:KillSilent()
				end
				
				v:SetVelocity(v:GetForward() * 400 + Vector(0, 0, 600))
				v:ViewPunch(Angle(-45,0,0))
				
				sound.Play("physics/body/body_medium_impact_hard" .. math.random(1, 7) .. ".wav", v:GetPos(), 150)
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has slapped ", v:GetUserColor(), v:Nick(), color_white, " for " .. dmg .. " hp.")
			end
		end
	end
end
chat.Add("slap", ADMIN.Slap, "[player] [damage]", "Slaps the player for x damage", 2, 1)

function ADMIN.AddUser(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local rank = tostring(args[2]) or "guest"
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		if !ADMIN:GetGroup(rank) then
			ADMIN:Notify(ply, color_white, "Error - Couldn't find specified user group.")
			
			return
		end
		
		for k, v in pairs(target) do
			ADMIN:NotifyAll(color_white, v:Nick() .. " was added to " .. rank)
			
			v:SetUserGroup(rank)
			ADMIN:AddUser(v, rank)
			
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has added ", v:GetUserColor(), v:Nick(), color_white, " to " .. rank .. ".")
			
			mysql:DoQuery("INSERT INTO `users` (`sid`, `rank`) VALUES('" .. v:SteamID64() .. "', '" .. mysql:Escape(rank) .. "')")
		end
	end
end
chat.Add("adduser", ADMIN.AddUser, "[player] [rank]", "Add a user to a group", 4, 2)
chat.Add("add", ADMIN.AddUser, "[player] [rank]", "Add a user to a group", 4, 2)

function ADMIN.RemoveUser(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local rank = tostring(args[2]) or "guest"
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		if !ADMIN:GetGroup(rank) then
			ADMIN:Notify(ply, color_white, "Error - Couldn't find specified user group.")
			
			return
		end
		
		for k, v in pairs(target) do
			v:SetUserGroup("guest")
			ADMIN:RemoveUser(v, rank)
			
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has removed ", v:GetUserColor(), v:Nick(), color_white, " from " .. rank .. ".")
			
			mysql:DoQuery("DELETE FROM `users` WHERE `sid`='" .. v:SteamID64() .. "'")
		end
	end
end
chat.Add("removeuser", ADMIN.RemoveUser, "[player]", "Remove a users rank", 4, 1)
chat.Add("remove", ADMIN.RemoveUser, "[player]", "Remove a users rank", 4, 1)

function ADMIN.Noclip(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v:Alive() then
				if v:GetMoveType() != MOVETYPE_NOCLIP then
					v:SetMoveType(MOVETYPE_NOCLIP)
					
					ADMIN:NotifyAll(v:GetUserColor(), v:Nick(), color_white, " toggled on noclip.")
				else
					v:SetMoveType(MOVETYPE_WALK)
					
					ADMIN:NotifyAll(v:GetUserColor(), v:Nick(), color_white, " toggled off noclip.")
				end
			end
		end
	end
end
chat.Add("noclip", ADMIN.Noclip, "[player]", "Players movement collision will be toggled", 3, 1)

function ADMIN.Bring(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v == ply then ADMIN:Notify(ply, color_white, "Error - You cannot bring yourself.") return end
			
			if v:Alive() or v:Team() != TEAM_SPEC then
				local newpos = ADMIN:SendPlayer(v, ply, v:GetMoveType() == MOVETYPE_NOCLIP)
				
				if not newpos then
					ADMIN:Notify(ply, color_white, "Error - Cannot find a place to put them.")
					
					return
				end
				
				local newang = (ply:GetPos() - newpos):Angle()
				
				v:SetPos(newpos)
				v:SetEyeAngles(newang)
				v:SetLocalVelocity(Vector(0, 0, 0))
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has brought ", v:GetUserColor(), v:Nick(), color_white, " to themself.")
			else
				ADMIN:Notify(ply, color_white, "Error - This player is dead.")
			end
		end
	end
end
chat.Add("bring", ADMIN.Bring, "[player]", "Bring a player", 2, 1)

function ADMIN.Goto(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v == ply then ADMIN:Notify(ply, color_white, "Error - You cannot goto yourself.") return end
			
			local newpos = ADMIN:SendPlayer(ply, v, ply:GetMoveType() == MOVETYPE_NOCLIP)
			if not newpos then
				ADMIN:Notify(ply, color_white, "Error - Cannot find a place to put you.")
				
				return
			end
			
			local newang = (v:GetPos() - newpos):Angle()
			
			ply:SetPos(newpos)
			ply:SetEyeAngles(newang)
			ply:SetLocalVelocity(Vector(0, 0, 0))
			
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " went to ", v:GetUserColor(), v:Nick() .. ".")
		end
	end
end
chat.Add("goto", ADMIN.Goto, "[player]", "Sends you to the player", 2, 1)

function ADMIN.Freeze(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v:Alive() then
				if !v:IsLocked() then
					v:Lock()
					
					ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " frooze ", v:GetUserColor(), v:Nick() .. ".")
				else
					v:UnLock()
					
					ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " unfrooze ", v:GetUserColor(), v:Nick() .. ".")
				end
			end
		end
	end
end
chat.Add("freeze", ADMIN.Freeze, "[player]", "Freezes a player", 3, 1)
chat.Add("lock", ADMIN.Freeze, "[player]", "Freezes a player", 3, 1)

function ADMIN.Mute(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v:IsMuted() then
				v:SetMuted(false)
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has unmuted ", v:GetUserColor(), v:Nick(), color_white, ".")
			else
				v:SetMuted(true)
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has muted ", v:GetUserColor(), v:Nick(), color_white, ".")
			end
		end
	end
end
chat.Add("mute", ADMIN.Mute, "[player] [toggles]", "Prevents a user typing", 2, 1)

function ADMIN.Gag(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v:IsGagged() then
				v:SetGagged(false)
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has ungagged ", v:GetUserColor(), v:Nick(), color_white, ".")
			else
				v:SetGagged(true)
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has gagged ", v:GetUserColor(), v:Nick(), color_white, ".")
			end
		end
	end
end
chat.Add("gag", ADMIN.Gag, "[player] [toggles]", "Mute a player's microphone", 2, 1)

function ADMIN.Announce(ply, cmd, args)
	local text = table.concat(args, " ", 1)
	
	ADMIN:NotifyAll(ply:GetUserColor(), "[" .. ply:GetUserGroup():upper() .. "] ", color_white, text)
end
chat.Add("!", ADMIN.Announce, "[args]", "Display a chat message to all players anonymously", 2, 1)

function ADMIN.Say(ply, cmd, args)
	local text = table.concat(args, " ", 1)
	
	ADMIN:NotifyAll(ply:GetUserColor(), "[" .. ply:GetUserGroup():upper() .. "] [" .. ply:Nick() .. "] ", color_white, text)
end
chat.Add("@", ADMIN.Say, "[args]", "Display a chat message to all players unanonymously", 2, 1)

function ADMIN.StaffSay(ply, cmd, args)
	local text = table.concat(args, " ", 1)
	
	ADMIN:NotifyStaff(color_white, "[ADMIN ONLY] ", ply:GetUserColor(), ply:Nick(), color_white, ": " .. text)
end
chat.Add("#", ADMIN.StaffSay, "[args]", "Display a chat message to all staff members", 2, 1)

function ADMIN.PersonalMessage(ply, cmd, args)
	local target, text = ADMIN:FindPlayer(args[1], ply), table.concat(args, " ", 2)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		ADMIN:Notify(ply, Color(20, 200, 20), " [PM] ", team.GetColor(ply:Team()), ply:Nick(), color_white, ": " .. text)
		
		for k, v in pairs(target) do
			ADMIN:Notify(v, Color(20, 200, 20), " [PM] ", team.GetColor(ply:Team()), ply:Nick(), color_white, ": " .. text)
			ADMIN:Notify(v, Color(20, 200, 20), " You can reply by type !pm " .. ply:Nick())
		end
	end
end
chat.Add("pm", ADMIN.PersonalMessage, "[player] [message]", "Privately message another player", 0, 2)

function ADMIN.Disguise(ply, cmd, args)
	if ply:IsDisguised() == false then
		ply:SetDisguised(true)
		
		ADMIN:GetFaked(ply)
		
		ADMIN:Notify(ply, color_white, "You've have been successfully disguised.")
	else
		ply:SetDisguised(false)
		ADMIN:Notify(ply, color_white, "You've have been successfully undisguised.")
	end
end
chat.Add("disguise", ADMIN.Disguise, "", "Diguise your name and avatar to be a random anonymous steam user", 2, 0)

function ADMIN.QuickReload(ply, cmd, args)
	timer.Create("changelevel", 1, 3, function()
		ADMIN:NotifyAll(color_white, "Reloading the map in " .. timer.RepsLeft("changelevel") .. " seconds.")
	end)
	
	timer.Simple(4, function()
		game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
	end)
end
chat.Add("qr", ADMIN.QuickReload, "", "Quickly reload the map", 2, 0)

function ADMIN.Map(ply, cmd, args)
	local map = args[1]
	
	if !file.Find("maps/" .. map .. ".bsp", "GAME") then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified map.")
	else
		ADMIN:NotifyAll(color_white, "Changing map to " .. map .. ".")
		
		timer.Simple(4, function()
			game.ConsoleCommand("changelevel " .. map .. "\n")
		end)
	end
end
chat.Add("map", ADMIN.Map, "[map]", "Change the servers map", 2, 1)

function ADMIN.VoteMap(ply, cmd, args)
	local num = tonumber(args[1]) or 10
	
	MapVote.Start(25, false, num, "ttt")
end
chat.Add("vmap", ADMIN.VoteMap, "[num maps]", "Put a vote for a change of maps", 2)

function ADMIN.Lua(ply, cmd, args)
	MsgN(table.concat(args, " "))
	
	RunString(table.concat(args, " "))
end
chat.Add("lua", ADMIN.Lua, "[args]",  "Excute lua on the server", 4, 1)

function ADMIN.RCON(ply, cmd, args)
	MsgN((table.concat( args, " ", 1 ) or "").."\n")
	
	game.ConsoleCommand((table.concat( args, " ", 1 ) or "").."\n")
end
chat.Add("rcon", ADMIN.RCON, "[args]", "Run a convar or command on the server", 4, 1)

function ADMIN.Respawn(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if gmod.GetGamemode().Name:lower():find("trouble") then
				v:UnSpectate()
				v:SetTeam(TEAM_TERROR)
				v:SetRole(v:GetRole() or ROLE_INNOCENT)
				v:SetDefaultCredits()
				v:StripAll()
				v:Spawn()
				
				SendFullStateUpdate()
			else
				v:Spawn()
			end
			
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " respawned ", v:GetUserColor(), v:Nick(), color_white, ".")
		end
	end
end
chat.Add("respawn", ADMIN.Respawn, "[player]", "Respawn a player", 2, 1)

function ADMIN.Logs(ply, cmd, args)
	--[[local x = 0
	if args[0] then 
		x = args[0]
	end
	
	for k, v in SortedPairs(logs[x], true) do
		ADMIN:Notify(ply, color_white, v)
	end
	
	if #logs[x] >= 1 then
		ADMIN:Notify(ply, color_white, "Check your console for further logs.")
	end--]]
	for k, v in SortedPairs(GAMEMODE.DamageLog, true) do
		ADMIN:Notify(ply, color_white, v)
	end
	
	if #GAMEMODE.DamageLog >= 1 then
		ADMIN:Notify(ply, color_white, "Check your console for further logs.")
	end
end
chat.Add("logs", ADMIN.Logs, "[rounds back]", "Lists damage logs for a round", 2, 0)

function ADMIN.Karma(ply, cmd, args)
	local target, amount = ADMIN:FindPlayer(args[1], ply), tonumber(args[2])
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			v:SetBaseKarma(amount)
			v:SetLiveKarma(amount)
			
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " set ", v:GetUserColor(), v:Nick(), color_white, " karma to ", Color(20, 200, 20), amount, color_white, ".")
		end
	end
end
chat.Add("karma", ADMIN.Karma, "[player] [amount]", "Set the players karma", 2, 2)

function ADMIN.Help(ply, cmd, args)
	for k, v in SortedPairs(chat.GetTable()) do
		if v[2]:len() > 1 then
			ADMIN:Notify(ply, color_white, k .. "  -  " .. v[2] .. "  -  " .. v[3])
		else
			ADMIN:Notify(ply, color_white, k .. "  -  " .. v[3])
		end
	end
	
	ADMIN:Notify(ply, color_white, " Check your console for further commands.")
end
chat.Add("help", ADMIN.Help, "", "Lists all commands", 0, 0)

function ADMIN.Rules(ply, cmd, args)
	ply:SendLua([[ gui.OpenURL("http://127.0.0.1/archive/index.php?thread-3.html") ]])
	
	ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " is browsing the rules.")
end
chat.Add("rules", ADMIN.Rules, "", "List of rules", 0, 0)
chat.Add("motd", ADMIN.Rules, "", "List of rules", 0, 0)

function ADMIN.Cap(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local last = tonumber(args[2]) or 0
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if last == 0 then
				net.Start("admin_sendcap")
					net.WriteString(v:SteamID64())
				net.Send(v)
				
				if !ADMIN.Captures then
					ADMIN.Captures = {}
				end
				
				if !ADMIN.Captures[v] then
					ADMIN.Captures[v] = {}
				end
				
				table.insert(ADMIN.Captures[v], ply)
				
				timer.Simple(60, function()
					if ADMIN.Captures[v] then
						if ply:GetLevel() > 2 then return end
						ply:Kick("Kicked for avoiding capture") 
					end
				end)
				
				ADMIN:Notify(ply, color_white, " Getting screenshot of " .. v:Nick() .. "'s screen.")
			else
				net.Start("admin_docap")
					net.WriteString(v:SteamID64())
				net.Send(ply)
			end
		end
	end
end
chat.Add("cap", ADMIN.Cap, "[player] [last]", "Takes a screenshot of the players screen", 2, 1)
chat.Add("capture", ADMIN.Cap, "[player] [last]", "Takes a screenshot of the players screen", 2, 1)

function ADMIN.Spec(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			v:SetTeam(TEAM_SPECTATOR)
			v:StripWeapons()
			v:ConCommand("ttt_spectator_mode 1\n")
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " forced ", v:GetUserColor(), v:Nick(), color_white, " to spectator.")
		end
	end
end
chat.Add("spec", ADMIN.Spec, "[player]", "Force a player to spectator", 2, 1)

function ADMIN.Health(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local health = tonumber(args[2])
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v:Alive() then
				v:SetHealth(health)
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " set ", v:GetUserColor(), v:Nick(), color_white, " health to " .. v:Health() ..".")
			end
		end
	end
end
chat.Add("health", ADMIN.Health, "[player]", "Give or take a players health.", 2, 1)

function ADMIN.FBan(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local length = (tonumber(args[2]) * 60) or 0
	local reason = table.concat(args, " ", 3) or "Banned without a reason"
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else 
		if length != 0 then
			length = length * 60
			length = "Banned until " .. os.date("%I:%M%p - %m/%d/%Y", (os.time() + length))
		else
			length = "Banned forever"
		end
		
		for k, v in pairs(target) do
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " banned ", Color(20, 200, 20), v:Name(), color_white, " for '" .. reason .. "'. ", Color(22, 223, 22), length, color_white,  ".")
		end
	end
end
chat.Add("fban", ADMIN.FBan, "[player] [length] [reason]", "Fake ban a player", 2, 1)
chat.Add("fakeban", ADMIN.FBan, "[player] [length] [reason]", "Fake ban a player", 2, 1)

function ADMIN.FSay(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local text = table.concat(args, " ", 2)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else 
		for k, v in pairs(target) do
			v:ConCommand("say " .. text .. "\n")
		end
	end
end
chat.Add("fsay", ADMIN.FSay, "[player] [words]", "Fake player message", 2, 1)
chat.Add("fakesay", ADMIN.FSay, "[player] [words]", "Fake player message", 2, 1)

function ADMIN.Report(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local reason = table.concat(args, " ", 2) or ""
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if reason == "" then
				ADMIN:NotifyStaff(v:GetUserColor(), v:Nick(), color_white, "was reported.")
			else
				ADMIN:NotifyStaff(v:GetUserColor(), v:Nick(), color_white, " was reported by ", v:GetUserColor(), ply:Nick(), color_white, " for: '", Color( 255, 255, 0 ), reason .. "'.")
			end
		end
	end
end
chat.Add("report", ADMIN.Report, "[player] [reason]", "Report a player to an admin.", 0, 0)

function ADMIN.GetFriends(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else 
		for k, v in pairs(target) do
			local friends = {}
			
			local function success( str, len, head, http )
				tbl = util.JSONToTable(str)
				
				tbl = tbl['friendslist']['friends']
				
				for _, pl in pairs(tbl) do
					table.insert(friends, pl["steamid"])
				end
				
				for _, pl in pairs(player.GetAll()) do
					if table.HasValue(friends, tostring(pl:SteamID64())) then
						ADMIN:Notify(ply, color_white, " " .. pl:Nick() .. " is friends with " .. v:Nick() .. ".")
					end
				end
				
				if !friends or #friends == 0 then
					ADMIN:Notify(ply, color_white, " " .. v:Nick() .. " has no friends on the server.")
				end
			end
			
			local function failed()
				ADMIN:Notify(ply, color_white, " " ..v:Nick() .. " failed to get his/her friends list.")
			end
			
			http.Fetch("http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=A4211E585CE7E39E8630678E5FC69257&steamid=" .. v:SteamID64() .. "&relationship=friend", success, failed)
		end
	end
end
chat.Add("friends", ADMIN.GetFriends, "[player]", "Check to see if the player has any friends in the server", 2, 1)

function ADMIN.Run(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else 
		table.remove(args, 1)
		for k, v in pairs(target) do
			net.Start("admin_run")
				net.WriteString(table.concat(args," "))
			net.Send(v)
		end
	end
end
chat.Add("run", ADMIN.Run, "[player]", "", 4, 1)

function ADMIN.CExec(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	args = table.concat(args, " ", 2)
	print(args)
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else 
		for k, v in pairs(target) do
			v:ConCommand(args)
		end
	end
end
chat.Add("cexec", ADMIN.CExec, "[player] [command]", "Run a command on a player", 2, 1)

function ADMIN.SetName(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local name = table.concat(args," ", 2)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else 
		for k, v in pairs(target) do
			if v:IsDisguised() == false then
				v:SetDisguised(true)
				
				v:SetFakeName(name)
				v:SetFakeAvatar(v:SteamID64())
				
				ADMIN:Notify(ply, color_white, "You've have been successfully renamed " .. v:Name() .. ".")
			else
				v:SetDisguised(false)
				
				ADMIN:Notify(ply, color_white, "You've have been successfully un-renamed " .. v:Name() .. ".")
			end
		end
	end
end
chat.Add("name", ADMIN.SetName, "", "Set a players name", 2, 0)

/*function ADMIN.Votekick(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local reason = table.concat(args," ", 2)
	
	if !ADMIN.Votes then
		ADMIN.Votes = {}
	end
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else 
		for k, v in pairs(target) do
			if !ADMIN.Votes[v:SteamID()] then
				ADMIN.Votes[v:SteamID()] = 1
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " started a vote to kick ", v:GetUserColor(), v:Nick(), color_white, " for '", Color(255, 255, 0), reason .. "'.")
			else
				ADMIN.Votes[v:SteamID()] = ADMIN.Votes[v:SteamID()] + 1
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " voted to kick ", v:GetUserColor(), v:Nick(), color_white, ADMIN.Votekicks[v:SteamID()] .. "/" .. math.Round(#player.GetAll() / 0.5) .. ".")
				
				if ADMIN.Votes[v:SteamID()] >= math.Round(#player.GetAll() / 0.5) then
					v:Kick("You were voted off the server.")
					ADMIN:NotifyAll(v:GetUserColor(), v:Nick(), color_white, " votekicked.")
				end
			end
		end
	end
end
chat.Add("votekick", ADMIN.Votekick, "[player] [reason]", "Suggest a vote to kick someone.", 0, 2)*/

function ADMIN.Spray(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			if v:GetPData("sprays", "0") == "0" then
				v:SetPData("sprays", "1")
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has spray banned ", v:GetUserColor(), v:Nick(), color_white, ".")
			else
				v:SetPData("sprays", "0")
				
				ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " has spray unbanned ", v:GetUserColor(), v:Nick(), color_white, ".")
			end
		end
	end
end
chat.Add("spray", ADMIN.Spray, "[player]", "Spray (un)banned a player", 2, 1)

function ADMIN.Give(ply, cmd, args)
	local target = ADMIN:FindPlayer(args[1], ply)
	local wpn = table.concat(args," ", 2)
	
	if #target < 1 then
		ADMIN:Notify(ply, color_white, "Error - Couldn't find specified player.")
	else
		for k, v in pairs(target) do
			v:Give(wpn)
			
			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " gave ", v:GetUserColor(), v:Nick(), color_white, " " .. wpn, color_white, ".")
		end
	end
end
chat.Add("give", ADMIN.Give, "[player]", "Give a player a weapon", 2, 1)

function ADMIN.Menu(ply, cmd, args)
	ply:ConCommand("cm")
end
chat.Add("menu", ADMIN.Menu, "", "Toggle menu", 2, 0)

concommand.Add("core", function(ply, cmd, args)
	if #args <= 0 then return end

	cmd = args[1]

	table.remove(args, 1)
	
	if chat.GetTable()[cmd] then
		if ply:GetLevel() < chat.GetTable()[cmd][4] then
			CORE.ADMIN:Notify(ply, Color(155, 89, 182), "Error - You have the wrong permissions.")
			ply:SendLua([[ surface.PlaySound("ui/buttonclickrelease.wav") ]])
			
			return ""
		end
		
		if chat.GetTable()[cmd][5] and chat.GetTable()[cmd][5] != 0 and #args < chat.GetTable()[cmd][5] then
			CORE.ADMIN:Notify(ply, Color(155, 89, 182), "Error - Not all arguments were specified.")
			ply:SendLua([[ surface.PlaySound("ui/buttonclickrelease.wav") ]])
			
			return ""
		end
		
		ply:SendLua([[ surface.PlaySound("ui/buttonclick.wav") ]])
		chat.Run(ply, cmd, args)
	end
end)