ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "ELevel Printer"
ENT.Author = "Epicstorm"
ENT.Category = "ELevel"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
 
	self:NetworkVar( "Int", 0, "Balance" )
    self:NetworkVar( "Bool", 0, "Printing" )
    self:NetworkVar( "Bool", 1, "Exploding" )
    self:NetworkVar( "Int", 1, "NextPrint" )
    self:NetworkVar( "Int", 2, "Durability" )

    local _SetBalance = self.SetBalance
    function self:SetBalance( value )
        if CLIENT then return end
        _SetBalance(self,value)
    end

    local _SetPrinting = self.SetPrinting
    function self:SetPrinting( value )
        if CLIENT then return end
        _SetPrinting(self,value)
    end
    
    local _SetNextPrint = self.SetNextPrint
    function self:SetNextPrint( value )
        if CLIENT then return end
        _SetNextPrint(self,value)
    end

    local _SetExploding = self.SetExploding
    function self:SetExploding( value )
        if CLIENT then return end
        _SetExploding(self,value)
    end

    local _SetDurability = self.SetDurability
    function self:SetDurability( value )
        if CLIENT then return end
        _SetDurability(self,value)
    end

end

function ENT:GetOwnerLevel()

    if IsValid(self:CPPIGetOwner()) then
        return math.Round(self:CPPIGetOwner():GetLevel() / 2)
    else
        return 0
    end

end

function ENT:GetOwnerName()

    if IsValid(self:CPPIGetOwner()) then
        return self:CPPIGetOwner():Nick()
    else
        return "NULL"
    end

end
