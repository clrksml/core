local CHATBOX = CORE.CHATBOX

local PANEL = {}

function PANEL:Init()
	self:SetZPos(-1000)
	self:SetPos(50, math.Round(ScrH() - 491))
	self:SetSize(800, 272)
	self:MakePopup()
	self:ShowCloseButton(false)
	self:SetTitle("")
	self.Refresh = function()
		if self.ScrollPanel:IsVisible() then
			self.ScrollPanel:Refresh()
		end
	end
	self.Paint = function()
		surface.DrawBox(0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 255))
	end

	self.ScrollPanel = vgui.Create("DPanelList", self)
	self.ScrollPanel:SetPos(0, 0)
	self.ScrollPanel:SetSize(self:GetWide(), self:GetTall() - 16)
	self.ScrollPanel:EnableVerticalScrollbar()
	self.ScrollPanel.Paint = function()
		surface.DrawBox(0, 0, self.ScrollPanel:GetWide(), self.ScrollPanel:GetTall(), Color(100, 100, 100, 255))
	end
	self.ScrollPanel.Refresh = function()
		for k, v in SortedPairs(CHATBOX.History, true) do
			render.SetScissorRect(0, 0, self.ScrollPanel:GetWide(), 16, true)
			local DPanel = self.ScrollPanel:Add("DPanel")
			DPanel:SetSize(self.ScrollPanel:GetWide(), 16)
			DPanel.Paint = function()
				if v.pl and type(v.pl) == "Player" and v.pl:IsPlayer() and IsValid(v.pl) then
					surface.SetFont("qtn")

					local color = v.color
					local name = v.name
					local tc = v.tc
					local w, h, ww, hh = 0, 0, 0, 0

					if !LocalPlayer():GetNWBool("chatbox_performance", false) then
						if file.Exists("materials/flags16/" .. v.pl:GetNWString("Country", system.GetCountry()):lower() .. ".png", "GAME") then
							surface.DrawImage(0, 2, 16, 12, "flags16/" .. v.pl:GetNWString("Country", system.GetCountry()):lower() .. ".png")

							w = 18
						end
					end

					if tc == 1 then
						surface.DrawSentence("qtn", color, w, 0, "(TEAM) " .. name)

						ww, hh = surface.GetTextSize("(TEAM) " .. name)
						w = ww + w
					else
						surface.DrawSentence("qtn", color, w, 0, name)

						ww, hh = surface.GetTextSize(name)
						w = ww + w
					end

					if type(v.msg) == "table" then
						surface.DrawSentence("qtn", color_white, w, 0, ": ")

						ww, hh = surface.GetTextSize(": ")
						w = ww + w

						for _k, _v in pairs(v.msg) do
							if type(_v[1]) == "string" then
								surface.DrawImage(w, 2, 14, 14, _v[1])

								w = 16 + w
							else
								surface.DrawSentence("qtn", _v[1], w, 0, _v[2])

								ww, hh = surface.GetTextSize(_v[2])
								w = ww + w
							end
						end
					else
						surface.DrawSentence("qtn", color_white, w, 0, ": " .. v.msg)
					end
				else
					local w, h = 0, 0
					local ww, hh = 0, 0

					if type(v.msg) == "table" then
						for _k, _v in pairs(v.msg) do
							surface.DrawSentence("qtn", _v[1], w, 0, _v[2])

							ww, hh = surface.GetTextSize(_v[2])
							w = ww + w
						end
					else
						surface.DrawSentence("qtn", color_white, w, 0, v.msg)
					end
				end
			end

			if type(v.msg) == "table" then
				for _k, _v in pairs(v.msg) do
					if _v[2] and string.HasURL(_v[2]) then
						surface.SetFont("qtn")

						local Button = vgui.Create("DButton", DPanel)
						Button:SetText("")
						Button:SetPos(0, 0)
						Button:SetSize(DPanel:GetWide(), DPanel:GetTall())
						Button:MoveToFront()
						Button.DoClick = function()
							gui.OpenURL(string.ParseURL(_v[2]))
							print("Openning URL: " .. string.ParseURL(_v[2]))
						end
						Button.DoRightClick = function()
							local menu = DermaMenu()
							menu:AddOption("Copy", function() SetClipboardText(_v[2]) end)
							menu:AddOption("Close", function() end)
							menu:Open()
						end
						Button.Paint = function() end
					else
						local Button = vgui.Create("DButton", DPanel)
						Button:SetText("")
						Button:SetPos(0, 0)
						Button:SetSize(DPanel:GetWide(), DPanel:GetTall())
						Button:MoveToFront()
						Button.DoRightClick = function()
							local menu = DermaMenu()
							menu:AddOption("Copy", function() SetClipboardText(_v[2]) end)
							menu:AddOption("Close", function() end)
							menu:Open()
						end
						Button.Paint = function() end
					end
				end
			else
				if string.HasURL(v.msg) then
					surface.SetFont("qtn")

					local Button = vgui.Create("DButton", DPanel)
					Button:SetText("")
					Button:SetPos(0, 0)
					Button:SetSize(DPanel:GetWide(), DPanel:GetTall())
					Button:MoveToFront()
					Button.DoClick = function()
						gui.OpenURL(string.ParseURL(v.msg))
						print("Openning URL: " .. string.ParseURL(v.msg))
					end
					Button.DoRightClick = function()
						local menu = DermaMenu()
						menu:AddOption("Copy", function() SetClipboardText(v.msg) end)
						menu:AddOption("Close", function() end)
						menu:Open()
					end
					Button.Paint = function() end
				else
					local Button = vgui.Create("DButton", DPanel)
					Button:SetText("")
					Button:SetPos(0, 0)
					Button:SetSize(DPanel:GetWide(), DPanel:GetTall())
					Button:MoveToFront()
					Button.DoRightClick = function()
						local menu = DermaMenu()
						menu:AddOption("Copy", function() SetClipboardText(v.msg) end)
						menu:AddOption("Close", function() end)
						menu:Open()
					end
					Button.Paint = function() end
				end
			end

			render.SetScissorRect(0, 0, 0, 16, false)

			self.ScrollPanel:InsertAtTop(DPanel)
		end
	end

	self.TextEntry = vgui.Create("DTextEntry", self)
	self.TextEntry:SetPos(0, self:GetTall() - 16)
	self.TextEntry:SetSize(self:GetWide() - 32, 16)
	self.TextEntry:SetFont("qtn")
	self.TextEntry:SetText("")
	self.TextEntry:SetTextColor(color_white)

	local w, h = surface.GetTextSize(CHATBOX.ChatPrefix)

	self.TextEntry.CaretPos = w

	self.TextEntry.Paint = function()
		surface.DrawBox(0, 0, self.TextEntry:GetWide(), self.TextEntry:GetTall(), Color(90, 90, 90, 100))

		surface.SetFont("qtn")
		local w, h = surface.GetTextSize(CHATBOX.ChatPrefix)

		local text = string.SplitAt(self.TextEntry:GetText(), 100, 0)

		surface.DrawSentence("qtn", color_white, 0, 0, CHATBOX.ChatPrefix)
		surface.DrawSentence("qtn", color_white, w + 2, 0, text)
		//surface.DrawBox(self.TextEntry.CaretPos + 16, 0, 3, 16, Color(math.random(155,255), math.random(155,255), math.random(155,255)))
	end
	self.TextEntry.AllowInput = function()
		local text = self.TextEntry:GetText()

		if text:len() > 100 then
			surface.PlaySound("resource/warning.wav")
		end
	end
	self.TextEntry.OnTextChanged = function(entry)
		local text = entry:GetText()

		self.TextEntry:AllowInput()

		surface.SetFont("qtn")
		local w, h, w2, h2 = surface.GetTextSize(text), surface.GetTextSize(CHATBOX.ChatPrefix)

		text = string.SplitAt(text, 100, 0)

		self.TextEntry.CaretPos = w + w2

		if self.TextEntry.command then
			CHATBOX.ChatPrefix = CHATBOX.TeamChat and "Command (Team): " || "Command: "
		elseif !self.TextEntry.command and text:sub(1, 1) == "!" then
			self.TextEntry:SetText(text:sub(2))
			self.TextEntry.command = true

			CHATBOX.ChatPrefix = CHATBOX.TeamChat and "Command (Team): " || "Command: "
		elseif CHATBOX.TeamChat then
			CHATBOX.ChatPrefix = "Team: "
		else
			CHATBOX.ChatPrefix = "Say: "
		end

		if CHATBOX.ChatPrefix != self.ChatPrefix then
			self.ChatPrefix = CHATBOX.ChatPrefix
		end
	end
	self.TextEntry.onLoseFocus = function(entry)
		self:Hide()

		return true
	end

	self.TextEntry.OnKeyCodeTyped = function(entry, code)
		local keycode, text = code, entry:GetValue()

		text = string.SplitAt(self.TextEntry:GetText(), 100, 0)

		/*if (code == KEY_BACKSPACE) then
			if self.TextEntry:GetText():len() > 1 then
				self.TextEntry:SetText(string.SplitAt(text, text:len() - 1), 0)
			else
				self.TextEntry:SetText("")
			end

			entry:OnTextChanged()
		end*/

		surface.SetFont("qtn")
		local w, h, w2, h2 = surface.GetTextSize(text), surface.GetTextSize(CHATBOX.ChatPrefix)

		self.TextEntry.CaretPos = w + w2

		if (code == KEY_ENTER) then
			if (text and #text > 0) then
				RunConsoleCommand(CHATBOX.TeamChat and "say_team" || "say", entry.command and "!" .. text || text)
			end

			self:Hide()
		end

		if (code == KEY_ESCAPE) then
			self:Hide()

			return true
		end

		if (code == KEY_TAB) then
			surface.SetFont("qtn")
			local w, h, w2, h2 = surface.GetTextSize(text), surface.GetTextSize(CHATBOX.ChatPrefix)

			self.TextEntry.CaretPos = w + w2

			return true
		end
	end

	self.ScrollPanel:Refresh()
	self.ScrollPanel.VBar:MoveToFront()
	self.ScrollPanel.VBar:AnimateTo(#CHATBOX.History * 16, 1, 0, 0)

	self.ScrollPanel.VBar:AnimateTo(self.ScrollPanel:GetTall(), 0, 0, 0)
	self.ScrollPanel.VBar.Paint = function()
		surface.DrawBox(0, 0, self.ScrollPanel.VBar:GetWide(), self.ScrollPanel.VBar:GetTall(), Color(180, 180, 180, 150))
	end
	self.ScrollPanel.VBar.btnUp.Paint = function()
		surface.DrawBox(0, 0, self.ScrollPanel.VBar.btnUp:GetWide(), self.ScrollPanel.VBar.btnUp:GetTall(), Color(170, 170, 170, 150))
	end
	self.ScrollPanel.VBar.btnDown.Paint = function()
		surface.DrawBox(0, 0, self.ScrollPanel.VBar.btnDown:GetWide(), self.ScrollPanel.VBar.btnDown:GetTall(), Color(160, 160, 160, 150))
	end
	self.ScrollPanel.VBar.btnGrip.Paint = function()
		surface.DrawBox(0, 0, self.ScrollPanel.VBar.btnGrip:GetWide(), self.ScrollPanel.VBar.btnGrip:GetTall(), Color(190, 190, 190, 200))
	end

	self.ImageButton = vgui.Create("DImageButton", self)
	self.ImageButton:SetPos(self:GetWide() - 16, self:GetTall() - 16)
	self.ImageButton:SetSize(16, 16)
	self.ImageButton:SetImage("icon16/color_wheel.png", "icon16/palette.png")
	self.ImageButton:MoveToFront()
	self.ImageButton.Paint = function()
		surface.DrawBox(0, 0, self.ImageButton:GetWide(), self.ImageButton:GetTall(), Color(90, 90, 90, 100))
	end
	self.ImageButton.DoClick = function()
		local Panel = vgui.Create("DPanel", self)
		Panel:SetPos(self:GetWide() - 200, self:GetTall() - 200)
		Panel:SetSize(200, 200)
		Panel.Paint = function()
			surface.DrawBox(0, 0, Panel:GetWide(), Panel:GetTall(), Color(90, 90, 90, 255))
		end

		local ColorMixer = vgui.Create("DColorMixer", Panel)
		ColorMixer:SetPos(0, 0)
		ColorMixer:SetSize(200, 175)
		ColorMixer:SetPalette(false)
		ColorMixer:SetAlphaBar(false)
		ColorMixer:SetWangs(false)
		ColorMixer:SetColor(Color(255, 255, 255))

		Button = vgui.Create("DImageButton", Panel)
		Button:SetPos(2, 182)
		Button:SetSize(16, 16)
		Button:SetImage("icon16/delete.png", "icon16/cross.png")
		Button.DoClick = function()
			Panel:Remove()
		end

		Button2 = vgui.Create("DImageButton", Panel)
		Button2:SetPos(182, 182)
		Button2:SetSize(16, 16)
		Button2:SetImage("icon16/accept.png", "icon16/check.png")
		Button2.DoClick = function()
			self.TextEntry:SetText(self.TextEntry:GetValue() .. "rgb(" .. tostring(ColorMixer:GetColor().r) .. "," .. tostring(ColorMixer:GetColor().g) .. "," .. tostring(ColorMixer:GetColor().b) .. ")")

			local w, h, w2, h2 = surface.GetTextSize(self.TextEntry:GetValue()), surface.GetTextSize(CHATBOX.ChatPrefix)
			self.TextEntry.CaretPos = w + w2

			Panel:Remove()

			self:SetKeyboardInputEnabled(true)
			self:SetMouseInputEnabled(true)
			self:SetFocusTopLevel(true)
			self.TextEntry:RequestFocus()
		end
	end

	self.ImageButton2 = vgui.Create("DImageButton", self)
	self.ImageButton2:SetPos(self:GetWide() - 32, self:GetTall() - 16)
	self.ImageButton2:SetSize(16, 16)
	self.ImageButton2:SetImage("icon16/control_equalizer_blue.png", "icon16/control_equalizer.png")
	self.ImageButton2:MoveToFront()
	self.ImageButton2.Paint = function()
		surface.DrawBox(0, 0, self.ImageButton2:GetWide(), self.ImageButton2:GetTall(), Color(90, 90, 90, 100))
	end
	self.ImageButton2.DoClick = function()
		local Panel = vgui.Create("DPanel", self)
		Panel:SetPos(self:GetWide() - 200, self:GetTall() - 100)
		Panel:SetSize(200, 100)
		Panel.Paint = function()
			surface.DrawBox(0, 0, Panel:GetWide(), Panel:GetTall(), Color(90, 90, 90, 255))
		end

		local CheckBoxLabel = vgui.Create("DCheckBoxLabel", Panel)
		CheckBoxLabel:SetPos(2, 2)
		CheckBoxLabel:SetText("Toggle TTS")
		CheckBoxLabel:SetValue(LocalPlayer():GetNWBool("chatbox_tts", false))
		CheckBoxLabel:SizeToContents()
		CheckBoxLabel.OnChange = function()
			RunConsoleCommand("chatbox", "tts")
		end

		local CheckBoxLabel2 = vgui.Create("DCheckBoxLabel", Panel)
		CheckBoxLabel2:SetPos(2, CheckBoxLabel:GetTall() + 4)
		CheckBoxLabel2:SetText("Toggle Performance")
		CheckBoxLabel2:SetValue(LocalPlayer():GetNWBool("chatbox_performance", false))
		CheckBoxLabel2:SizeToContents()
		CheckBoxLabel2.OnChange = function()
			RunConsoleCommand("chatbox", "performance")
		end

		Button2 = vgui.Create("DImageButton", Panel)
		Button2:SetPos(182, 82)
		Button2:SetSize(16, 16)
		Button2:SetImage("icon16/accept.png", "icon16/check.png")
		Button2.DoClick = function()
			Panel:Remove()

			self:SetKeyboardInputEnabled(true)
			self:SetMouseInputEnabled(true)
			self:SetFocusTopLevel(true)
			self.TextEntry:RequestFocus()
		end
	end

	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	self:SetFocusTopLevel(true)
	self.TextEntry:RequestFocus()
end

function PANEL:Show()
	if CHATBOX.ChatOn then
		self:Hide()
		return
	end

	CHATBOX.ChatOn = true
	CHATBOX.ChatOpen = true

	self:Init()
end

function PANEL:Hide()
	self.TextEntry.command = false
	self.TextEntry:SetText("")

	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)

	CHATBOX.ChatOn = false
	CHATBOX.TeamChat = false
	CHATBOX.ChatOpen = false

	self:Remove()
end

vgui.Register("ChatBox", PANEL, "DFrame")
