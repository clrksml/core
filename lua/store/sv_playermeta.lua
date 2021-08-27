local STORE = CORE.STORE

local Player = FindMetaTable('Player')

function Player:BuyItem(cat, id)
	local item = STORE.ITEMS[cat][id]

	if self:CanAfford(item[4]) then
		if !table.HasValue(self.Items[cat], id) then
			self:TakeCash(item[4])

			table.insert(self.Items[cat], id)

			self:SyncItems()
			self:SaveStoreData()

			CORE.ADMIN:Notify(self, Color(116, 182, 89), "Successfully purchased " .. item[3] .. ".")
		end
	else
		CORE.ADMIN:Notify(self, Color(155, 89, 182), "Error - You can't afford this item.")
	end
end

function Player:GetCash()
	return self:GetNWInt("cash", 500)
end

function Player:SetCash(num)
	self:SetNWInt("cash", num)
end

function Player:AddCash(num)
	self:SetNWInt("cash", self:GetNWInt("cash") + num)
end

function Player:TakeCash(num)
	self:SetNWInt("cash", self:GetNWInt("cash") - num)

	if self:GetNWInt("cash") < 0 then
		self:SetNWInt("cash", 0)
	end
end

function Player:CanAfford(num)
	if self:GetNWInt("cash") >= num then
		return true
	end

	return false
end

function Player:SyncItems()
	net.Start("store_items")
		net.WriteTable(self.Items)
	net.Send(self)
end

function Player:UnEquipItem( cat, id )
	if self.Items[cat] and table.HasValue(self.Items[cat], id) then
		self.EquipItems[cat] = id

		if cat <= 2 then
			net.Start("store_equip")
				net.WriteEntity(self)
				net.WriteFloat(cat)
				net.WriteFloat(id)
				net.WriteFloat(1)
			net.Broadcast()
		else
			if cat == 4 and self._Trail then
				self._Trail:Remove()
			end
		end

		self:SaveStoreData()
	end
end

function Player:EquipItem( cat, id )
	if self.Items[cat] and table.HasValue(self.Items[cat], id) then
		local item = STORE.ITEMS[cat][id]

		self.EquipItems[cat] = id

		if cat == 1 then
			self:SetNWFloat("hat", id)
		elseif cat == 2 then
			self:SetNWFloat("mask", id)
		elseif cat == 3 then
			self:SetModel(item[5])
			self:SetNWString("model", item[6])
		elseif cat == 4 then
			if self._Trail then
				self._Trail:Remove()

				self._Trail = util.SpriteTrail(self, self:LookupAttachment("pelvis"), Color(255, 255, 255), true, 10, 5, 1, 3, item[5])
			else
				self._Trail = util.SpriteTrail(self, self:LookupAttachment("pelvis"), Color(255, 255, 255), true, 10, 5, 1, 3, item[5])
			end
		end

		CORE.ADMIN:Notify(self, Color(116, 182, 89), "Successfully equipped " .. item[3] .. ".")

		net.Start("store_equip")
			net.WriteEntity(self)
			net.WriteFloat(cat)
			net.WriteFloat(id)
			net.WriteFloat(0)
		net.Broadcast()

		self:SaveStoreData()
	end
end

function Player:GetEquippedItems()
	return self.EquipItems or {}
end

function Player:LoadStoreData()
	if STORE.ITEMS then
		self.Items = {}
		self.EquipItems = {}

		for cat, id in pairs(STORE.ITEMS) do
			self.Items[cat] = {}

			if !self.EquipItems[cat] then
				self.EquipItems[cat] = {}
			end
		end
	end

	mysql:DoQuery("SELECT  `new`, `cash`, `items` FROM `store` WHERE `sid`='" .. self:SteamID64() .. "'", function( data )
		if data and data[1] then
			data = data[1]

			local cash, items, equip = tonumber(data['cash']), util.JSONToTable(tostring(data['items'])), util.JSONToTable(tostring(data['equip']))

			self:SetCash(data['cash'])
			self.OpenedStore = tonumber(data['new'])

			if items and #items > 1 then
				self.Items = items
			end

			self:SyncItems()

			if equip and #equip > 1 then
				self.EquipItems = equip

				for _, cat in pairs(equip) do
					for __, id in pairs(cat) do
						self:EquipItem(cat, id)
					end
				end
			end
		else
			local cash, items, equip = 500, util.TableToJSON(self:GetItems()), util.TableToJSON(self:GetEquippedItems())
			
			mysql:DoQuery("INSERT INTO `store` (`sid`, `name`, `new`, `cash`, `items`, `equip`) VALUES('" .. self:SteamID64() .. "', '" .. mysql:Escape(self:Name()) .. "', '" .. 0 .. "', '" .. cash .. "', '" .. mysql:Escape(items) .. "', '" .. mysql:Escape(equip) .. "')")
		end
	end)
end

function Player:SaveStoreData()
	local cash, items, equip = self:GetCash(), util.TableToJSON(self:GetItems()), util.TableToJSON(self:GetEquippedItems())
	
	mysql:DoQuery("UPDATE `store` SET `name`='" .. mysql:Escape(self:Name()) .. "', `cash`='" .. cash .. "', `items`='" .. mysql:Escape(items) .. "', `equip`='" .. mysql:Escape(equip) .. "' WHERE `sid`='" .. self:SteamID64() .. "'")
end
