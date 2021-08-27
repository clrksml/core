local ADMIN = CORE.ADMIN

local hook = hook
local net = net
local util = util
local timer = timer

hook.Add("Initialize", "ADMIN_Initialize", function()
	mysql:DoQuery("SELECT `name` FROM `groups`", function( data )
		for k, v in pairs(data) do
			ADMIN:AddGroup(v['name'])
		end
	end)
	
	timer.Simple(0.1, function()
		mysql:DoQuery("SELECT * FROM `users` WHERE `rank`!='guest'", function( data )
			for k, v in pairs(data) do
				if ADMIN.Groups[v['rank']] then
					ADMIN:AddUser(v['rank'], v['sid'])
				end
			end
		end)
	end)
end)
