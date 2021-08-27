local CHATBOX = CORE.CHATBOX

local net = net
local tonumber = tonumber

net.Receive("chatbox_addhistory", function( len )
	local ply, txt, tm = net.ReadEntity(), net.ReadString(), tonumber(net.ReadFloat()) or 1
	
	CHATBOX:AddHistory(ply, txt, tm)
end)
