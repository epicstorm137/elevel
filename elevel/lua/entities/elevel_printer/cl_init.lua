include("shared.lua")

surface.CreateFont("EPrintFontLarge",{font = "Roboto",size = 60, antialias = true})
surface.CreateFont("EPrintFontMedium",{font = "Roboto",size = 50, antialias = true})
surface.CreateFont("EPrintFontSmall",{font = "Roboto",size = 25, antialias = true})

function ENT:Draw()

	self:DrawModel()

    local ang,plypos = self:GetAngles(), LocalPlayer():GetPos()
    local pos = self:LocalToWorld(Vector(0,0,10.6))
    if !elevel.CanView(LocalPlayer(),self,elevel.Config.PrinterRenderDist) then return end

    self.TimeLeft = self:GetNextPrint() - CurTime()
    self.PrintTime = elevel.Config.PrintTime

    ang:RotateAroundAxis(self:GetAngles():Up(),90)

    cam.Start3D2D(pos, ang, 0.075)

        draw.RoundedBox(0,-200,-215,406,400,elevel.bgdark)
        draw.RoundedBox(0,-190,-205,386,380,elevel.bglight)

        draw.RoundedBox(0,-180,-195,366,100,elevel.bgdark)
        draw.RoundedBox(0,-170,-185,346,80,elevel.bglight)
        draw.DrawText(elevel.Config.PrinterHeader,"EPrintFontLarge",0,-176,color_white,TEXT_ALIGN_CENTER)

        // Printing Stats
        draw.RoundedBox(0,-180,-35,366,60,elevel.bgdark)
        draw.RoundedBox(0,-170,-25,346 * math.Clamp(self.TimeLeft / self.PrintTime,0,1),40,elevel.blue)
        draw.DrawText("Printing "..self:GetOwnerLevel().."XP per "..self.PrintTime.."s","EPrintFontSmall",0,-17,color_white,TEXT_ALIGN_CENTER)

        // Value Stats
        draw.RoundedBox(0,-180,35,366,60,elevel.bgdark)
        draw.RoundedBox(0,-170,45,346,40,elevel.green)
        draw.DrawText(self:GetBalance().."XP","EPrintFontSmall",0,52,color_white,TEXT_ALIGN_CENTER)

        // Health Stats
        draw.RoundedBox(0,-180,105,366,60,elevel.bgdark)
        draw.RoundedBox(0,-170,115,346 * (self:GetDurability() / 100),40,elevel.red)
        draw.DrawText("Health: "..self:GetDurability(),"EPrintFontSmall",0,122,color_white,TEXT_ALIGN_CENTER)
        -- Make explode anim

        if self:GetExploding() then
            draw.RoundedBox(0,-190,-205,386,380, HSVToColor(  ( CurTime() * 5000 ) % 360, 1, 1 ))
        end

    cam.End3D2D()

    local pos = self:LocalToWorld(Vector(16.2,-3.6,6.5))
    ang:RotateAroundAxis(self:GetAngles():Right(),-90)
    
    cam.Start3D2D(pos, ang, 0.075)

        draw.RoundedBox(0,-145,-50,295,128,elevel.bgdark)
        draw.RoundedBox(0,-135,-40,275,108,elevel.bglight)
        draw.DrawText("Owner: "..self:GetOwnerName(),"EPrintFontSmall",0,0,color_white,TEXT_ALIGN_CENTER)

    cam.End3D2D()
end

