
if !CORE then
	CORE = {}
	CORE.QueuedFiles = {}
end

if SERVER then
	hook.Add("Think", "CORE_Think", function()
		if !CORE.ConvarLoaded and game:IsTTT() then
			local convars = {
				"ttt_preptime_seconds 25",
				"ttt_firstpreptime 30",
				"ttt_posttime_seconds 25",
				"ttt_haste 1",
				"ttt_sherlock_mode 1",
				"ttt_haste_starting_minutes 3",
				"ttt_haste_minutes_per_death 1",
				"ttt_roundtime_minutes 6",
				"ttt_round_limit 10",
				"ttt_time_limit_minutes 999",
				"ttt_always_use_mapcycle 0",
				"ttt_traitor_pct 0.25",
				"ttt_traitor_max 6",
				"ttt_detective_pct 0.13",
				"ttt_detective_max 3",
				"ttt_detective_min_players 7",
				"ttt_detective_karma_min 650",
				"ttt_killer_dna_range 550",
				"ttt_killer_dna_basetime 120",
				"ttt_voice_drain 0",
				"ttt_voice_drain_normal 0.15",
				"ttt_voice_drain_admin 0",
				"ttt_voice_drain_recharge 0.05",
				"ttt_minimum_players 2",
				"ttt_postround_dm 1",
				"ttt_dyingshot 0",
				"ttt_no_nade_throw_during_prep 1",
				"ttt_weapon_carrying 1",
				"ttt_weapon_carrying_range 50",
				"ttt_teleport_telefrags 0",
				"ttt_ragdoll_pinning 1",
				"ttt_ragdoll_pinning_innocents 0",
				"ttt_karma 1",
				"ttt_karma_strict 1",
				"ttt_karma_starting 1000",
				"ttt_karma_max 2000",
				"ttt_karma_ratio 0.0015",
				"ttt_karma_kill_penalty 15",
				"ttt_karma_round_increment 5",
				"ttt_karma_clean_bonus 15",
				"ttt_karma_traitordmg_ratio 0.0003",
				"ttt_karma_traitorkill_bonus 40",
				"ttt_karma_low_autokick 1",
				"ttt_karma_low_amount 500",
				"ttt_karma_low_ban 1",
				"ttt_karma_low_ban_minutes 20",
				"ttt_karma_debugspam 0",
				"ttt_karma_clean_half 0.25",
				"ttt_use_weapon_spawn_scripts 1",
				"ttt_credits_starting 2",
				"ttt_credits_award_pct 0.25",
				"ttt_credits_award_size 1",
				"ttt_credits_award_repeat 1",
				"ttt_credits_detectivekill 2",
				"ttt_det_credits_starting 2",
				"ttt_det_credits_traitorkill 0",
				"ttt_det_credits_traitordead 1",
				"ttt_spec_prop_control 1",
				"ttt_spec_prop_base 8",
				"ttt_spec_prop_maxpenalty -6",
				"ttt_spec_prop_maxbonus 16",
				"ttt_spec_prop_force 110",
				"ttt_spec_prop_rechargetime 1",
				"ttt_idle_limit 180",
				"ttt_namechange_kick 0",
				"ttt_namechange_bantime 10",
				"ttt_ban_type autodetect",
				"ttt_detective_hats 1",
				"ttt_ragdoll_collide 1",
				"ttt_sherlock_mode 1"
			}
			
			for _, cmd in SortedPairs(convars) do
				game.ConsoleCommand(cmd .. "\n")
			end
			
			CORE.ConvarLoaded = true
		end
	end)
	
	hook.Add("Initialize", "CORE_Initialize", function()
		util.AddNetworkString("admin_notify")
		util.AddNetworkString("admin_groups")
		util.AddNetworkString("admin_spray")
		util.AddNetworkString("admin_sendcap")
		util.AddNetworkString("admin_sendcap2")
		util.AddNetworkString("admin_gotcap")
		util.AddNetworkString("admin_docap")
		util.AddNetworkString("admin_run")
		util.AddNetworkString("admin_country")
		util.AddNetworkString("admin_sendcmds")
		util.AddNetworkString("advert_display")
		util.AddNetworkString("store_equip")
		util.AddNetworkString("store_items")
		util.AddNetworkString("store_new")
		util.AddNetworkString("vm_sendmaps")
		util.AddNetworkString("vm_update")
		
		AddCSLuaFile("module/chat.lua")
		AddCSLuaFile("autorun/core_crash.lua")
		AddCSLuaFile("extensions/sh_load.lua")
		AddCSLuaFile("mysql/sh_load.lua")
		AddCSLuaFile("admin/sh_load.lua")
		AddCSLuaFile("chatbox/sh_load.lua")
		--AddCSLuaFile("store/sh_load.lua")
		--AddCSLuaFile("statistics/sh_load.lua")
		--AddCSLuaFile("steam/sh_load.lua")
		--AddCSLuaFile("advert/sh_load.lua")
		--AddCSLuaFile("anticheat/sh_load.lua")
		
		resource.AddWorkshop("485343533")
	end)
end

include("module/chat.lua")
include("autorun/core_crash.lua")
include("extensions/sh_load.lua")
include("mysql/sh_load.lua")
include("chatbox/sh_load.lua")
include("admin/sh_load.lua")
--include("store/sh_load.lua")
--include("statistics/sh_load.lua")
--include("steam/sh_load.lua")
--include("advert/sh_load.lua")
--include("anticheat/sh_load.lua")

hook.Add("PlayerInitialSpawn", "CORE_PlayerInitialSpawn", function(ply)
	local rates = { ["cl_interp_ratio"] = 1, ["cl_interp"] = 0.0000, ["cl_updaterate"] = 66, ["cl_cmdrate"] = 66 }
	for k, v in pairs(rates) do
		ply:SendLua("RunConsoleCommand('" .. k .. "', '" .. v .. "')")
	end
	
	for k, v in pairs(CORE.QueuedFiles) do
		ply:SendLua("include('" .. v .. "')")
	end
end)

hook.Add("Move", "CORE_Move", function( ply, md )
	if ply:IsOnGround() or !ply:Alive() or ply:WaterLevel() > 0 then return end
	
	local aim = md:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = md:GetForwardSpeed()
	local smove = md:GetSideSpeed()
	
	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()
	
	local wishvel = forward * fmove + right * smove
	wishvel.z = 0
	
	local wishspeed = wishvel:Length()
	
	if(wishspeed > md:GetMaxSpeed()) then
		wishvel = wishvel * (md:GetMaxSpeed()/wishspeed)
		wishspeed = md:GetMaxSpeed()
	end
	
	local wishspd = wishspeed
	wishspd = math.Clamp(wishspd, 5, 45)
	
	local wishdir = wishvel:GetNormal()
	local current = md:GetVelocity():Dot(wishdir)
	
	local addspeed = wishspd - current
	
	if(addspeed <= 0) then return end
	
	local accelspeed = (120) * wishspeed * FrameTime()
	
	if(accelspeed > addspeed) then
		accelspeed = addspeed
	end
	
	local vel = md:GetVelocity()
	vel = vel + (wishdir * accelspeed)
	md:SetVelocity(vel)
	
	return false
end)

if CLIENT then
	hook.Add("TTTEndRound", "CORE_TTTEndRound", function()
		hook.Run('InitPostEntity', 'CreateVoiceVGUI')
	end)
else
	concommand.Add("core", function(ply, cmd, args)
		if #args == 0 then
			chat.Run(ply, "help", {})
		else
			cmd = string.Trim(args[1])
			table.remove(args, 1)
			
			if chat.GetTable()[cmd] then
				chat.Run(ply, cmd, args)
			end
		end
	end)
end

math.randomseed(os.time())
