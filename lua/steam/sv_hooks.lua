local STEAM = CORE.STEAM
local hook = hook

hook.Add("PlayerAuthed", "STEAM_PlayerAuthed", function( ply )
	if !ply:IsPlayer() then return end
	
	STEAM:InitData(ply)
end)
