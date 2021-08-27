local ADVERT = CORE.ADVERT

local hook = hook
local table = table
local string = string
local chat = chat
local pairs = pairs
local util = util

local colors = { Color(26, 188, 156), Color(46, 204, 113), Color(52, 152, 219), Color(155, 89, 182), Color(241, 196, 15), Color(230, 126, 34), Color(231, 76, 60), }
local color = table.FindNext(colors, #colors)
local advert

hook.Add("Initialize", "ADVERT_Initialize", function()
	mysql:DoQuery("SELECT * FROM `adverts`", function(data)
		if data then
			ADVERT.Adverts = data
			advert = table.FindNext(ADVERT.Adverts, #ADVERT.Adverts)
		end
	end)
end)

hook.Add("Think", "ADVERT_Think", function()
	if !ADVERT.LastThink or ADVERT.LastThink <= CurTime() then
		if ADVERT.Adverts then
			color = table.Random(colors)
			advert = table.FindNext(ADVERT.Adverts, advert)
			
			net.Start("advert_display")
				net.WriteFloat(color.r)
				net.WriteFloat(color.g)
				net.WriteFloat(color.b)
				net.WriteString(advert['ad'])
			net.Broadcast()
			
			ADVERT.LastThink = CurTime() + 60
		end
	end
end)
