ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Help NPC"
ENT.Author = "Epicstorm"
ENT.Category = "ELevel"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end