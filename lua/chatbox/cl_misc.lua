local CHATBOX = CORE.CHATBOX

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

function CHATBOX:AddHistory(pl, msg, tc)
	if pl == 0 then pl = nil end
	
	if tonumber(pl) == pl  then
		for k, v in pairs(player.GetAll()) do
			if v:UserID() == pl then
				pl = v
				break
			end
		end
	end
	
	msg = CHATBOX:ChatToColor(msg)
	
	chat.PlaySound()
	
	if pl and type(pl) == "Player" and pl:IsPlayer() then
		local color = pl:GetUserColor()
		
		CHATBOX.History[#CHATBOX.History + 1] = { pl = pl, color = color, name = pl:Nick(), msg = msg, tc = tc, time = os.clock()}
	else
		CHATBOX.History[#CHATBOX.History + 1] = {msg = msg, time = os.clock()}
	end
	
	if type(msg) == "table" then
		local str = ""
		
		for k, v in pairs(msg) do
			for _k, _v in pairs(v) do
				if _k != 1 then
					str = str .. tostring(_v)
				end
			end
		end
		
		local str2
		if string.find(str, ":") then
			str2 = string.Explode(":", str)[2]
			str = string.Replace(str, " : ", ": ")
		else
			str2 = str
		end
		
		if pl and type(pl) == "Player" and pl:IsPlayer() then
			//if LocalPlayer():GetNWBool("chatbox_tts", false) then
				sound.PlayURL("http://translate.google.com/translate_tts?tl=en&q=" .. str2, "3d", function( sound )
					if IsValid( sound ) then
						if LocalPlayer():Alive() and !pl:Alive() then return end
						
						if !pl then
							pl = LocalPlayer()
						end
						
						sound:SetPos(pl:GetPos())
						sound:SetVolume(1)
						sound:Play()
						sound:Set3DFadeDistance(200, 1000)
						pl.sound = sound
					end
				end)
			//end
			str = pl:Nick() .. ": " .. str
		end
		
		MsgN(str)
	else
		local str = ""
		
		if pl and type(pl) == "Player" and pl:IsPlayer() then
			//if LocalPlayer():GetNWBool("chatbox_tts", false) then
				sound.PlayURL("http://translate.google.com/translate_tts?tl=en&q=" .. msg, "3d", function( sound )
					if IsValid( sound ) then
						if LocalPlayer():Alive() and !pl:Alive() then return end
						
						if !pl then
							pl = LocalPlayer()
						end
						
						sound:SetPos(pl:GetPos())
						sound:SetVolume(1)
						sound:Play()
						sound:Set3DFadeDistance(200, 1000)
						pl.sound = sound
					end
				end)
			//end
			str = pl:Nick() .. ": " .. msg
		end
		
		MsgN(str)
	end
	
	if IsValid(ChatBox) then
		if ChatBox:IsVisible() then
			for k, v in pairs(ChatBox.ScrollPanel:GetChildren()[1]:GetChildren()) do
				v.Paint = function() end
				v:Remove()
			end
			
			ChatBox:Refresh()
		end
	end
end

function CHATBOX:ChatToColor( txt )
	local tbl, text, added = string.Explode(txt, "rgb"), {}, false
	
	if string.find(txt, "rgb") then
		tbl, text, added = string.Explode("rgb", txt), {}, false
		
		for k, v in pairs(tbl) do
			if !string.IsEmpty(v) then
				if string.find(v, "(", 0, true) and string.find(v, ")", 0, true) then
					local spos, epos = string.find(v, "(", 0, true), string.find(v, ")", 0, true)
					local text2, text3 = "", ""
					
					for i=0, epos do
						if i >= spos then
							local str = string.GetChar(v, i)
							if string.IsNumber(str) or !string.IsNumber(str) and string.IsNumber(string.GetChar(v, i - 1)) and str == "," then
								if string.IsNumber(str) then
									text2 = text2 .. string.IsNumber(str)
								else
									text2 = text2 .. " "
								end
							end
							
							text3 = text3 .. str
						end
					end
					
					if text2:len() >= 5 then
						text2 = string.Explode(" ", text2)
						text2 = Color(text2[1], text2[2], text2[3])
						text3 = string.Replace(v, text3, "")
						
						if !string.IsEmpty(v) and !added then
							if !string.find(text3, "(", 0, true) and !string.find(text3, ")", 0, true) then
								text[#text + 1] = {[1] = text2, [2] = text3}
							else
								text[#text + 1] = {[1] = text2, [2] = text3}
							end
							
							added = true
						end
					end
				else
					if !added then
						if !string.IsEmpty(v) then
							text[#text + 1] = {[1] = color_white, [2] = v}
						end
					end
				end
				
				added = false
			end
		end
		
		if #text > 0 then
			txt = text
			
			text, added = {}, false
		end
	end
	
	return txt
end

function chat.AddText( ... )
	local args = { ... }
	local str = ""
	
	for k, v in pairs(args) do
		if type(v) == "table" then
			str = str .. "rgb(" .. v['r'] .. ", " .. v['g'] .. ", " .. v['b'] .. ") "
		elseif type(v) == "Player" then
			str = str .. "rgb(20, 200, 20)" .. tostring(v:Nick())
		else
			str = str .. tostring(v) .. " "
		end
	end
	
	CHATBOX:AddHistory(nil, str, 0, false)
end
