ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Shop NPC"
ENT.Author = "Epicstorm"
ENT.Category = "ELevel"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

elevel.shop.npc = elevel.shop.npc or {}