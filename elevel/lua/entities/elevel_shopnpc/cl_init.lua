include("shared.lua")

function ENT:Draw()

	self:DrawModel()

	local plypos, plyang = LocalPlayer():GetPos(), LocalPlayer():GetAngles()
	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 7 )
	local ang = Angle( 0, plyang.yaw-90, 90 )
	if !elevel.CanView(LocalPlayer(),self,elevel.Config.SNPCRenderDist) then return end

	cam.Start3D2D( pos, ang, 0.025 )
		draw.WordBox(48,0,0,elevel.Config.SNPCText,"ELevelFont",elevel.blackhud,elevel.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	cam.End3D2D()

end

concommand.Add("elevel_"..elevel.Config.SNPCSaveCmd,function(ply)
	if !elevel.Config.Admins[ply:GetUserGroup()] then return end

	net.Start("elevel_saveshopnpc")
	net.SendToServer()
end)