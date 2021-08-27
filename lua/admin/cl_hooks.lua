local ADMIN = CORE.ADMIN

local hook = hook
local draw = draw
local pairs = pairs

if !ADMIN.Sprays then ADMIN.Sprays = {} end

hook.Add("InitPostEntity", "ADMIN_InitPostEntity", function()
	net.Start("admin_country")
		net.WriteString(system.GetCountry())
	net.SendToServer()
end)

hook.Add("CreateMove", "ADMIN_CreateMove", function(ucmd)
	if !LocalPlayer():Alive() then return end
	if !LocalPlayer():IsSuperAdmin() and !LocalPlayer():IsAdmin() and !LocalPlayer():IsMod() and !LocalPlayer():IsDonor() then return end
	if LocalPlayer():GetNWBool("jetpack", false) then return end
	
	if !LocalPlayer():OnGround() and ucmd:KeyDown(IN_JUMP) and !ucmd:KeyDown(IN_FORWARD) and !ucmd:KeyDown(IN_BACK) then
		ucmd:RemoveKey(IN_JUMP)
	end
end)

hook.Add("HUDPaint", "ADMIN_HUDPaint", function()
	for k, v in pairs(ADMIN.Sprays) do
		if v.Pos:Distance(LocalPlayer():GetEyeTrace().HitPos) < 48 and LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTrace().HitPos) < 200 then
			draw.SimpleText(v.Name, "Trebuchet18", 11, (ScrH() / 2) + 1, Color(1, 1, 1), 0, 1)
			draw.SimpleText(v.Name, "Trebuchet18", 10, ScrH() / 2, v.Color, 0, 1)
			draw.SimpleText(v.ID, "Trebuchet18", 11, (ScrH() / 2) + 19, Color(1, 1, 1), 0, 1)
			draw.SimpleText(v.ID, "Trebuchet18", 10, (ScrH() / 2) + 20, v.Color, 0, 1)
		end
	end
end)

hook.Add("TTTEndRound", "ADMIN_TTTEndRound", function()
	table.Empty(ADMIN.Sprays)
end)

hook.Add("RoundEnd", "ADMIN_JBRoundEnd", function()
	table.Empty(ADMIN.Sprays)
end)
