local STAT = CORE.STAT

if !STAT.stats then
	STAT.stats = {}
end

function STAT:Add( tbl )
	if type(tbl) != "table" then return end
	
	STAT.stats[tbl.id] = tbl
end

function STAT:Remove( id )
	STAT.stats[id] = nil
end

function STAT:Get( id )
	return STAT.stats[id]
end
