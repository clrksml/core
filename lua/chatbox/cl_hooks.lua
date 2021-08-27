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

surface.CreateFont("qlg", {font = "Arial", size = 32, weight = 1000, antialias = true})
surface.CreateFont("qmd", {font = "Arial", size = 24, weight = 1000, antialias = true})
surface.CreateFont("qsm", {font = "Arial", size = 20, weight = 1000, antialias = true})
//surface.CreateFont("qtn", {font = "Arial", size = 16, weight = 750, antialias = true})
//surface.CreateFont("qlt", {font = "Arial", size = 8, weight = 750, antialias = true})

if !CHATBOX.History then
	CHATBOX.History = {}
	CHATBOX.Emoticons = {}

	local files, folders = file.Find("materials/icon16/*.png", "GAME")

	for k, v in pairs(files) do
		CHATBOX.Emoticons[string.Explode(".", v)[1]] = k
	end
end

hook.Add("InitPostEntity", "CHATBOX_InitPostEntity", function()
	CHATBOX.ChatOn = false
	CHATBOX.TeamChat = false
	CHATBOX.ChatPrefix = "Say: "

	if IsMounted("cstrike") then return end

	CHATBOX:AddHistory(nil, "HEY BUDDY YOU DON'T HAVE CSS MOUNTED/INSTALLED", false)
end)

hook.Add("OnPlayerChat", "CHATBOX_OnPlayerChat", function(ply, txt, tc, dead)
	if GAMEMODE.round_state == ROUND_ACTIVE then
		if IsValid(ply) then
			if ply:Team() == LocalPlayer():Team() or LocalPlayer():Team() == TEAM_SPECTATOR then
				if ply:GetLevel() > 0 then
					for k, v in pairs(CHATBOX.Sounds) do
						if string.find(txt:lower(), k:lower()) then
							CHATBOX:PlaySound(k)

							timer.Simple(0.25, function()
								CHATBOX:AddHistory(ply, txt, tc)
							end)

							return true
						end
					end
				end

				CHATBOX:AddHistory(ply, txt, tc)
			end
		end
	else
		if IsValid(ply) then
			if ply:GetLevel() > 0 then
				for k, v in pairs(CHATBOX.Sounds) do
					if string.find(txt:lower(), k:lower()) then
						CHATBOX:PlaySound(k)

						timer.Simple(0.25, function()
							CHATBOX:AddHistory(ply, txt, tc)
						end)

						return true
					end
				end
			end
		end

		CHATBOX:AddHistory(ply, txt, tc)
	end

	return true
end)

hook.Add("ChatText", "CHATBOX_ChatText", function(playerindex, playername, text, filter)
	if tonumber(playerindex) == 0 and filter != "joinleave" then
		CHATBOX:AddHistory(nil, text)
	end

	return true
end)

hook.Add("PostRenderVGUI", "CHATBOX_PostRenderVGUI", function()
	if IsValid(sboard_panel) and sboard_panel:IsVisible() then return end
	if gui.IsConsoleVisible() then return end
	if CORE.STORE and CORE.STORE.OPEN then return end
	if CHATBOX.ChatOpen then return end

	local x, y = 50, math.Round(ScrH() - 210)
	local num = 0
	local total = 0

	if #CHATBOX.History < 17 then
		y = math.Round(ScrH() - 491)

		for i=1, #CHATBOX.History do
			y = y + 16
		end
	end

	surface.SetFont("qtn")

	for k, v in pairs(CHATBOX.History) do
		if (v.time + 15 > os.clock()) and k > #CHATBOX.History - 16 then
			total = total + 1
		end
	end

	for k, v in pairs(CHATBOX.History) do
		if (v.time + 15 > os.clock()) and k > #CHATBOX.History - 16 then
			if v.pl and type(v.pl) == "Player" and v.pl:IsPlayer() and IsValid(v.pl) then
				local color, name, tc, w, h, ww, hh = v.color, v.name, v.tc, 0, 0, 0, 0

				if !LocalPlayer():GetNWBool("chatbox_performance", false) then
					if file.Exists("materials/flags16/" .. v.pl:GetNWString("Country", system.GetCountry()):lower() .. ".png", "GAME") then
						surface.DrawImage(x, y - (total * 16) + (num * 16) + 2, 16, 12, "flags16/" .. v.pl:GetNWString("Country", system.GetCountry()):lower() .. ".png")

						w = 18
					end
				end

				if tc == 1 then
					surface.DrawSentence("qtn", color, x + w, y - (total * 16) + (num * 16), "(TEAM) " .. name)

					ww, hh = surface.GetTextSize("(TEAM) " .. name)
					w = ww + w
				else
					surface.DrawSentence("qtn", color, x + w, y - (total * 16) + (num * 16), name)

					ww, hh = surface.GetTextSize(name)
					w = ww + w
				end

				if type(v.msg) == "table" then
					surface.DrawSentence("qtn", color_white, x + w, y - (total * 16) + (num * 16), ": ")

					ww, hh = surface.GetTextSize(": ")
					w = ww + w

					for _k, _v in pairs(v.msg) do
						if type(_v[1]) == "string" then
							surface.DrawImage(x + w, y - (total * 16) + (num * 16) + 2, 14, 14, _v[1])

							w = 16 + w
						else
							surface.DrawSentence("qtn", _v[1], x + w, y - (total * 16) + (num * 16), _v[2])

							ww, hh = surface.GetTextSize(_v[2])
							w = ww + w
						end
					end
				else
					surface.DrawSentence("qtn", color_white, x + w, y - (total * 16) + (num * 16), ": " .. v.msg)
				end
			else
				local w, h, ww, hh = 0, 0, 0, 0

				if type(v.msg) == "table" then
					for _k, _v in pairs(v.msg) do
						surface.DrawSentence("qtn", _v[1], x + w, y - (total * 16) + (num * 16), _v[2])

						ww, hh = surface.GetTextSize(_v[2])
						w = ww + w
					end
				else
					surface.DrawSentence("qtn", color_white, x + w, y - (total * 16) + (num * 16), v.msg)
				end
			end

			num = num + 1
		end
	end
end)

hook.Add("Think", "CHATBOX_Think", function()
	if input.IsKeyDown(KEY_ESCAPE) then
		if IsValid(ChatBox) then
			if ChatBox:IsVisible() then
				ChatBox:Hide()
			end
		end
	end

	for k, v in pairs(player.GetAll()) do
		if v.sound then
			v.sound:SetPos(v:GetPos())
		end
	end
end)

hook.Add("PlayerBindPress", "CHATBOX_PlayerBindPress", function(ply, bind, pressed)
	if string.find(bind, "messagemode") and pressed then
		CHATBOX.ChatPrefix = "Say: "

		if string.find(bind, "messagemode2") then
			CHATBOX.ChatPrefix = "Team: "
			CHATBOX.TeamChat = true
		end

		if !IsValid(ChatBox) then
			ChatBox = vgui.Create("ChatBox")
		end

		ChatBox:Show()
		CHATBOX.ChatOpen = true

		return true
	end
end)

hook.Add("StartChat", "CHATBOX_StartChat", function()
	return true
end)

hook.Add("ChatTextChanged", "CHATBOX_ChatTextChanged", function( txt )
	local cmd, args, str

	str = txt

	if string.Left(txt, 1) == "!" then
		txt = txt:gsub( "^.(%S+)", function( match )
			cmd = match
			return ""
		end, 1)
	end

	args = string.Explode(" ", txt)
	table.remove(args, 1)

	if string.match(str, "^[/!][^ ]*$" ) then
		if !IsValid(ChatBox) then
			ChatBox.TextEntry:SetText("")
		end

		return ""
	end
end)
