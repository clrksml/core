local STORE = CORE.STORE

local Player = FindMetaTable('Player')

function Player:HasItem( cat, id )
	if !self.Items then
		self.Items = {}
		
		for k, v in pairs(STORE.ITEMS) do
			self.Items[k] = {}
		end
	end
	
	if self.Items[cat] and table.HasValue(self.Items[cat], id) then
		return true
	end
	
	return false
end

function Player:GetItem( cat, id )
	if !self.Items then
		self.Items = {}
		
		for k, v in pairs(STORE.ITEMS) do
			self.Items[k] = {}
		end
	end
	
	if self.Items[cat] and table.HasValue(self.Items[cat], id) then
		return self.Items[cat][id]
	end
	
	return false
end

function Player:GetItems()
	if !self.Items then
		self.Items = {}
		
		for k, v in pairs(STORE.ITEMS) do
			self.Items[k] = {}
		end
	end
	
	return self.Items
end

function Player:GetCash()
	return self:GetNWInt("cash") or 0
end
