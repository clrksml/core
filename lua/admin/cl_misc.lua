local PANEL = _G['VoiceNotify']

function PANEL:Setup( ply )
	if !IsValid(ply) then return end
	
	self.ply = ply
	self.LabelName:SetText(ply:Nick())
	
	if ply:IsDisguised() then
		self.Avatar:SetSteamID(ply:GetNWString("fakeavatar", ply:SteamID64()), 32)
	else
		self.Avatar:SetPlayer(ply)
	end
	
	self.Color = team.GetColor(ply:Team())
	self:InvalidateLayout()
end
