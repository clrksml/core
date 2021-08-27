AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Dollar"
ENT.Author			= "Clark"
ENT.Contact			= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Amount")
end

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/Money.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	self:PhysWake()
	self.Time = CurTime() + 1
end

function ENT:StartTouch(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply:Team() != TEAM_SPECTATOR then
		if self.Time >= CurTime() then
			
		end
	end
end

function ENT:Remove()

end