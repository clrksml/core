local STEAM = CORE.STEAM
local key = "FFFF0CA2515083BC4C28B7F42469FCFE"
local http = http
local string = string
local util = util

function STEAM:InitData( ply )
	if !ply.Steam then ply.Steam = {} end
	
	STEAM:InitFriends(ply)
	STEAM:InitBans(ply)
	STEAM:InitGroups(ply)
end

function STEAM:GetFriends(ply)
	return ply.Steam['friends']
end

function STEAM:InitFriends(ply)
	http.Fetch("http://api.steampowered.com/ISteamUser/GetFriendList/v1/?key=" ..  key .. "&steamid=" .. ply:SteamID64(), function( json )
		if string.GetChar(json, 1) == "{" then
			local tbl = util.JSONToTable(json) or {}
			
			if tbl['friendslist']['friends'] then
				tbl = tbl['friendslist']['friends']
			end
			
			for k, v in pairs(tbl) do
				if v['relationship'] != "friend" then
					k, v = nil, nil
				else
					tbl[k] = v['steamid']
				end
			end
			
			ply.Steam['friends'] = tbl
		else
			MsgN("SteamAPI failed to retrieve fetch request.")
		end
	end)
end

function STEAM:GetBans(ply)
	return ply.Steam['bans']
end

function STEAM:InitBans(ply)
	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=FFFF0CA2515083BC4C28B7F42469FCFE" ..  key .. "&steamids=" .. ply:SteamID64(), function( json )
		if string.GetChar(json, 1) == "{" then
			local tbl = util.JSONToTable(json) or {}
			
			ply.Steam['bans'] = { ['CBan'] = false, ['GBan'] = false, ['VBan'] = false, ['Bans'] = 0 }
			
			if tbl['CommunityBanned'] == true then
				ply.Steam['bans']['CBan'] = true
			end
			
			if tbl['NumberOfGameBans'] == true then
				ply.Steam['bans']['GBan'] = true
			end
			
			if tbl['VACBanned'] == true then
				ply.Steam['bans']['VBan'] = true
			end
			
			if tbl['NumberOfVACBans'] and tbl['NumberOfVACBans'] > 0 or tbl['NumberOfGameBans'] and tbl['NumberOfGameBans'] > 0 then
				ply.Steam['bans']['Bans'] = tbl['NumberOfVACBans'] or 0 + tbl['NumberOfGameBans'] or 0
			end
		else
			MsgN("SteamAPI failed to retrieve fetch request.")
		end
	end)
end

function STEAM:GetGroups(ply)
	return ply.Steam['groups']
end

function STEAM:InitGroups(ply)
	http.Fetch("http://api.steampowered.com/ISteamUser/GetUserGroupList/v1/?steamid=" .. ply:SteamID64(), function( json )
		if string.GetChar(json, 1) == "{" then
			local tbl, tbl2 = util.JSONToTable(json) or {}, {}
			tbl = tbl['response']['groups']
			
			for k, v in pairs(tbl) do
				table.insert(tbl2, tbl[k]['gid'])
			end
			
			ply.Steam['groups'] = tbl2
		else
			MsgN("SteamAPI failed to retrieve fetch request.")
		end
	end)
end
