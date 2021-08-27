local ADVERT = CORE.ADVERT

local surface = surface
local hook = hook
local math = math
local gui = gui
local os = os
local string = string
local vgui = vgui
local player = player
local chat = chat
local type = type
local pairs = pairs
local tonumber = tonumber
local tostring = tostring

if !ADVERT.History then
	ADVERT.History = {}
end

function ADVERT:AddHistory(color, text)
	ADVERT.History[#ADVERT.History + 1] = { color = color, text = text, added = false }
	
	CORE.ADVERT.Adverts:Refresh()
end

hook.Add("InitPostEntity", "ADVERT_InitPostEntity", function()
	CORE.ADVERT.Adverts = vgui.Create("Adverts")
	CORE.ADVERT.Adverts:Init()
	CORE.ADVERT.Adverts:Hide()
end)
