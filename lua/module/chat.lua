
module("chat")

local Table = {}

function GetTable()
	return Table
end

function Add( name, func, use, dsc, grp, arg )
	name = name:lower()
	
	if Table[name] then
		Table[name] = nil
	end
	
	use = use or ""
	dsc = dsc or ""
	grp = grp or 4
	arg = arg or 0
	
	Table[name] = { func, use, dsc, grp, arg }
end

function Remove( name )
	name = name:lower()
	
	if Table[name] then
		Table[name] = nil
	end
end

function Run( ply, name, args )
	name = name:lower()
	
	if Table[name][1] then
		Table[name][1](ply, name, args)
		
		return
	end
	
	if ply:IsValid() then
		ply:ChatPrint("Unkown chat command " .. name .. ".")
		
		return
	end
end
