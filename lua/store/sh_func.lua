local STORE = CORE.STORE

if !STORE.ITEMS then
	STORE.ITEMS = {}
end

function STORE:GetHatOffset( mdl )
	local models = {
		["models/player/phoenix.mdl"] = Vector(0, 0, 0),
		["models/player/leet.mdl"] = Vector(0, 0, 1.125),
		["models/player/guerilla.mdl"] = Vector(0, -0.45, 0.5),
		["models/player/arctic.mdl"] = Vector(0, -0.125, 0.75),
		["models/player/alyx.mdl"] = Vector(0, 0, 0),
		["models/player/barney.mdl"] = Vector(0, -0.325, -0.55),
		["models/player/breen.mdl"] = Vector(0, -0.65, -0.65),
		["models/player/eli.mdl"] = Vector(0, -1.2, -0.125),
		["models/player/gman_high.mdl"] = Vector(0, -0.1, 0.125),
		["models/player/kleiner.mdl"] = Vector(0, -0.85, -0.4),
		["models/player/magnusson.mdl"] = Vector(0, -1, -1.5),
		["models/player/monk.mdl"] = Vector(0, -0.8, 0),
		["models/player/odessa.mdl"] = Vector(0, 0.35, -1),
		["models/player/group01/male_05.mdl"] = Vector(0, 0, -0.25),
	}
	
	if models[mdl] then
		return models[mdl]
	else
		return Vector(0, 0, 0)
	end
end

function STORE:GetItem( cat, id )
	return STORE.ITEMS[cat][id]
end

function STORE:GetItems( cat )
	return STORE.ITEMS[cat]
end

function STORE:AddItem( ... )
	local tbl = { ... }
	
	if !STORE.ITEMS[tbl[1]] then
		STORE.ITEMS[tbl[1]] = {}
	end
	
	if !STORE.ITEMS[tbl[1]][tbl[2]] then
		STORE.ITEMS[tbl[1]][tbl[2]] = {}
	end
	
	STORE.ITEMS[tbl[1]][tbl[2]] = tbl
end

function STORE:RemoveItem( cat, id )
	if STORE.ITEMS[cat] and STORE.ITEMS[cat][id] then
		STORE.ITEMS[cat][id] = nil
	end
end
