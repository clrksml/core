local CHATBOX = CORE.CHATBOX

local hook = hook
local table = table
local string = string
local chat = chat
local pairs = pairs

hook.Add("PlayerInitialSpawn", "CHATBOX_PlayerInitialSpawn", function(ply)
	timer.Simple(3, function()
		mysql:DoQuery("SELECT  `tts` FROM `settings` WHERE `sid`='" .. ply:SteamID64() .. "'", function( data )
			if data and data[1] then
				data = data[1]
				
				if data and data['tts'] then
					ply:SetPData("tts", data['tts'])
				end
			end
		end)
	end)
end)

hook.Add("PlayerSay", "CHATBOX_PlayerSay", function(ply, txt, tm)
	local cmd, args, str
	
	str = txt
	
	if string.Left(txt, 1) == "!" then
		txt = txt:gsub( "^.(%S+)", function( match )
			cmd = match
			return ""
		end, 1)
		
		//txt, cmd = string.gsub(txt, "!", "", 1), string.Left(txt, string.find(txt, " "))
	end
	
	args = string.Explode(" ", txt)
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
		
		--CHATBOX:AddHistory(ply, txt, tm, cmd) // suggestions/autocomplete if I renable it--]]
		
		return ""
	else
		if ply:IsMuted() then
			CORE.ADMIN:Notify(ply, color_white, " You are muted. No one can see you talk.")
			return ""
		end
		
		if !CHATBOX then CHATBOX = CORE.CHATBOX end
		if CHATBOX != CORE.CHATBOX then CHATBOX = CORE.CHATBOX end
		
		--CHATBOX:AddHistory(ply, str, tm)
		MsgN(ply:Nick() .. ": " .. txt)
		
		
		txt = string.SplitAt(txt, 100, 0)
		
		return txt
	end
end)
