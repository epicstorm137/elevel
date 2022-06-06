AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_c17/consolebox01a.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:SetExploding( false )
    self:SetPrinting( true )
    self:SetNextPrint( CurTime() + elevel.Config.PrintTime )
    self:SetDurability(100)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

end

function ENT:Use( activator )

	if activator:IsPlayer() then

        self:Loot(activator)

    end

end

function ENT:Loot( ply )
    if self:GetBalance() <= 0 then return end
    
    ply:AddXP(self:GetBalance())
    self:SetBalance(0)

end

function ENT:Print()

    self:SetBalance(self:GetBalance() + self:GetOwnerLevel())

end

function ENT:Explode()
    if self:GetExploding() then return end

    self:CPPIGetOwner():ELNotify("Your printer has exploded!", 8, elevel.red)

    self:SetExploding(true)
    self:EmitSound("weapons/mortar/mortar_shell_incomming1.wav")

    local pos = self:GetPos()
    
    timer.Simple(0.75, function()
        local eff = EffectData()
        eff:SetOrigin(pos)
        eff:SetStart(pos)
        eff:SetScale(1)
        util.Effect("Explosion", eff)
        util.BlastDamage(self, self, pos, 160, 30)
        SafeRemoveEntity(self)
    end)
end

function ENT:Think()

    if self:GetPrinting() then
        
        if self:GetNextPrint() <= CurTime() then
            self:SetPrinting(false)
            self:Print()
            self:SetNextPrint(CurTime() + elevel.Config.PrintTime)
            self:SetPrinting(true)
        end

    end

    if self:WaterLevel() > 2 then
        
        self:Explode()

    end

end

local damageTypes = {
    [DMG_GENERIC] = true,
    [DMG_BUCKSHOT] = true,
    [DMG_BULLET] = true,
    [DMG_BLAST] = true,
    [DMG_ACID] = true,
    [DMG_CLUB] = true,
    [DMG_SHOCK] = true,
    [DMG_DISSOLVE] = true
}

function ENT:OnTakeDamage( dmgInfo )
    if self:GetExploding() then return end

    local isDmgType = false
    for typ, _ in next, damageTypes do
        if dmgInfo:IsDamageType(typ) or (dmgInfo:GetDamageType() == 0 and typ == 0) then
            isDmgType = true
            break
        end
    end

    if isDmgType then
        self:SetDurability(math.max(0, self:GetDurability() - dmgInfo:GetDamage()))
        if self:GetDurability() <= 0 then
            self:Explode()

            local attacker = dmgInfo:GetAttacker()
            if attacker:IsPlayer() then
                if attacker == self:CPPIGetOwner() then return end
                attacker:AddXP(elevel.Config.PrinterDestroyXP)
            end
        end
    end
end