elevel.bgdark     = Color(69,81,97)
elevel.bglight    = Color(86,102,133)
elevel.grey       = Color(150,150,150)
elevel.hghlight   = Color(141,141,190)
elevel.white      = Color(255,255,255)
elevel.blackhud   = Color(20,20,20,253)
elevel.green      = Color(94,214,94)
elevel.red        = Color(204,117,117)
elevel.blue       = Color(110,117,212)
elevel.wfgreen    = Color(0,255,0)
elevel.rfgreen    = Color(0,255,0,50)
elevel.scrollcol  = Color(0, 0, 0, 100)

if CLIENT then
    local PNL = FindMetaTable("Panel")

    surface.CreateFont("ELevelFont",{font = "Roboto",size = 255, antialias = true})
    surface.CreateFont("ELevelFontUI",{font = "Roboto",size = 20, antialias = true})
    surface.CreateFont("ELevelFontUISmall",{font = "Roboto",size = 15, antialias = true})

    function elevel.MakeFrame(pnl,txt,width,height)
        pnl:SetTitle("")
        pnl.IsMoving = true
        pnl:SizeTo(width,height,1,0,.1,function()
            pnl.IsMoving = false
        end)
        pnl.Paint = function(s,w,h)
            if pnl.IsMoving == true then
                pnl:Center()
            end
            surface.SetDrawColor(elevel.bgdark)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText(txt,"ELevelFontUISmall",10,7,elevel.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        end
    end

    function elevel.MakeButton(pnl,txt,col)
        pnl:SetText("")
        local speed,barstatus = 4,0
        pnl.Paint = function(s,w,h)
            if pnl:IsHovered() then
                barstatus = math.Clamp(barstatus + speed * FrameTime(), 0, 1)
            else
                barstatus = math.Clamp(barstatus - speed * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
            surface.SetDrawColor(col)
            surface.DrawRect(0,h * .9,w * barstatus,h * .1)
            draw.SimpleText(txt,"ELevelFontUI",w/2,h/2,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
    
    function elevel.MakeInput(pnl,txt)
        pnl:SetFont("ELevelFontUISmall")
        pnl.Paint = function(s,w,h)
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
            if pnl:GetText() == "" then
                draw.SimpleText(txt,"ELevelFontUISmall",5,h/2,elevel.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
            pnl:DrawTextEntryText(elevel.white,elevel.hghlight,elevel.white)
        end
    end
        
    function elevel.MakeCombo(pnl,txt)
        pnl:SetFont("ELevelFontUISmall")
        pnl:SetColor(elevel.white)
        pnl.Paint = function(s,w,h)
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
            if pnl:GetSelected() == nil and pnl:GetText() == "" then
                draw.SimpleText(txt,"ELevelFontUISmall",5,h/2,elevel.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
        end
    end

    function elevel.MakeList(pnl)
        pnl.Paint = function(s,w,h)
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
        end
    end

    function elevel.MakeWang(pnl)
        pnl:SetFont("ELevelFontUISmall")
        pnl.Paint = function(s,w,h)
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
            pnl:DrawTextEntryText(elevel.white,elevel.hghlight,elevel.white)
            if pnl:GetValue() > pnl:GetMax() then
                pnl:SetValue(pnl:GetMax())
            elseif pnl:GetValue() < pnl:GetMin() then
                pnl:SetValue(pnl:GetMin())
            end
            pnl:DrawTextEntryText(elevel.white,elevel.hghlight,elevel.white)
        end
    end

    function elevel.MakeScroll(pnl)
        local scroll = pnl:GetVBar()
        function scroll:Paint(w, h)
            surface.SetDrawColor(elevel.scrollcol)
            surface.DrawRect(0,0,w,h)
        end
        function scroll.btnUp:Paint(w, h)
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
        end
        function scroll.btnDown:Paint(w, h)
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
        end
        function scroll.btnGrip:Paint(w, h)
            surface.SetDrawColor(elevel.bglight)
            surface.DrawRect(0,0,w,h)
        end
    end

    function elevel.CanView( ply, target, dist )
        local distSqr = dist * dist
        return ply:GetPos():DistToSqr( target:GetPos() ) < distSqr
    end
    
end