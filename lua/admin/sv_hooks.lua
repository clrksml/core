local ADMIN = CORE.ADMIN
local CHATBOX = CORE.CHATBOX

local hook = hook
local string = string
local table = table
local util = util
local os = os
local net = net
local team = team
local pairs = pairs
local tonumber = tonumber

local time = 0

if !ADMIN.Players then
	ADMIN.Players = {}
end

hook.Add("CheckPassword", "ADMIN_CheckPassword", function(steamid64, _, __, ___, ____)
	mysql:DoQuery("SELECT `reason`, `length`, `unban` FROM `bans` WHERE `sid`='" .. steamid64 .. "'", function( data )
		if data and data[1] then
			data = data[1]

			local reason, length, unban = data['reason'], tonumber(data['length']), tonumber(data['unban'])

			if length > 0 then
				if unban <= os.time() then
					mysql:DoQuery("DELETE FROM `bans` WHERE `sid`='" .. steamid64 .. "'")
				else
					return false, [[Banned for ]] .. reason .. [[.
Banned until ]] ..  os.date("%I:%M%p - %m/%d/%Y", unban) .. [[]]
				end
			else
				return false, [[Banned for ]] .. reason .. [[.
Banned forever]]
			end
		end
	end)
end)

hook.Add("PlayerAuthed", "ADMIN_PlayerAuthed", function( ply )
	if !IsValid(ply) then return end

	ply:SetUserGroup("guest")
	ply:SetFakeName(ply:Name())
	ply:SetFakeAvatar(ply:SteamID64())

	mysql:DoQuery("SELECT `reason`, `length`, `unban` FROM `bans` WHERE `sid`='" .. ply:SteamID64() .. "'", function( data )
		if data and data[1] then
			data = data[1]

			local reason, length, unban = data['reason'], tonumber(data['length']), tonumber(data['unban'])

			if length > 0 then
				if unban <= os.time() then
					mysql:DoQuery("DELETE FROM `bans` WHERE `sid`='" .. ply:SteamID64() .. "'")
				else
					ply:Kick([[Banned for ]] .. reason .. [[.
Banned until ]] ..  os.date("%I:%M%p - %m/%d/%Y", unban) .. [[]])
				end
			else
				ply:Kick([[Banned for ]] .. reason .. [[.
Banned forever]])
			end
		end
	end)

	if ply:Nick():len() <= 3 then
		ply:Kick("Change your name to something readable and more than 3 characters.")
	end

	mysql:DoQuery("SELECT `rank` FROM `users` WHERE `sid`='" .. ply:SteamID64() .. "'", function( data )
		if data and data[1] then
			data = data[1]

			ply:SetUserGroup(data['rank'])
		end
	end)

	ADMIN.Players[ply:SteamID64()] = ply:Nick()

	local tbl = {}
	for k, v in pairs(chat.GetTable()) do
		tbl[k] = { v[2], v[3], v[4], v[5] }
	end

	net.Start("admin_sendcmds")
		net.WriteTable(tbl)
	net.Send(ply)

	local IPAddress = string.Explode(":", ply:IPAddress())
	IPAddress = IPAddress[1]

	http.Fetch("http://ipinfo.io/" .. IPAddress .. "/json", function( str )
		local tbl, str = util.JSONToTable(str), ""

		if tbl['region'] != nil and tbl['region'] != "" then
			str = str .. tbl['region'] .. ", "
		end

		if tbl['country'] != nil and tbl['country'] != "" then
			str = str .. tbl['country']
		end

		if str == "" then
			ADMIN:NotifyAll(Color(20, 200, 20), ply:Nick(), color_white, " has connected from ", Color(200, 20, 20), "Earth", color_white, ".")
		else
			ADMIN:NotifyAll(Color(20, 200, 20), ply:Nick(), color_white, " has connected from ", Color(20, 200, 20), str, color_white, ".")
		end
		print(ply:GetNWString("country", str), str)
		ply:SetNWString("country", str)

	end,
	function()
		ADMIN:NotifyAll(Color(20, 200, 20), ply:Nick(), color_white, " has connected.")
	end)
end)

hook.Add("TTTBeginRound", "ADMIN_TTTBeginRound", function()
	for _, ply in pairs(player.GetAll()) do
		local slays = tonumber(ply:GetPData("slays", 0))

		if slays > 0 then
			ply:Kill()

			ply:SetPData("slays", slays - 1)

			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " was slayed for a previous rule violation.")

			for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
				if IsValid(ent) and ent.player_ragdoll then
					identifycorpse( ent )
				end
			end
		end
	end
end)

hook.Add("RoundStart", "ADMIN_RoundStart", function()
	for _, ply in pairs(player.GetAll()) do
		local slays = tonumber(ply:GetPData("slays", 0))

		if slays > 0 then
			ply:Kill()

			ply:SetPData("slays", slays - 1)

			ADMIN:NotifyAll(ply:GetUserColor(), ply:Nick(), color_white, " was slayed for a previous rule violation.")
		end
	end
end)

hook.Add("PlayerInitialSpawn", "ADMIN_PlayerInitialSpawn", function( ply )
	_G[ply:Nick()] = ply

	net.Start("admin_sendcap2")
		net.WriteString(ply:SteamID64())
	net.Send(ply)
end)

hook.Add("PlayerCanHearPlayersVoice", "ADMIN_PlayerCanHearPlayersVoice", function(listener, speaker)
	if speaker:IsGagged() then
		return false
	end
end)

hook.Add("PlayerDisconnected", "ADMIN_PlayerDisconnected", function( ply )
	ADMIN:NotifyAll(color_white, ply:Nick(), color_white, "(" ..ply:SteamID() .. ") has disconnected")
end)

hook.Add("PlayerSpray", "ADMIN_PlayerSpray", function(ply)
	if tostring(ply:GetPData("sprays", "0")) == "1" then
		ADMIN:Notify(ply, color_white, "You have been banned for spraying inappropriate material.")
		return true
	end

	if ply:Alive() and ply:Team() != TEAM_SPECTATOR then
		net.Start("admin_spray")
			net.WriteEntity(ply)
			net.WriteVector(ply:GetEyeTraceNoCursor().HitPos)
			net.WriteString(ply:Nick())
			net.WriteString(ply:SteamID())
		net.Broadcast()
	end
end)

hook.Add("DoPlayerDeath", "ADMIN_DoPlayerDeath", function(ply, att)
	if att and IsValid(att) and att:IsPlayer() then
		net.Start("admin_sendcap2")
			net.WriteString(att:SteamID64())
		net.Send(att)
	end
end)

hook.Add("PlayerNoClip", "ADMIN_PlayerNoClip", function(ply, bool)
	if ply:GetLevel() > 1 then
		return !bool
	end
	return false
end)

--[[hook.Add("TTTEndRound", "ADMIN_TTTEndRound", function()
	file.Append("ttt/" .. os.date("%m-%d-%Y") .. "/" .. game.GetMap() .. "/" .. time .. ".txt", "--START OF ROUND--\n")

	for _, event in pairs(GAMEMODE.DamageLog) do
		file.Append("ttt/" .. os.date("%m-%d-%Y") .. "/" .. game.GetMap() .. "/" .. time .. ".txt", event .. "\n")
	end

	file.Append("ttt/" .. os.date("%m-%d-%Y") .. "/" .. game.GetMap() .. "/" .. time .. ".txt", "--END OF ROUND--\n")
end)

hook.Add("Initialize", "ADMIN_Initialize", function()
	local files, folders = file.Find("ttt/" .. os.date("%m-%d-%Y") .. "/" .. game.GetMap() .. "/*.txt", "DATA")

	if !files then
		file.CreateDir("ttt/" .. os.date("%m-%d-%Y") .. "/" .. game.GetMap() .. "/")
	end

	time = #files

	file.Write("ttt/" .. os.date("%m-%d-%Y") .. "/" .. game.GetMap() .. "/" .. time .. ".txt", event)
end)

hook.Add("ShutDown", "ADMIN_ShutDown", function()
	for _, event in pairs(GAMEMODE.DamageLog) do
		file.Append("ttt/" .. os.date("%m-%d-%Y") .. "/" .. game.GetMap() .. "/" .. time .. ".txt", event .. "\n")
	end
end)--]]
