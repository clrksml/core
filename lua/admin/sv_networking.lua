local ADMIN = CORE.ADMIN

local net = net
local util = util
local pairs = pairs

net.Receive("admin_gotcap", function( len, ply )
	if !ADMIN.Captures then ADMIN.Captures = {} end
	//if ply:GetLevel() > 2 then return end
	
	if ADMIN.Captures[ply] then
		for _, pl in pairs(ADMIN.Captures[ply]) do
			net.Start("admin_docap")
				net.WriteString(ply:SteamID64())
			net.Send(pl)
			
			ADMIN:Notify(pl, color_white, " Got screenshot of " .. ply:Nick() .. "'s screen.")
		end
		
		ADMIN.Captures[ply] = nil
	end
end)

net.Receive("admin_country", function( len, ply )
	ply:SetNWString("country", net.ReadString())
end)