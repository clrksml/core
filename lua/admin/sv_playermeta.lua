local ADMIN = CORE.ADMIN

local Player = FindMetaTable("Player")

function Player:SetUserGroup( group )
	if !self then return end
	if !group then group = "guest" end
	if !ADMIN.Groups[group] then return end
	
	self:SetNWString("usergroup", group)
end

function Player:IsLocked()
	return self.Locked
end

Player.lock = Player.Lock
function Player:Lock()
	self.Locked = true
	
	return self.lock()
end

Player.unlock = Player.UnLock
function Player:UnLock()
	self.Locked = true
	
	return self.unlock()
end

