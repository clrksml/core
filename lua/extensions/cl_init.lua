
function surface.DrawSentence(f, c, x, y, t)
	if !t then t = "error" end
	
	surface.SetFont(f)
	surface.SetTextColor(color_black)
	surface.SetTextPos(x + 1, y + 1)
	surface.DrawText(t)
	
	surface.SetFont(f)
	surface.SetTextColor(c)
	surface.SetTextPos(x, y)
	surface.DrawText(t)
end

function surface.DrawBox(x, y, w, h, c)
	surface.SetDrawColor(Color(c.r, c.g, c.b, c.a or 255))
	surface.DrawRect(x, y, w, h)
end

function surface.DrawRoundBox(r, x, y, w, h, c)
	draw.RoundedBoxEx(r, x, y, w, h, Color(c.r, c.g, c.b, c.a or 255), true, true, true, true)
end

function surface.DrawImage(x, y, w, h, m)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(Material(m, "noclamp smooth"))
	surface.DrawTexturedRect(x, y, w, h)
end

function surface.DrawGradient(x, y, w, h, n, c, c2)
	local mat = { [1] = Material("gui/gradient_down"), [2] = Material("gui/gradient_up") }
	
	surface.DrawBox(x, y, w, h, Color(c.r, c.g, c.b))
	
	surface.SetDrawColor(c2)
	surface.SetMaterial(mat[n])
	surface.DrawTexturedRect(x, y + ((h - 2) / 2), w, ((h + 2) / 2))
	
	if n == 1 then n = 2 else n = 1 end
	
	surface.SetDrawColor(c)
	surface.SetMaterial(mat[n])
	surface.DrawTexturedRect(x, y, w, ((h - 2) / 2))
end

function gui.OpenURL(url, bool)
	local DFrame = vgui.Create("DFrame")
	DFrame:SetPos(0, 0)
	DFrame:SetSize(ScrW(), ScrH())
	DFrame:SetTitle(url)
	DFrame:SetSizable(false)
	DFrame:SetDraggable(false)
	DFrame:SetMouseInputEnabled(true)
	DFrame:SetKeyBoardInputEnabled(true)
	DFrame:MakePopup()
	DFrame.btnMaxim.Paint = function() end
	DFrame.btnMinim.Paint = function() end
	
	if !bool then
		DFrame.btnClose:MoveToFront()
	else
		DFrame.btnClose.Paint = function() end
	end
	
	local DHTML = vgui.Create("DHTML", DFrame)
	DHTML:SetPos(0, 25)
	DHTML:SetSize(DFrame:GetWide(), DFrame:GetTall() - 25)
	DHTML.ConsoleMessage = function() end
	DHTML:OpenURL(tostring(url))
end
