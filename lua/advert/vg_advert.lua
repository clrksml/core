local ADVERT = CORE.ADVERT

local PANEL = {}

function PANEL:Init()
	self:SetZPos(-99999)
	self:SetPos(-20, -26)
	self:SetSize(ScrW() + 40, 18)
	self.Paint = function()
		surface.DrawBox(0, 0, self:GetWide(), self:GetTall(), Color(30, 30, 30, 200))
	end
	
	self.Refresh = function()
		self:MoveTo(-20, 0, 2, 0, 1, function()
			for k, v in pairs(ADVERT.History, true) do
				if !v.added then
					
					ADVERT.History[k].added = true
					
					surface.SetFont("qtn")
					local w, h = surface.GetTextSize(v.text)
					
					local DPanel = vgui.Create("DPanel", self)
					DPanel:SetPos(ScrW() + 2, 2)
					DPanel:SetSize(w + 4, h)
					DPanel.Paint = function()
						surface.DrawSentence("qtn", Color(0, 0, 0), -1, 1, v.text)
						surface.DrawSentence("qtn", Color(0, 0, 0), 1, -1, v.text)
						surface.DrawSentence("qtn", v.color, 0, 0, v.text)
					end
					
					DPanel:MoveTo(-w, 0, 30, 0, 1, function()
						self:MoveTo(-20, -26, 2, 0, 1)
					end)
				end
			end
		end)
	end
end

function PANEL:Hide()
	self:SetPos(-20, -26)
end

vgui.Register("Adverts", PANEL, "DPanel")