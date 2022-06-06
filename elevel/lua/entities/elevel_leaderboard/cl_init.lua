include("shared.lua")

surface.CreateFont("ELevelLBFontLarge",{font = "Roboto",size = 255, antialias = true})
surface.CreateFont("ELevelLBFontMedium",{font = "Roboto",size = 200, antialias = true})
surface.CreateFont("ELevelLBFontSmall",{font = "Roboto",size = 150, antialias = true})

function GetLeaderboardData()
    return elevel.lb.LBData
end

function elevel:SetCanDrawLB( bool )
    elevel.candrawlb = bool
end

function elevel:CanDrawLB()
    return elevel.candrawlb
end

hook.Add("Initialize","elevel:initboard",function()
    elevel:SetCanDrawLB( false )
end)

function ENT:Draw()

    self:DrawModel()

    if !elevel:CanDrawLB() then return end

    local ang,plypos = self:GetAngles(), LocalPlayer():GetPos()
    local pos = self:LocalToWorld(Vector(0.8,0,0))
    local data = GetLeaderboardData()
    if !elevel.CanView(LocalPlayer(),self,elevel.Config.LBRenderDist) then return end

    ang:RotateAroundAxis(self:GetAngles():Right(),90)
    ang:RotateAroundAxis(self:GetAngles():Forward(),90)
    ang:RotateAroundAxis(self:GetAngles():Up(),180)

    cam.Start3D2D(pos, ang, 0.075)

        draw.RoundedBox(0,-1474,-769,2948,1538,elevel.bgdark)
        draw.RoundedBox(0,-1444,-739,2888,250,elevel.bglight)
        draw.DrawText("ELevel Leaderboard","ELevelLBFontMedium",0,-710,color_white,TEXT_ALIGN_CENTER)

        local str = data[1].Name.." - Level "..data[1].level.." - "..data[1].xp.."XP"
        draw.RoundedBox(0,-1444,-419,2888,355,elevel.bglight)
        draw.DrawText("1","ELevelLBFontLarge",-1300,-370,color_white,TEXT_ALIGN_CENTER)
        draw.DrawText(str,"ELevelLBFontSmall",0,-320,color_white,TEXT_ALIGN_CENTER)

        local str = data[2].Name.." - Level "..data[2].level.." - "..data[2].xp.."XP"
        draw.RoundedBox(0,-1444,-24,2888,355,elevel.bglight)
        draw.DrawText("2","ELevelLBFontLarge",-1300,20,color_white,TEXT_ALIGN_CENTER)
        draw.DrawText(str,"ELevelLBFontSmall",0,70,color_white,TEXT_ALIGN_CENTER)

        local str = data[3].Name.." - Level "..data[3].level.." - "..data[3].xp.."XP"
        draw.RoundedBox(0,-1444,371,2888,355,elevel.bglight)
        draw.DrawText("3","ELevelLBFontLarge",-1300,420,color_white,TEXT_ALIGN_CENTER)
        draw.DrawText(str,"ELevelLBFontSmall",0,470,color_white,TEXT_ALIGN_CENTER)

    cam.End3D2D()
end

concommand.Add("elevel_refreshboard",function(ply,cmd,args)
    if !elevel.Config.Admins[ply:GetUserGroup()] then return end

    net.Start("elevel_lb_forcenwdata")
    net.SendToServer()
end)

concommand.Add("elevel_"..elevel.Config.LBSaveCmd,function(ply)
	if !elevel.Config.Admins[ply:GetUserGroup()] then return end

	net.Start("elevel_savelb")
	net.SendToServer()
end)