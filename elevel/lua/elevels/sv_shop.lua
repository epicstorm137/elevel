elevel.shop = elevel.shop or {}

local metaply = FindMetaTable("Player")

function metaply:GetAmountSpawned( class )
    local i = 0
    for k,v in ipairs(ents.FindByClass(class)) do
        if v:CPPIGetOwner() == self then
            i = i + 1
        end
    end
    return i
end

function metaply:PurchaseItem( data )
    if !self:CanAfford(data.Cost) then
        self:ELMessage("Error: You cannot afford this!")
        return
    end

    if data.Type == "ent" then
        data.Max = data.Max or math.huge

        if self:GetAmountSpawned(data.Content) >= data.Max then
            self:ELMessage("Error: You already have the maximum spawned of "..data.Content.."!")
            return
        end

        local ent = ents.Create(data.Content)
        ent:SetPos(self:LocalToWorld( Vector(5,0,0) ))
        ent:SetAngles( self:GetAngles() )
        ent:Spawn()

        ent:CPPISetOwner( self )

    elseif data.Type == "weapon" then
        self:Give(data.Content)
    elseif data.Type == "health" then
        self:SetHealth(math.Clamp(self:Health() + data.Content,1,self:GetMaxHealth()))
    elseif data.Type == "armor" then
        self:SetArmor(math.Clamp(self:Armor() + data.Content,1,self:GetMaxArmor()))
    end

    self:AddXP(-data.Cost)
end