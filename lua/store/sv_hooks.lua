local STORE = CORE.STORE

hook.Add("PlayerInitialSpawn", "STORE_PlayerInitialSpawn", function(ply)
	ply:LoadStoreData()
end)

hook.Add("PlayerDisconnected", "STORE_PlayerDisconnected", function(ply)
	ply:SaveStoreData()
end)

hook.Add("ShutDown", "STORE_ShutDown", function()
	for _, ply in pairs(player.GetAll()) do
		ply:SaveStoreData()
	end
end)

hook.Add("TTTBeginRound", "STORE_TTTBeginRound", function( win )
	for k, ply in pairs(player.GetAll()) do
		if ply:Team() == TEAM_TERROR then
			ply:AddCash(5)
			
			CORE.ADMIN:Notify(ply, Color(43, 180, 44), "+5 dollars for round start.")
			
			for i=1,4 do
				if ply.EquipItems[i] then
					for k, v in pairs(ply.EquipItems[i]) do
						ply:EquipItem(i, v)
					end
				end
			end
		end
		
		if ply:GetNWString("model", ply:GetModel()) then
			ply:SetModel(ply:GetNWString("model", ply:GetModel()))
		end
	end
end)

hook.Add("DoPlayerDeath", "STORE_DoPlayerDeath", function( ply, att )

	if game:IsTTT() then
		if GAMEMODE.round_state != ROUND_ACTIVE then return end
		
		if IsValid(ply) and IsValid(att) then
			if att:IsPlayer() or att:IsBot() then
				if att == ply then return end
				if ply:GetRole() == ROLE_TRAITOR then
					if att:GetRole() == ROLE_INNOCENT then
						att:AddCash(10)
						
						CORE.ADMIN:Notify(att, Color(43, 180, 44), "+10 dollars for killing a traitor.")
					elseif att:GetRole() == ROLE_DETECTIVE then
						att:AddCash(20)
						
						CORE.ADMIN:Notify(att, Color(43, 180, 44), "+20 dollars for killing a traitor.")
					else
						att:TakeCash(10)
						
						CORE.ADMIN:Notify(att, Color(43, 180, 44), "-10 dollars for killing a traitor.")
					end
					
				end
				
				if ply:GetRole() == ROLE_DETECTIVE then
					if att:GetRole() == ROLE_TRAITOR then
						att:AddCash(20)
						
						CORE.ADMIN:Notify(att, Color(43, 180, 44), "+20 dollars for killing a detective.")
					else
						att:TakeCash(10)
						
						CORE.ADMIN:Notify(att, Color(43, 180, 44), "-10 dollars for killing a detective.")
					end
				end
				
				if ply:GetRole() == ROLE_INNOCENT  then
					if att:GetRole() == ROLE_TRAITOR then
						att:AddCash(10)
						
						CORE.ADMIN:Notify(att, Color(43, 180, 44), "+10 dollars for killing an innocent.")
					else
						att:TakeCash(10)
						
						CORE.ADMIN:Notify(att, Color(43, 180, 44), "-10 dollars for killing an innocent.")
					end
				end
			end
		end
	elseif game:IsJB() then
		if IsValid(ply) and IsValid(att) then
			if att:IsPlayer() or att:IsBot() then
				if ply:Team() == TEAM_INMATE then
					att:AddCash(10)
					
					CORE.ADMIN:Notify(att, Color(43, 180, 44), "+10 dollars for killing a inmate.")
				else
					att:AddCash(20)
					
					CORE.ADMIN:Notify(att, Color(43, 180, 44), "+20 dollars for killing a guard.")
				end
			end
		end
	end
end)

hook.Add("TTTEndRound", "STORE_TTTEndRound", function( win )
	local rounds = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
	
	for k, ply in pairs(player.GetAll()) do
		if rounds == 0 then
			ply:SaveStoreData()
		end
		
		if win == WIN_INNOCENT or win == WIN_TIMELIMIT then
			if ply:Alive() then
				if ply:GetRole() == ROLE_INNOCENT then
					ply:AddCash(10)
					
					CORE.ADMIN:Notify(ply, Color(43, 180, 44), "+10 dollars for round win and round survival.")
				elseif ply:GetRole() == ROLE_DETECTIVE then
					ply:AddCash(20)
					
					CORE.ADMIN:Notify(ply, Color(43, 180, 44), "+20 dollars for detective role, round win, and round survival.")
				end
			else
				if ply:GetRole() == ROLE_INNOCENT then
					ply:AddCash(5)
					
					CORE.ADMIN:Notify(ply, Color(43, 180, 44), "+5 dollars for round win.")
				elseif ply:GetRole() == ROLE_DETECTIVE then
					ply:AddCash(10)
					
					CORE.ADMIN:Notify(ply, Color(43, 180, 44), "+10 dollars for detective role and round win.")
				end
			end
		end
		
		if win == WIN_TRAITOR then
			if ply:GetRole() == ROLE_TRAITOR then
				if ply:Alive() then
					ply:AddCash(20)
					
					CORE.ADMIN:Notify(ply, Color(43, 180, 44), "+20 dollars for traitor role, round win, and round survival.")
				else
					ply:AddCash(10)
					
					CORE.ADMIN:Notify(ply, Color(43, 180, 44), "+10 dollars for traitor role and round win.")
				end
			end
		end
	end
end)
