local STORE = CORE.STORE

local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

function Player:DrawHat(id)
	if !IsValid(self) then return end
	if self == LocalPlayer() then return end
	
	local item = STORE.ITEMS[1][id]
	
	if !item then return end
	
	if !STORE.HATS[self:EntIndex()] then
		STORE.HATS[self:EntIndex()] = ClientsideModel("models/error.mdl")
		STORE.HATS[self:EntIndex()]:SetNoDraw(true)
		STORE.HATS[self:EntIndex()]:SetParent(self)
	end
	
	if IsValid(STORE.HATS[self:EntIndex()]) then
		local hat = STORE.HATS[self:EntIndex()]
		hat:SetModel(item[5])
		hat:SetNoDraw(false)
		
		local pos, ang = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
		local offsetpos = STORE:GetHatOffset(self:GetModel())
		
		local ang2 = Angle(ang.p, ang.y, ang.r)
		ang2:RotateAroundAxis(ang:Right(), item[7].p)
		ang2:RotateAroundAxis(ang:Up(), item[7].y)
		ang2:RotateAroundAxis(ang:Forward(), item[7].r)
		
		hat:DoModelScale(item[8])
		hat:SetRenderOrigin(pos + (ang:Up() * item[6].x) + (ang:Right() * item[6].y) + (ang:Forward() * item[6].z) + (ang:Up() * offsetpos.x) + (ang:Right() * offsetpos.y) + (ang:Forward() * offsetpos.z))
		hat:SetRenderAngles(ang2)
		hat:SetupBones()
		hat:DrawModel()
	end
end

function Entity:DrawHat(id)
	if !IsValid(self) then return end
	if self == LocalPlayer() then return end
	
	local item = STORE.ITEMS[1][id]
	
	if !item then return end
	
	if !STORE.HATS[self:EntIndex()] then
		STORE.HATS[self:EntIndex()] = ClientsideModel("models/error.mdl")
		STORE.HATS[self:EntIndex()]:SetNoDraw(true)
		STORE.HATS[self:EntIndex()]:SetParent(self)
	end
	
	if IsValid(STORE.HATS[self:EntIndex()]) then
		local hat = STORE.HATS[self:EntIndex()]
		hat:SetModel(item[5])
		hat:SetNoDraw(false)
		
		local pos, ang = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
		local offsetpos = STORE:GetHatOffset(self:GetModel())
		
		if !pos or !ang then return end
		
		local ang2 = Angle(ang.p, ang.y, ang.r)
		ang2:RotateAroundAxis(ang:Right(), item[7].p)
		ang2:RotateAroundAxis(ang:Up(), item[7].y)
		ang2:RotateAroundAxis(ang:Forward(), item[7].r)
		
		hat:DoModelScale(item[8])
		hat:SetRenderOrigin(pos + (ang:Up() * item[6].x) + (ang:Right() * item[6].y) + (ang:Forward() * item[6].z) + (ang:Up() * offsetpos.x) + (ang:Right() * offsetpos.y) + (ang:Forward() * offsetpos.z))
		hat:SetRenderAngles(ang2)
		hat:SetupBones()
		hat:DrawModel()
	end
end

function Player:RemoveHat(id)
	if !IsValid(self) then return end
	if self == LocalPlayer() then return end
	
	if IsValid(STORE.HATS[self:EntIndex()]) then
		STORE.HATS[self:EntIndex()]:Remove()
	end
end

function Entity:RemoveHat(id)
	if !IsValid(self) then return end
	if self == LocalPlayer() then return end
	
	if IsValid(STORE.HATS[self:EntIndex()]) then
		STORE.HATS[self:EntIndex()]:Remove()
	end
end

function Player:DrawMask(id)
	if !IsValid(self) then return end
	if self == LocalPlayer() then return end
	
	local item = STORE.ITEMS[2][id]
	
	if !item then return end
	
	if !STORE.MASKS[self:EntIndex()] then
		STORE.MASKS[self:EntIndex()] = id
	end
end

function Player:RemoveMask(id)
	if !IsValid(self) then return end
	if self == LocalPlayer() then return end
	
	if STORE.MASKS[self:EntIndex()] then
		STORE.MASKS[self:EntIndex()] = nil
	end
end

function Player:GetCash()
	return self:GetNWInt("cash", 500)
end

function Player:CanAfford(num)
	if self:GetNWInt("cash") >= num then
		return true
	end
	
	return false
end

function Entity:DoModelScale(vector)
	local mat = Matrix()
	
	mat:Scale(vector)
	
	self:EnableMatrix("RenderMultiply", mat)
end
