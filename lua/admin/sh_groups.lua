local ADMIN = CORE.ADMIN

local table = table
local pairs = pairs

if !ADMIN.Groups then
	ADMIN.Groups = {}
end

function ADMIN:GetGroup( name )
	name = name:lower()
	
	return ADMIN.Groups[name]
end

function ADMIN:RemoveGroup( name )
	name = name:lower()
	
	if ADMIN.Groups[name] then
		ADMIN.Groups[name] = nil
	end
end

function ADMIN:AddGroup( name )
	name = name:lower()
	
	ADMIN.Groups[name] = { }
end

function ADMIN:GetUsers( name )
	name = name:lower()
	
	return ADMIN.Groups[name]
end

function ADMIN:AddUser( name, id )
	name = name:lower()
	
	if !ADMIN.Groups[name] then
		ADMIN.Groups[name] = {}
	end
	
	table.insert(ADMIN.Groups[name], id)
end

function ADMIN:RemoveUser( name, id )
	name = name:lower()
	
	for k, v in pairs(ADMIN.Groups[name]) do
		if v == id then
			ADMIN.Groups[name][k] = nil
			
			break
		end
	end
end
