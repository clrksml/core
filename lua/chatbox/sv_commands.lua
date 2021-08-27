local CHATBOX = CORE.CHATBOX

local concommand = concommand

concommand.Add("chatbox", function(ply, cmd, args)
	if !args[1] then return end
	
	print(cmd, args[1], ply:GetNWBool("chatbox_tts", false))
	
	if args[1] == "tts" then
		if !ply:GetNWBool("chatbox_tts", false) then
			ply:SetNWBool("chatbox_tts", true)
		else
			ply:SetNWBool("chatbox_tts", false)
		end
	end
	
	if args[1] == "performance" then
		print(ply:GetNWBool("chatbox_performance", false))
		if !ply:GetNWBool("chatbox_performance", false) then
			ply:SetNWBool("chatbox_performance", true)
		else
			ply:SetNWBool("chatbox_performance", false)
		end
	end
end)
