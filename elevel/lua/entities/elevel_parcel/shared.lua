ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "XP Parcel"
ENT.Author = "Epicstorm"
ENT.Category = "ELevel"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end