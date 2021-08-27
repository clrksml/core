local STAT = CORE.STAT

local Player = FindMetaTable("Player")

local util = util

function Player:SaveStats()
	if !IsValid(self) then return end
	
	local sid, tbl = self:SteamID64(), self._Stats
	
	mysql:DoQuery("SELECT `data` FROM `stats` WHERE `sid`='" .. sid .. "'", function( data )
		if data and data[1] then
			mysql:DoQuery("UPDATE `stats` SET `data`='" .. util.TableToJSON(tbl) .. "'")
		else
			mysql:DoQuery("INSERT INTO `stats` (`sid`, `data`) VALUES('" .. sid .. "', '" .. util.TableToJSON(tbl) .. "')")
		end
	end)
end

function Player:CreateInitialStats()
	for id, val in pairs(STAT.stats) do
		self._Stats[id] = val
	end
end

function Player:LoadStats()
	if !IsValid(self) then return end
	
	mysql:DoQuery("SELECT `data` FROM `stats` WHERE `sid`='" .. self:SteamID64() .. "'", function( data )
		if IsValid(self) then
			if data and data[1] then
				self._Stats = util.JSONToTable(data[1]['data'])
			else
				self._Stats = {}
				mysql:DoQuery("INSERT INTO `stats` (`sid`, `data`) VALUES('" .. self:SteamID64() .. "', '" .. util.TableToJSON(self._Stats) .. "')")
			end
		end
	end)
end
