local STORE = CORE.STORE

local size, x, y = math.Round((ScrW() - 15) / 10), 0, 0

surface.CreateFont("Trebuchet48", {size = 48, weight = 800, antialias = true, shadow = false, font = "Trebuchet MS"})
surface.CreateFont("Trebuchet72", {size = 72, weight = 800, antialias = true, shadow = false, font = "Trebuchet MS"})

function ConfirmBuy(item, pnl)
	local ConfirmPanel = vgui.Create("DFrame")
	ConfirmPanel:SetSize(ScrW(), ScrH())
	ConfirmPanel:SetPos((ScrW() / 2) - 40, (ScrH() / 2) - 13)
	ConfirmPanel:SetDraggable(false)
	ConfirmPanel:SetTitle("")
	ConfirmPanel:MakePopup()
	ConfirmPanel:Center()
	ConfirmPanel:SetBackgroundBlur(true)
	ConfirmPanel:SetMouseInputEnabled(true)
	ConfirmPanel:SetKeyBoardInputEnabled(true)
	ConfirmPanel:ShowCloseButton(false)
	ConfirmPanel.Paint = function()
		draw.RoundedBox(2, 0, 0, ConfirmPanel:GetWide(), ConfirmPanel:GetTall(), Color(1, 1, 1, 250))

		local txt = "Are you sure you want to buy "

		surface.SetFont("Trebuchet24")

		local w, h = surface.GetTextSize(txt)
		local x, y = (ConfirmPanel:GetWide() / 2) - (w / 2), (ConfirmPanel:GetTall() / 2) - 36

		surface.DrawSentence("Trebuchet24", color_white, x, y, txt)

		surface.SetFont("Trebuchet24")
		local w2, h2 = surface.GetTextSize(item[3])

		surface.DrawSentence("Trebuchet24", Color(64, 150, 238), x + w, y, item[3])
		surface.DrawSentence("Trebuchet24", color_white, x + w + w2, y, "?")

	end

	local AgreeButton = vgui.Create("DButton", ConfirmPanel)
	AgreeButton:SetSize(40, 25)
	AgreeButton:SetPos((ScrW() / 2) - 40, (ScrH() / 2) - 13)
	AgreeButton:SetText("")
	AgreeButton.DoClick = function()
		surface.PlaySound("buttons/button6.wav")

		LocalPlayer():ConCommand("store buy " .. item[1] .. " " .. item[2])

		ConfirmPanel:Remove()

		timer.Simple(0.5, function()
			DrawContent(item[1], pnl, 0):Refresh()
		end)
	end
	AgreeButton.Paint = function()
		draw.DrawText("Yes", "Trebuchet24", 2, 2, Color(23, 180, 24), TEXT_ALIGN_LEFT)
	end

	local DenyButton = vgui.Create("DButton", ConfirmPanel)
	DenyButton:SetSize(40, 25)
	DenyButton:SetPos((ScrW() / 2) + 40, (ScrH() / 2) - 13)
	DenyButton:SetText("")
	DenyButton.DoClick = function()
		ConfirmPanel:Remove()
	end
	DenyButton.Paint = function()
		draw.DrawText("No", "Trebuchet24", 2, 2, Color(176, 43, 44), TEXT_ALIGN_LEFT)
	end
end

function DrawURL(url, pnl)
	if !IsValid(pnl) then return end

	for k, v in pairs(pnl:GetChildren()) do
		v:Remove()
	end

	SubContent = vgui.Create("DScrollPanel", pnl)
	SubContent:SetPos(1, 1)
	SubContent:SetSize(pnl:GetWide() - 2, pnl:GetTall() - 2)
	SubContent.Refresh = function()
		local HTML = vgui.Create("DHTML", SubContent)
		HTML:SetPos(0, 0)
		HTML:SetSize(SubContent:GetWide(), SubContent:GetTall())
		HTML:SetScrollbars(false)
		HTML.ConsoleMessage = function() end
		HTML:OpenURL(url)

		SubContent:SetVisible(true)
	end

	local ScrollBar = SubContent:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(255, 255, 255))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(55, 55, 55))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(55, 55, 55))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(15, 100, 217))
	end

	return SubContent
end

function DrawContent(id, pnl, equip)
	if !IsValid(pnl) then return end

	for k, v in pairs(pnl:GetChildren()) do
		v:Remove()
	end

	local tbl = STORE.ITEMS[id]

	SubContent = vgui.Create("DScrollPanel", pnl)
	SubContent:SetPos(1, 1)
	SubContent:SetSize(pnl:GetWide() - 2, pnl:GetTall() - 2)
	SubContent.pnlCanvas.Paint = function()
		draw.RoundedBox(0, 0, 0, SubContent.pnlCanvas:GetWide(), SubContent.pnlCanvas:GetTall(), Color(255, 255, 255))

		if equip != 0 then
			if !LocalPlayer():GetItems()[id] or #LocalPlayer():GetItems()[id] == 0 then
				surface.SetFont("Trebuchet72")

				local w, h = surface.GetTextSize("You do none of these items.")
				local text = "Hats."

				if id == 1 then
					text = "Hats."
				elseif id == 2 then
					text = "Masks."
				elseif id == 3 then
					text = "Models."
				else
					text = "Trails."
				end

				draw.DrawText("You don't own any " .. text, "Trebuchet72", w, (h * 2), Color(45, 45, 45), TEXT_ALIGN_CENTER)
			end
		end
	end
	SubContent.Refresh = function()
		StoreLayout = vgui.Create("DIconLayout", SubContent)
		StoreLayout:SetPos(1, 1)
		StoreLayout:SetSize(SubContent:GetWide(), SubContent:GetTall())
		StoreLayout:SetSpaceX(1)
		StoreLayout:SetSpaceY(1)

		for k, v in SortedPairs(tbl) do
			if equip == 0 then
				if LocalPlayer():HasItem(v[1], v[2]) then
					continue
				end
			else
				if !LocalPlayer():HasItem(v[1], v[2]) then
					continue
				end
			end

			local MouseOver = false
			local ItemPanel = StoreLayout:Add("DPanel")
			ItemPanel:SetSize(size, size)
			ItemPanel.Paint = function()
				if MouseOver then
					surface.DrawBox(0, 0, size, size, Color(85, 85, 85))
				else
					surface.DrawBox(0, 0, size, size, Color(75, 75, 75))
				end

				surface.SetMaterial(Material("havocgamers/ui/items/" .. v[1]  .. "_" .. v[2] .. ".png"))
				surface.SetDrawColor(Color(225, 225, 225))
				surface.DrawTexturedRect(0, 0, size, size)

				surface.DrawBox(size, size - 24, size, 24, Color(10, 10, 10, 255))
			end
			ItemPanel.PaintOver = function()
				if MouseOver then
					surface.SetFont("Trebuchet24")

					local w, h = surface.GetTextSize("$" .. v[4])

					draw.DrawText("$" .. v[4], "Trebuchet24", ((ItemPanel:GetWide() / 2) - (w / 2)) + 1, size - 44, Color(0, 0, 0), TEXT_ALIGN_LEFT)
					draw.DrawText("$" .. v[4], "Trebuchet24", (ItemPanel:GetWide() / 2) - (w / 2), size - 43, Color(255, 255, 255), TEXT_ALIGN_LEFT)

					surface.SetFont("Trebuchet18")

					w, h = surface.GetTextSize(v[3])

					draw.DrawText(v[3], "Trebuchet18", ((ItemPanel:GetWide() / 2) - (w / 2)) + 1, size - 19, Color(0, 0, 0), TEXT_ALIGN_LEFT)
					draw.DrawText(v[3], "Trebuchet18", (ItemPanel:GetWide() / 2) - (w / 2), size - 18, Color(255, 255, 255), TEXT_ALIGN_LEFT)
				else
					surface.SetFont("Trebuchet18")

					local w, h = surface.GetTextSize(v[3])

					draw.DrawText(v[3], "Trebuchet18", ((ItemPanel:GetWide() / 2) - (w / 2)) + 1, size - 19, Color(0, 0, 0), TEXT_ALIGN_LEFT)
					draw.DrawText(v[3], "Trebuchet18", (ItemPanel:GetWide() / 2) - (w / 2), size - 18, Color(255, 255, 255), TEXT_ALIGN_LEFT)
				end
			end

			local Button = vgui.Create("DButton", ItemPanel)
			Button:SetPos(0, 0)
			Button:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall())
			Button:SetText("")
			Button:MoveToFront()
			Button.DoClick = function()
				if equip == 0 then
					ConfirmBuy(v, pnl)
				else
					surface.PlaySound("buttons/button9.wav")

					LocalPlayer():ConCommand("store equip " .. v[1] .. " " .. v[2])
				end
			end
			Button.OnCursorEntered = function()
				MouseOver = true
			end
			Button.OnCursorExited = function()
				MouseOver = false
			end
			Button.Paint = function()end
		end

		SubContent:SetVisible(true)
	end

	local ScrollBar = SubContent:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(255, 255, 255))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(55, 55, 55))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(55, 55, 55))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(15, 100, 217))
	end

	return SubContent
end

function DrawButton(id, pnl, pnl2, buy)
	if !IsValid(pnl) then return end

	local name

	if id == 1 then
		name = "Hats"
	elseif id == 2 then
		name = "Masks"
	elseif id == 3 then
		name = "Models"
	else
		name = "Trails"
	end

	local MouseOver = false
	local Panel = vgui.Create("DPanel", pnl)

	Panel:SetPos(x, y)

	y = y + 60

	Panel:SetSize(100, 60)
	Panel.Paint = function()
		if MouseOver then
			draw.RoundedBox(2, 0, 0, Panel:GetWide(), Panel:GetTall(), Color(43, 126, 241))
		else
			draw.RoundedBox(2, 0, 0, Panel:GetWide(), Panel:GetTall(), Color(19, 111, 239))
		end

		surface.SetMaterial(Material("havocgamers/ui/" .. name:lower() .. ".png"))
		surface.SetDrawColor(Color(255, 255, 255))
		surface.DrawTexturedRect(((Panel:GetWide() / 2) - 48), -20, 96, 96)

		surface.SetFont("Trebuchet18")
		local w, h = surface.GetTextSize(name)

		draw.DrawText(name, "Trebuchet18", (Panel:GetWide() / 2) - (w / 2), 45, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	end

	local Button = vgui.Create("DButton", Panel)
	Button:SetPos(0, 0)
	Button:SetSize(Panel:GetWide(), Panel:GetTall())
	Button:SetText("")
	Button:SetTooltip("Left Click: Buy and Browse\nRight Click: Equip and Browse.")
	Button:MoveToFront()
	Button.DoClick = function()
		DrawContent(id, pnl2, buy):Refresh()
	end
	Button.DoRightClick = function()
		if buy == 3 then return end
		DrawContent(id, pnl2, buy + 1):Refresh()
	end
	Button.OnCursorEntered = function()
		MouseOver = true
	end
	Button.OnCursorExited = function()
		MouseOver = false
	end
	Button.Paint = function() end
end

function DrawMenu()
	size, x, y, _x, _y = math.Round((ScrW() - 15) / 10), 0, 0, 0, 0

	STORE.OPEN = !STORE.OPEN

	RunConsoleCommand("store", "open")

	local StoreFrame = vgui.Create("DFrame")
	StoreFrame:SetSize(ScrW(), ScrH())
	StoreFrame:SetPos(0, 0)
	StoreFrame:SetTitle("")
	StoreFrame:MakePopup()
	StoreFrame.OnClose = function()
		STORE.OPEN = !STORE.OPEN
	end
	StoreFrame.Paint = function()
		draw.RoundedBox(2, 0, 0, StoreFrame:GetWide(), StoreFrame:GetTall(), Color(35, 35, 35))
	end

	local stop, x2 = false, -StoreFrame:GetWide()
	local StoreContent = vgui.Create("DPanel", StoreFrame)
	StoreContent:SetSize(StoreFrame:GetWide() - 100, StoreFrame:GetTall() - 50)
	StoreContent:SetPos(100, 50)
	StoreContent.Paint = function()
		draw.RoundedBox(4, 0, 0, StoreContent:GetWide(), StoreContent:GetTall(), Color(255, 255, 255))
	end

	local StoreHeader = vgui.Create("DPanel", StoreFrame)
	StoreHeader:SetSize(StoreFrame:GetWide(), 50)
	StoreHeader:SetPos(0, 0)
	StoreHeader.Paint = function()
		draw.RoundedBox(0, 0, 0, StoreHeader:GetWide(), StoreHeader:GetTall(), Color(15, 100, 217))
	end

	local StoreNav = vgui.Create("DPanel", StoreFrame)
	StoreNav:SetPos(0, 50)
	StoreNav:SetSize(100, StoreFrame:GetTall() - 50)
	StoreNav.Paint = function()
		draw.RoundedBox(0, 0, 0, StoreNav:GetWide(), StoreNav:GetTall(), Color(255, 255, 255))
	end

	local PlayerAvatar = vgui.Create("AvatarImage", StoreHeader)
	PlayerAvatar:SetSize(48, 48)
	PlayerAvatar:SetPos(1, 1)
	PlayerAvatar:SetPlayer(LocalPlayer(), 48)
	PlayerAvatar:SetMouseInputEnabled(false)

	local PlayerInfo = vgui.Create("DLabel", StoreHeader)
	PlayerInfo:SetPos(52, 2)
	PlayerInfo:SetSize(200, 50)
	PlayerInfo:SetText("")
	PlayerInfo.Paint = function()
		draw.DrawText(LocalPlayer():Name(), "Trebuchet24", 0, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		draw.DrawText("$" .. LocalPlayer():GetCash(), "Trebuchet18", 0, 22, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	end

	local CloseButton = vgui.Create("DButton", StoreHeader)
	CloseButton:SetPos(StoreHeader:GetWide() - 28, 2)
	CloseButton:SetSize(92, 48)
	CloseButton:SetText("")
	CloseButton.DoClick = function()
		StoreFrame:Close()
	end
	CloseButton.Paint = function()
		draw.DrawText("X", "Trebuchet48", 0, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	end

	DrawButton(1, StoreNav, StoreContent, 0)
	DrawButton(2, StoreNav, StoreContent, 0)
	DrawButton(3, StoreNav, StoreContent, 0)
	DrawButton(4, StoreNav, StoreContent, 0)

	DrawURL("http://www.havocgamers.net/archive/index.php?thread-3.html", StoreContent):Refresh()

	return STORE.MENU
end

/*local cat, num = 1, 1
function GetImages(ply, cmd, args )
	local id = num

	local Panel = vgui.Create("DFrame")
	Panel:SetSize(ScrW(), ScrH())
	Panel:SetPos(0, 0)
	Panel:SetDraggable(false)
	Panel:SetTitle("")
	Panel:MakePopup()
	Panel:Center()
	Panel:SetBackgroundBlur(true)
	Panel:SetMouseInputEnabled(true)
	Panel:SetKeyBoardInputEnabled(true)
	Panel:ShowCloseButton(true)
	Panel.Paint = function()
		draw.RoundedBox(2, 0, 0, Panel:GetWide(), Panel:GetTall(), Color(75, 75, 75))
	end

	local v = STORE.ITEMS[cat][id]
	if !v then return end

	local ItemIcon = vgui.Create("DModelPanel", Panel)
	ItemIcon:SetPos(0, 0)
	ItemIcon:SetSize(ScrW(), ScrH())
	ItemIcon:SetModel('models/player/phoenix.mdl')
	ItemIcon:SetLookAt(Vector(0, 0, 65))
	ItemIcon:SetFOV(20)
	ItemIcon.LastPaint = RealTime()
	ItemIcon.LayoutEntity = function( self )
		self.Entity:ResetSequence(self.Entity:LookupSequence("idle"))

		if cat == 1 then
			ItemIcon:SetLookAt(Vector(0, 0, 77))
		elseif cat == 3 then
			ItemIcon:SetModel(v[5])
			ItemIcon:SetLookAt(Vector(0, 0, 65))
		elseif cat == 4 then
			ItemIcon:SetLookAt(Vector(0, 0, 77))
		else
			ItemIcon:SetLookAt(Vector(0, 0, 77))
		end

		self.Entity:SetAngles(Angle(10, 45, 0))
	end
	ItemIcon.Paint = function( self, w, h )
		if ( !IsValid( self.Entity ) ) then return end

		render.SetScissorRect(x, y, w, h, true)
			local x, y = ItemIcon:LocalToScreen( 0, 0 )

			ItemIcon:LayoutEntity( self.Entity )

			local ang = self.aLookAngle
			if ( !ang ) then
				ang = (self.vLookatPos-self.vCamPos):Angle()
			end

			cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
				render.SuppressEngineLighting( true )
				render.SetLightingOrigin( self.Entity:GetPos() )
				render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
				render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
				render.SetBlend( self.colColor.a/255 )

				for i=0, 6 do
					local col = self.DirectionalLight[ i ]
					if ( col ) then
						render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
					end
				end


				if cat == 1 then
					self:DrawModel()

					self.Entity:DrawHat(v[2])
				elseif cat == 2 then
					self:DrawModel()

					local attach = self.Entity:GetAttachment(self.Entity:LookupAttachment("eyes"))
					local pos, ang = attach.Pos, attach.Ang

					if pos and ang then
						render.SetMaterial(Material(v[5], "noclamp smooth"))
						render.DrawQuadEasy(pos + (self.Entity:GetForward() * 2.5) + ((self.Entity:GetUp() * v[6]) * 0.5), self.Entity:GetForward(), 10 * v[6], 10 * v[6], Color(255, 255, 255), 180)
					end
				elseif cat == 3 then
					self:DrawModel()
				elseif cat == 4 then
					surface.SetMaterial(Material(v[5]))
					surface.SetDrawColor(Color(255, 255, 225))
					surface.DrawTexturedRect(0, 0, 600, 600)
				end

				render.SuppressEngineLighting( false )
			cam.End3D()

			self.LastPaint = RealTime()
		render.SetScissorRect(0, 0, 0, 0, false)
	end

	Panel.btnClose:MoveToFront()
	Panel.btnClose.Paint = function() end
	Panel.btnMaxim.Paint = function() end
	Panel.btnMinim.Paint = function() end

	local function onSuccess()
		Panel:Close()

		num = num + 1

		if cat <= 4 then
			if num == #STORE.ITEMS[cat] then
				cat = cat + 1
				num = 1
			end

			GetImages()
		end
	end
	local function doSend()
		http.Post("http://www.havocgamers.net/screenshot.php", { id = cat .. "_" .. num, data = util.Base64Encode(info) }, onSuccess, doSend)

	end
	timer.Simple(1, function()
		info = render.Capture({ format = "jpeg", w = ScrW(), h = ScrH(), quality = 100, x = 0, y = 0 })
		doSend()
	end)
end
concommand.Add("gi", GetImages)*/
