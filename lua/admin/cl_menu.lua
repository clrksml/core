local ADMIN = CORE.ADMIN

local function DrawOptions(ply, cmd, pnl, pnl2)
	local DScrollPanel = vgui.Create("DScrollPanel", pnl)
	DScrollPanel:SetPos(128, 0)
	DScrollPanel:SetSize(pnl:GetWide() - 128, pnl:GetTall() - 0)
	DScrollPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, DScrollPanel:GetWide(), DScrollPanel:GetTall(), Color(255, 255, 255))
		draw.SimpleText(cmd, "Trebuchet24", 2, 0, Color(255, 255, 255), 0, 5)
	end
	
	local ScrollBar = DScrollPanel:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(160, 197, 248))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(32, 119, 240))
	end
	
	local args, _args = string.Explode(" ", ADMIN.Commands[cmd][1]), {}
	DScrollPanel.Refresh = function()
		DScrollPanel._x, DScrollPanel._y = 0, 0
		
		for k, v in SortedPairs(args) do
			if v == "[player]" then
				_args[k] = ply:UniqueID()
			end
			
			if v == "[map]" then
				local DPanel = vgui.Create("DPanel", DScrollPanel)
				DPanel:SetPos(1, DScrollPanel._y)
				DPanel:SetSize(DScrollPanel:GetWide() / 2, 25)
				DPanel.Paint = function()
					if GAMEMODE.MapImage[v[1]] then
						surface.DrawImage(0, 0, size, size, GAMEMODE.MapImage[v[1]])
					else
						surface.DrawImage(0, 0, size, size, "gui/dupe_bg.png")
					end
					
					surface.SetFont(font)
					
					local _w, _h = surface.GetTextSize(v[3] .. " / " .. #player.GetAll())
					
					if LocalPlayer().VoteMapSelected == k then
						surface.DrawBox(0, 0, size, 18, Color(1, 175, 1, 200))
						surface.DrawBox(0, size - 18, size, 18, Color(1, 175, 1, 200))
					else
						surface.DrawBox(0, 0, size, 18, Color(1, 1, 1, 200))
						surface.DrawBox(0, size - 18, size, 18, Color(1, 1, 1, 200))
					end
					
					surface.DrawSentence(font, color_white, size - _w - 4, 0, v[3] .. " / " .. #player.GetAll())
					
					if size < 256 then
						surface.DrawSentence(font, color_white, 2, size - _h - 2, v[1])
					else
						surface.DrawSentence(font, color_white, 2, size - _h, v[1])
					end
				end
				
				DScrollPanel._x, DScrollPanel._y = DScrollPanel._x, DScrollPanel._y + DPanel:GetTall()
			end
			
			if v == "[string]" or v == "[reason]" or v == "[command]" or v == "[rank]" then
				local DTextEntry = vgui.Create("DTextEntry", DScrollPanel)
				DTextEntry:SetPos(1, DScrollPanel._y)
				DTextEntry:SetSize(DScrollPanel:GetWide() / 2, 25)
				DTextEntry:SetText(v)
				DTextEntry.OnTextChanged = function()
					_args[k] = tostring(DTextEntry:GetText())
				end
				
				DScrollPanel._y = DScrollPanel._y + DTextEntry:GetTall()
			end
			
			if v == "[number]" or v == "[amount]" or v == "[length]" or v == "[time]" then
				local DSlider = vgui.Create("Slider", DScrollPanel)
				DSlider:SetPos(1, DScrollPanel._y)
				DSlider:SetSize(DScrollPanel:GetWide() - 22, 35)
				DSlider:SetValue(1)
				DSlider:SetMin(0)
				DSlider:SetMax(100)
				DSlider:SetDecimals(0)
				DSlider:SetDark(true)
				DSlider.PaintOver = function()
					surface.SetFont("Default")
					surface.SetTextColor(Color(65, 65, 65))
					surface.SetTextPos(0, 0)
					surface.DrawText(v)
				end
				DSlider.OnValueChanged = function()
					_args[k] = math.Round(tonumber(DSlider:GetValue()))
				end
				
				DScrollPanel._y = DScrollPanel._y + DSlider:GetTall()
			end
		end
		
		local SButton = vgui.Create("DButton", DScrollPanel)
		SButton:SetPos(0, DScrollPanel._y)
		SButton:SetText("Submit")
		SButton:SizeToContents()
		SButton:SetSize(SButton:GetWide() + 4, SButton:GetTall() + 2)
		SButton:MoveToFront()
		SButton.DoClick = function()
			local str = "!" .. cmd
			
			for k, v in pairs(_args) do
				str = str .. " " .. v
			end
			
			str = string.TrimRight(str, " ")
			
			LocalPlayer():ConCommand("say " .. str)
		end
		
		local CButton = vgui.Create("DButton", DScrollPanel)
		CButton:SetPos(0, DScrollPanel._y)
		CButton:SetText("Cancel")
		CButton:SetPos(DScrollPanel:GetWide() - CButton:GetWide(), DScrollPanel._y)
		CButton:SizeToContents()
		CButton:SetSize(CButton:GetWide() + 4, CButton:GetTall() + 2)
		CButton:MoveToFront()
		CButton.DoClick = function()
			DScrollPanel:Remove()
		end
		
		DScrollPanel._y = DScrollPanel._y + CButton:GetTall()
	end
	
	pnl.btnClose:MoveToFront()
	pnl.r = DScrollPanel
	
	return DScrollPanel
end

local function DrawSelection(ply, pnl, pnl2)
	pnl2:Remove()
	
	local DScrollPanel = vgui.Create("DScrollPanel", pnl)
	DScrollPanel:SetPos(128, 0)
	DScrollPanel:SetSize(pnl:GetWide() - 128, pnl:GetTall() - 0)
	DScrollPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, DScrollPanel:GetWide(), DScrollPanel:GetTall(), Color(45, 45, 45))
	end
	
	local ScrollBar = DScrollPanel:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(160, 197, 248))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(32, 119, 240))
	end
	
	DScrollPanel.Refresh = function()
		DScrollPanel._y = 0
		
		for k, v in SortedPairs(CORE.ADMIN.Commands) do
			if string.find(v[1], "player") then
				if LocalPlayer():GetLevel() >= v[3] then
					local args = string.Explode(" ", v[1])
					
					if #args > 1 then
						k = string.Replace(k, ":", "")
						
						local DPanel = vgui.Create("DPanel", DScrollPanel)
						DPanel:SetPos(1, DScrollPanel._y - 1)
						DPanel:SetSize(DScrollPanel:GetWide() - 22, 48)
						DPanel.Paint = function()
							draw.RoundedBox(0, 0, 0, DPanel:GetWide(), DPanel:GetTall(), Color(255, 255, 255))
							
							surface.DrawSentence("Trebuchet48", color_black, 0, 0, k)
						end
						
						local Button = vgui.Create("DButton", DPanel)
						Button:SetPos(0, 0)
						Button:SetSize(DPanel:GetWide(), DPanel:GetTall())
						Button:SetText("")
						Button:MoveToFront()
						Button.Paint = function() end
						Button.DoClick = function()
							DrawOptions(ply, k, pnl, DScrollPanel):Refresh()
							DScrollPanel:Remove()
						end
						
						DScrollPanel._y = DScrollPanel._y + 49
					end
				end
			end
		end
	end
	
	pnl.btnClose:MoveToFront()
	pnl.r = DScrollPanel
	
	return DScrollPanel
end

local function DrawPlayers(pnl)
	local DScrollPanel = vgui.Create("DScrollPanel", pnl)
	DScrollPanel:SetPos(128, 0)
	DScrollPanel:SetSize(pnl:GetWide() - 128, pnl:GetTall() - 0)
	DScrollPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, DScrollPanel:GetWide(), DScrollPanel:GetTall(), Color(50, 130, 241))
	end
	
	local ScrollBar = DScrollPanel:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(160, 197, 248))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(32, 119, 240))
	end
	
	DScrollPanel.Refresh = function()
		DScrollPanel._y = 0
		
		for _, ply in pairs(player.GetAll()) do
			local DPlayer = vgui.Create("DPanel", DScrollPanel)
			DPlayer:SetPos(1, DScrollPanel._y - 1)
			
			if #player.GetAll() > 7 then
				DPlayer:SetSize(DScrollPanel:GetWide() - 22, 64)
			else
				DPlayer:SetSize(DScrollPanel:GetWide(), 64)
			end
			
			DPlayer.Paint = function()
				draw.RoundedBox(0, 0, 0, DPlayer:GetWide(), DPlayer:GetTall(), ply:GetUserColor())
				
				surface.DrawSentence("Trebuchet48", color_black, 67, 9, ply:Nick())
				surface.DrawSentence("Trebuchet48", color_white, 66, 8, ply:Nick())
			end
			
			local AvatarImage = vgui.Create("AvatarImage", DPlayer)
			AvatarImage:SetPos(0, 0)
			AvatarImage:SetSize(64, 64)
			AvatarImage:SetPlayer(ply)
			
			local Button = vgui.Create("DButton", DPlayer)
			Button:SetPos(0, 0)
			Button:SetSize(DPlayer:GetWide(), DPlayer:GetTall())
			Button:SetText("")
			Button:MoveToFront()
			Button.Paint = function() end
			Button.DoClick = function()
				DrawSelection(ply, pnl, DScrollPanel):Refresh()
				DScrollPanel:Remove()
			end
			
			DScrollPanel._y = DScrollPanel._y + 65
		end
		
		for sid, ply in pairs(ADMIN.Players) do
			local DPlayer = vgui.Create("DPanel", DScrollPanel)
			DPlayer:SetPos(1, DScrollPanel._y - 1)
			
			if #player.GetAll() > 7 then
				DPlayer:SetSize(DScrollPanel:GetWide() - 22, 64)
			else
				DPlayer:SetSize(DScrollPanel:GetWide(), 64)
			end
			
			DPlayer.Paint = function()
				draw.RoundedBox(0, 0, 0, DPlayer:GetWide(), DPlayer:GetTall(), ply.GetUserColor)
				
				surface.DrawSentence("Trebuchet48", color_black, 67, 9, ply.Nick)
				surface.DrawSentence("Trebuchet48", color_white, 66, 8, ply.Nick)
				
				surface.SetFont("Trebuchet24")
				local w, h = surface.GetTextSize("disconnected")
				surface.DrawSentence("Trebuchet24", color_white, DPlayer:GetWide() - (w + 2), (DPlayer:GetTall() / 2) - h, "disconnected")
			end
			
			local AvatarImage = vgui.Create("AvatarImage", DPlayer)
			AvatarImage:SetPos(0, 0)
			AvatarImage:SetSize(64, 64)
			AvatarImage:SetPlayer(sid)
			
			local Button = vgui.Create("DButton", DPlayer)
			Button:SetPos(0, 0)
			Button:SetSize(DPlayer:GetWide(), DPlayer:GetTall())
			Button:SetText("")
			Button:MoveToFront()
			Button.Paint = function() end
			Button.DoClick = function()
				DrawSelection(ply, pnl, DScrollPanel):Refresh()
				DScrollPanel:Remove()
			end
			
			DScrollPanel._y = DScrollPanel._y + 65
		end
	end
	
	pnl.btnClose:MoveToFront()
	pnl.r = DScrollPanel
	
	return DScrollPanel
end

local function DrawGroups(pnl)
	local DScrollPanel = vgui.Create("DScrollPanel", pnl)
	DScrollPanel:SetPos(128, 0)
	DScrollPanel:SetSize(pnl:GetWide() - 128, pnl:GetTall() - 0)
	DScrollPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, DScrollPanel:GetWide(), DScrollPanel:GetTall(), Color(50, 130, 241))
	end
	
	local ScrollBar = DScrollPanel:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(160, 197, 248))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(32, 119, 240))
	end
	
	DScrollPanel.Refresh = function()
		DScrollPanel._y = 0
		
		local DCategoryList = vgui.Create("DCategoryList", DScrollPanel)
		DCategoryList:SetPos(DScrollPanel._x, DScrollPanel._y)
		DCategoryList:SetSize(DScrollPanel:GetWide(), DScrollPanel:GetTall())
		
		for key, val in pairs(ADMIN.Groups) do
			local DCollapsibleCategory = DCategoryList:Add(key)
			DCollapsibleCategory:SetExpanded(0)
			DCollapsibleCategory.Header.Paint = function()
				draw.RoundedBox(0, 0, 0, DCollapsibleCategory.Header:GetWide(), DCollapsibleCategory.Header:GetTall(), Color(32, 119, 240))
			end
			DCollapsibleCategory._x = 0
			DCollapsibleCategory._y = 20
			
			//for i=1,10 do
				for _, sid in pairs(val) do
					if DCollapsibleCategory._x >= 640 then
						DCollapsibleCategory._x = 0
						DCollapsibleCategory._y = DCollapsibleCategory._y + 80
					end
					
					local DPlayer = vgui.Create("DPanel", DCollapsibleCategory)
					DPlayer:SetPos(DCollapsibleCategory._x, DCollapsibleCategory._y)
					DPlayer:SetSize(DCategoryList:GetWide(), 79)
					DPlayer.Paint = function()
						draw.RoundedBox(0, 0, 0, DPlayer:GetWide(), DPlayer:GetTall(), color_white)
					end
					
					local AvatarImage = vgui.Create("AvatarImage", DPlayer)
					AvatarImage:SetPos(0, 0)
					AvatarImage:SetSize(79, 79)
					AvatarImage:SetSteamID(sid, 79)
					
					if LocalPlayer():GetLevel() == 4 then
						local Button = vgui.Create("DButton", DPlayer)
						Button:SetPos(0, 0)
						Button:SetSize(DPlayer:GetWide(), DPlayer:GetTall())
						Button:SetText("")
						Button:MoveToFront()
						Button.Paint = function() end
						Button.DoClick = function()
							local menu = DermaMenu()
							
							menu:AddOption("Remove Rank", function()
								print("say", "!removerank ", sid)
								RunConsoleCommand("say", "!removerank ", sid)
							end)
							
							menu:AddSpacer()
							
							local submenu = menu:AddSubMenu("Set Rank")
							
							for _key, _val in pairs(ADMIN.Groups) do
								submenu:AddOption(_key, function()
									print("say", "!setrank ", sid)
									RunConsoleCommand("say", "!setrank ", sid)
								end)
							end
							
							menu:Open()
						end
					end
					
					DCollapsibleCategory._x = DCollapsibleCategory._x + 80
				end
			//end
		end
	end
	
	pnl.btnClose:MoveToFront()
	pnl.r = DScrollPanel
	
	return DScrollPanel
end

local function DrawBans(pnl)
	local DScrollPanel = vgui.Create("DScrollPanel", pnl)
	DScrollPanel:SetPos(128, 0)
	DScrollPanel:SetSize(pnl:GetWide() - 128, pnl:GetTall() - 0)
	DScrollPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, DScrollPanel:GetWide(), DScrollPanel:GetTall(), Color(50, 130, 241))
	end
	
	local ScrollBar = DScrollPanel:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(160, 197, 248))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(32, 119, 240))
	end
	
	DScrollPanel.Refresh = function()
		DScrollPanel._y = 0
		
		for sid, val in pairs(ADMIN.Bans) do
			local DPlayer = vgui.Create("DPanel", DScrollPanel)
			DPlayer:SetPos(1, DScrollPanel._y - 1)
			
			if #ADMIN.Bans > 7 then
				DPlayer:SetSize(DScrollPanel:GetWide() - 22, 64)
			else
				DPlayer:SetSize(DScrollPanel:GetWide(), 64)
			end
			
			DPlayer.Paint = function()
				draw.RoundedBox(0, 0, 0, DPlayer:GetWide(), DPlayer:GetTall(), color_white)
				
				surface.DrawSentence("DermaDefault", Color(45, 45, 45), 68, 16, val.name)
				
				surface.SetFont("DermaDefault")
				
				if val.length != 0 then
					surface.DrawSentence("DermaDefault", Color(45, 45, 45), 68 + 192, 16, "Permanent")
				else
					surface.DrawSentence("DermaDefault", Color(45, 45, 45), 68 + 192, 16, os.date("%I:%M%p - %m/%d/%Y", val.unban))
				end
				
				surface.DrawSentence("DermaDefault", Color(45, 45, 45), 68 + 192 + 192, 16, val.reason)
			end
			
			local AvatarImage = vgui.Create("AvatarImage", DPlayer)
			AvatarImage:SetPos(0, 0)
			AvatarImage:SetSize(64, 64)
			AvatarImage:SetSteamID(sid)
			
			DScrollPanel._y = DScrollPanel._y + 65
		end
	end
	
	pnl.btnClose:MoveToFront()
	pnl.r = DScrollPanel
	
	return DScrollPanel
end

local function DrawSettings(pnl)
	local DScrollPanel = vgui.Create("DScrollPanel", pnl)
	DScrollPanel:SetPos(128, 0)
	DScrollPanel:SetSize(pnl:GetWide() - 128, pnl:GetTall() - 0)
	DScrollPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, DScrollPanel:GetWide(), DScrollPanel:GetTall(), Color(50, 130, 241))
	end
	
	local ScrollBar = DScrollPanel:GetVBar()
	ScrollBar.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar:GetWide(), ScrollBar:GetTall(), Color(160, 197, 248))
	end
	ScrollBar.btnUp.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnUp:GetWide(), ScrollBar.btnUp:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnDown.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnDown:GetWide(), ScrollBar.btnDown:GetTall(), Color(50, 130, 241))
	end
	ScrollBar.btnGrip.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrollBar.btnGrip:GetWide(), ScrollBar.btnGrip:GetTall(), Color(32, 119, 240))
	end
	
	DScrollPanel.Refresh = function()
		DScrollPanel._y = 0
		
		local convars = { "ttt_preptime_seconds", "ttt_firstpreptime", "ttt_posttime_seconds", "ttt_haste", "ttt_sherlock_mode", "ttt_haste_starting_minutes", "ttt_haste_minutes_per_death", "ttt_roundtime_minutes", "ttt_round_limit", "ttt_time_limit_minutes", "ttt_always_use_mapcycle", "ttt_traitor_pct", "ttt_traitor_max", "ttt_detective_pct", "ttt_detective_max", "ttt_detective_min_players", "ttt_detective_karma_min", "ttt_killer_dna_range", "ttt_killer_dna_basetime", "ttt_voice_drain", "ttt_voice_drain_normal", "ttt_voice_drain_admin", "ttt_voice_drain_recharge", "ttt_minimum_players", "ttt_postround_dm", "ttt_dyingshot", "ttt_no_nade_throw_during_prep", "ttt_weapon_carrying", "ttt_weapon_carrying_range", "ttt_teleport_telefrags", "ttt_ragdoll_pinning", "ttt_ragdoll_pinning_innocents", "ttt_karma", "ttt_karma_strict", "ttt_karma_starting", "ttt_karma_max", "ttt_karma_ratio", "ttt_karma_kill_penalty", "ttt_karma_round_increment", "ttt_karma_clean_bonus", "ttt_karma_traitordmg_ratio", "ttt_karma_traitorkill_bonus", "ttt_karma_low_autokick", "ttt_karma_low_amount", "ttt_karma_low_ban", "ttt_karma_low_ban_minutes", "ttt_karma_debugspam", "ttt_karma_clean_half", "ttt_use_weapon_spawn_scripts", "ttt_credits_starting", "ttt_credits_award_pct", "ttt_credits_award_size", "ttt_credits_award_repeat", "ttt_credits_detectivekill", "ttt_det_credits_starting", "ttt_det_credits_traitorkill", "ttt_det_credits_traitordead", "ttt_spec_prop_control", "ttt_spec_prop_base", "ttt_spec_prop_maxpenalty", "ttt_spec_prop_maxbonus", "ttt_spec_prop_force", "ttt_spec_prop_rechargetime", "ttt_idle_limit", "ttt_namechange_kick", "ttt_namechange_bantime", "ttt_ban_type", "ttt_detective_hats", "ttt_ragdoll_collide", "ttt_sherlock_mode" }
		
		for k, v in pairs(convars) do
			if ConVarExists(v) then
				if string.IsNumber(GetConVar(v):GetDefault()) or GetConVar(v):GetFloat() then
					local DSlider = vgui.Create("Slider", DScrollPanel)
					DSlider:SetPos(1, DScrollPanel._y)
					DSlider:SetSize(DScrollPanel:GetWide() - 22, 35)
					DSlider:SetValue(GetConVar(v):GetInt() or GetConVar(v):GetFloat())
					DSlider:SetMin(0)
					DSlider:SetMax(1000)
					
					if string.find(GetConVar(v):GetFloat(), ".") then
						DSlider:SetDecimals(1)
						DSlider:SetValue(GetConVar(v):GetFloat())
						DSlider:SetMax((GetConVar(v):GetFloat() + 1) * 2)
					else
						DSlider:SetDecimals(0)
						DSlider:SetValue(GetConVar(v):GetInt())
						DSlider:SetMax((GetConVar(v):GetInt() + 1) * 2)
					end
					
					DSlider:SetDark(true)
					DSlider.PaintOver = function()
						surface.SetFont("Default")
						surface.SetTextColor(Color(65, 65, 65))
						surface.SetTextPos(0, 0)
						surface.DrawText(GetConVar(v):GetName() .. " " .. (GetConVar(v):GetInt() or 0 ))
					end
					
					DScrollPanel._y = DScrollPanel._y + DSlider:GetTall()
				else
					local DTextEntry = vgui.Create("DTextEntry", DScrollPanel)
					DTextEntry:SetPos(1, DScrollPanel._y)
					DTextEntry:SetSize(DScrollPanel:GetWide() / 2, 25)
					DTextEntry:SetText(GetConVar(v):GetName() .. " " .. (GetConVar(v):GetString() or ""))
					
					DScrollPanel._y = DScrollPanel._y + DTextEntry:GetTall()
				end
			end
		end
	end
	
	pnl.btnClose:MoveToFront()
	pnl.r = DScrollPanel
	
	return DScrollPanel
end

local function DrawButton(name, pnl, pnl2)
	if !IsValid(pnl) then return end
	
	local MouseOver = false
	local Panel = vgui.Create("DPanel", pnl)
	Panel:SetPos(0, pnl._y)
	Panel:SetSize(128, 128)
	Panel.Paint = function()
		if MouseOver then
			draw.RoundedBox(2, 0, 0, Panel:GetWide(), Panel:GetTall(), Color(43, 126, 241))
		else
			draw.RoundedBox(2, 0, 0, Panel:GetWide(), Panel:GetTall(), Color(19, 111, 239))
		end
		
		surface.SetMaterial(Material("havocgamers/ui/" .. name:lower() .. ".png"))
		surface.SetDrawColor(Color(255, 255, 255))
		surface.DrawTexturedRect(1, 0, 126, 126)
		
		surface.SetFont("Trebuchet18")
		local w, h = surface.GetTextSize(name)
		
		draw.DrawText(name, "Trebuchet18", ((Panel:GetWide() / 2) - (w / 2)), (Panel:GetTall() - h), Color(255, 255, 255), TEXT_ALIGN_LEFT)
	end
	
	local Button = vgui.Create("DButton", Panel)
	Button:SetPos(0, 0)
	Button:SetSize(Panel:GetWide(), Panel:GetTall())
	Button:SetText("")
	Button:MoveToFront()
	Button.DoClick = function()
		if pnl.r and pnl.r:IsValid() then
			//pnl:Remove()
		end
		
		pnl2(pnl):Refresh()
	end
	Button.DoRightClick = function()
	end
	Button.OnCursorEntered = function()
		MouseOver = true
	end
	Button.OnCursorExited = function()
		MouseOver = false
	end
	Button.Paint = function() end
	
	pnl._y = pnl._y + Panel:GetTall()
end

local function CreateMenu()
	if LocalPlayer():GetLevel() < 2 then return end
	
	local DFrame = vgui.Create("DFrame")
	DFrame:SetSize(768, 512)
	DFrame:SetTitle("")
	DFrame:SetDraggable(false)
	DFrame:SetBackgroundBlur(true)
	DFrame:ShowCloseButton(false)
	DFrame:MakePopup()
	DFrame:Center()
	DFrame.btnClose:SetVisible(true)
	DFrame.btnClose:MoveToFront()
	DFrame.btnClose.Paint = function()
		draw.RoundedBox(0, 0, 1, DFrame.btnClose:GetWide(), 20, Color(45, 45, 45))
		draw.SimpleText("X", "Trebuchet24", 10, 0, Color(255, 255, 255), 0, 5)
	end
	DFrame.Paint = function()
		draw.RoundedBox(0, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(15, 100, 217))
	end
	DFrame.OnClose = function()
		DFrame:Remove()
	end
	
	DFrame._y = 0
	DFrame.r = false
	
	DrawButton("Players", DFrame, DrawPlayers)
	DrawButton("Groups", DFrame, DrawGroups)
	DrawButton("Bans", DFrame, DrawBans)
	DrawButton("Settings", DFrame, DrawSettings)
end
concommand.Add("cm", CreateMenu)
