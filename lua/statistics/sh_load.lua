if !CORE.STAT then
	CORE.STAT = {}
end

local sv_files, sv_folders = file.Find("addons/core/lua/statistics/sv_*.lua", "GAME")
local sh_files, sh_folders = file.Find("addons/core/lua/statistics/sh_*.lua", "GAME")
local cl_files, cl_folders = file.Find("addons/core/lua/statistics/cl_*.lua", "GAME")
local vg_files, vg_folders = file.Find("addons/core/lua/statistics/vg_*.lua", "GAME")

for k, v in pairs(sv_files) do
	if SERVER then
		include(v)
	end
end

for k, v in pairs(sh_files) do
	if !v:find("sh_load") then
		if SERVER then
			include(v)
			AddCSLuaFile(v)
			table.insert(CORE.QueuedFiles, "statistics/" .. v)
		else
			include(v)
		end
	end
end

for k, v in pairs(cl_files) do
	if SERVER then
		AddCSLuaFile(v)
		table.insert(CORE.QueuedFiles, "statistics/" .. v)
	else
		include(v)
	end
end

for k, v in pairs(vg_files) do
	if SERVER then
		AddCSLuaFile(v)
		table.insert(CORE.QueuedFiles, "statistics/" .. v)
	else
		include(v)
	end
end
