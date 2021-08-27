local ADMIN = CORE.ADMIN

local Player = FindMetaTable("Player")

function Player:GetUserGroup()
	return self:GetNWString("usergroup", "guest")
end

function Player:IsManager()
	return self:GetUserGroup() == "manager"
end

function Player:IsSuperAdmin()
	return self:GetUserGroup() == "manager"
end

function Player:IsAdmin()
	return self:GetUserGroup() == "admin"
end

function Player:IsMod()
	return self:GetUserGroup() == "moderator"
end

function Player:IsDonor()
	return self:GetUserGroup() == "donor"
end

function Player:IsGuest()
	return self:GetUserGroup() == "guest"
end

function Player:GetLevel()
	if self:IsManager() then
		return 4
	elseif self:IsAdmin() then
		return 3
	elseif self:IsMod() then
		return 2
	elseif self:IsDonor() then
		return 1
	else
		return 0
	end
end

function Player:GetUserColor()
	local colors = {
		detective = Color(20, 20, 200),
		terror = Color(20, 200, 20),
		traitor = Color(200, 20, 20),
		spec = Color(200, 200, 20),
		dev = Color(142, 68, 173),
		admin = Color(22, 160, 133),
		mod = Color(39, 174, 96),
		donor = Color(192, 57, 43),
	}
	
	local color = colors.terror
	
	if !self:IsDisguised() then
		if self:IsManager() then
			return colors.dev
		elseif self:IsAdmin() then
			return colors.admin
		elseif self:IsMod() then
			return colors.mod
		elseif self:IsDonor() then
			return colors.donor
		end
	end
	
	if game:IsTTT() then
		if self:IsDetective() then
			return colors.detective
		elseif self:Team() == TEAM_TERROR then
			return colors.terror
		end
	end
	
	if game:IsJB() then
		return team.GetColor(self:Team())
	end
	
	return color
end

function Player:IsDisguised()
	return self:GetNWBool("disguise", false)
end

function Player:SetDisguised( bool )
	if !self then return end
	
	self:SetNWBool("disguise", bool)
end

function Player:SetFakeName( name )
	if !self then return end
	
	self:SetNWString("fakename", name)
end

function Player:SetFakeAvatar( sid )
	if !self then return end
	
	self:SetNWString("fakeavatar", sid)
end

function Player:FakeName()
	return self:GetNWString("fakename", self:Name())
end

function Player:FakeAvatar()
	return self:GetNWString("fakeavatar", self:SteamID64())
end

function Player:Nick()
	if self:IsDisguised() then
		return self:FakeName()
	end
	
	return self:Name()
end

function Player:IsMuted()
	return self:GetNWBool("muted", false)
end

function Player:SetMuted( bool )
	self:SetNWBool("muted", bool)
end

function Player:IsGagged()
	return self:GetNWBool("gagged", false)
end

function Player:SetGagged( bool )
	self:SetNWBool("gagged", bool)
end
