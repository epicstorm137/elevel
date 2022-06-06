AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_junk/cardboard_box004a.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:SetLooted( false )

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

end

function ENT:SetLooted( bool )
    self.HasLooted = bool
end

function ENT:HasBeenLooted()
    return self.HasLooted
end

function ENT:Loot()
    self:SetLooted(true)
    local int = math.random(elevel.Config.ParcelLowerLimit,elevel.Config.ParcelUpperLimit)
    local pos = self:GetPos()

    self:EmitSound("weapons/mortar/mortar_shell_incomming1.wav")

    for k,v in ipairs(player.GetAll()) do
        if pos:Distance(v:GetPos()) < elevel.Config.ParcelXPDist then
            v:AddXP(int)
        end
    end

    timer.Simple(0.75,function()
        local eff = EffectData()
        eff:SetOrigin(pos)
        eff:SetStart(pos)
        eff:SetScale(1)
        util.Effect("Explosion", eff)
        SafeRemoveEntity(self)
    end)
end

function ENT:Use( activator )

	if ( activator:IsPlayer() and !self:HasBeenLooted() ) then 
		self:Loot()
	end

end
