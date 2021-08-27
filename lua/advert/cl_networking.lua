local ADVERT = CORE.ADVERT

local net = net
local tonumber = tonumber

net.Receive("advert_display", function( len )
	local color, text = Color(tonumber(net.ReadFloat()), tonumber(net.ReadFloat()), tonumber(net.ReadFloat())), net.ReadString()
	
	//ADVERT:AddHistory(color, text)
end)
