local sv_files, sv_folders = file.Find("addons/core/lua/extensions/sv_*.lua", "GAME")
local sh_files, sh_folders = file.Find("addons/core/lua/extensions/sh_*.lua", "GAME")
local cl_files, cl_folders = file.Find("addons/core/lua/extensions/cl_*.lua", "GAME")

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
			table.insert(CORE.QueuedFiles, "extensions/" .. v)
		else
			include(v)
		end
	end
end

for k, v in pairs(cl_files) do
	if SERVER then
		AddCSLuaFile(v)
		table.insert(CORE.QueuedFiles, "extensions/" .. v)
	else
		include(v)
	end
end
