local STORE = CORE.STORE

hook.Add("Think", "STORE_Think", function()
	if !STORE.HATS then
		STORE.HATS = {}
	end
	
	if !STORE.MASKS then
		STORE.MASKS = {}
	end
end)

hook.Add("PostDrawTranslucentRenderables", "STORE_PostDrawTranslucentRenderables", function()
	for _, ply in pairs(player.GetAll()) do
		if !IsValid(ply) or ply:Team() == TEAM_SPECTATOR or !ply:Alive() or ply == self then continue end
		
		if STORE.HATS and STORE.HATS[ply:EntIndex()] then
			ply:DrawHat(tonumber(ply:GetNWFloat("hat", 1)))
		end
	end
end)

hook.Add("Tick", "STORE_Tick", function()
	for _, ply in pairs(player.GetAll()) do
		if !IsValid(ply) or ply:Team() == TEAM_SPECTATOR or !ply:Alive() or ply == self then continue end
		
		if STORE.HATS and STORE.HATS[ply:EntIndex()] then
			ply:DrawHat(tonumber(ply:GetNWFloat("hat", 1)))
		end
	end
	
	STORE.FPS = 1 / FrameTime()
end)

hook.Add("PlayerBindPress", "STORE_PlayerBindPress", function(ply, bind, press)
	if bind:find("gm_showspare1") then
		if !STORE.OPEN then
			DrawMenu()
		end
	end
end)

hook.Add("PostPlayerDraw", "STORE_PostPlayerDraw", function( ply )
	if !IsValid(ply) or ply:Team() == TEAM_SPECTATOR or !ply:Alive() or ply == self then return end
	
	if STORE.HATS and STORE.HATS[ply:EntIndex()] then
		ply:DrawHat(tonumber(ply:GetNWFloat("hat", 1)))
	end
	
	if STORE.MASKS and STORE.MASKS[ply:EntIndex()] then
		local item = STORE.ITEMS[2][tonumber(ply:GetNWFloat("mask", 1))]
		local attach = ply:GetAttachment(ply:LookupAttachment("eyes"))
		local pos, ang = attach.Pos, attach.Ang
		
		if !pos or !ang then return end
		
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)
		
		cam.Start3D2D(pos - (ang:Forward() * (5 * item[6])) + (ang:Right() * (-5 * item[6])) + (ang:Up() * 2.5), ang,item[6])
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material(item[5], "noclamp smooth"))
			surface.DrawTexturedRect(0, 0, 10, 10)
		cam.End3D2D()
	end
end)
