elevel.UI = {}

elevel.UI.Stack = 0

local scrw,scrh = ScrW(),ScrH()

function elevel:Notify( text, time, color )
    elevel.UI.Stack = elevel.UI.Stack + 1
    local pos = elevel.UI.Stack
    local smoothHealth = 10
    hook.Add("HUDPaint","elevel:painthud-"..pos,function()
        smoothHealth = Lerp(10 * FrameTime(), smoothHealth, pos * (40))
        draw.WordBox(8,scrw/2,smoothHealth,text,"ELevelFontUISmall",color,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end)
    timer.Simple(time,function()
        hook.Remove("HUDPaint","elevel:painthud-"..pos)
        elevel.UI.Stack = elevel.UI.Stack - 1
    end)
end

elevel.UI.Level = 0
elevel.UI.XP = 0

timer.Simple(10,function()
    timer.Create("elevel:refreshcount",.5,0,function()
        elevel.UI.Level = LocalPlayer():GetLevel()
        elevel.UI.XP = LocalPlayer():GetXP()

        if elevel.UI.Stack < 0 then
            elevel.UI.Stack = 0
        end
    end)

    hook.Add("HUDPaint","elevel:showdata",function()
        if elevel.Config.HUDEnable then
            draw.DrawText( "Level: "..elevel.UI.Level.."\nXP: "..elevel.UI.XP, "ELevelFontUI", scrw * 0.005, scrh * 0.005, color_white, TEXT_ALIGN_LEFT )
        end
    end)
end)

function elevel:Help()
    local frame = vgui.Create("DFrame")
    frame:SetSize(0,0)
    frame:Center()
    frame:MakePopup()
    frame:SetVisible(true)
    elevel.MakeFrame(frame,"ELevels Help",300,500)

    local res = vgui.Create("DNumberWang", frame)
    res:SetPos(10,30)
    res:SetSize(50,30)
    res:SetMin(0)
    res:SetMax(10000)
    res:SetValue(100)
    elevel.MakeWang(res)

    local button = vgui.Create("DButton",frame)
    button:SetPos(70,30)
    button:SetSize(220,30)
    elevel.MakeButton(button,"List XP",elevel.green)

    local scroll = vgui.Create("DScrollPanel",frame)
    scroll:SetPos(10,65)
    scroll:SetSize(280,425)
    elevel.MakeScroll(scroll)

    local function DisplayData( n )
        local level = LocalPlayer():GetLevel()
        local xp = LocalPlayer():GetXP()
        scroll:Clear()
        for i=0, n do
            timer.Simple(.0001 * i,function()
                local text = vgui.Create("DLabel",scroll)
                text:Dock(TOP)
                text:SetFont("ELevelFontUISmall")
                if i < level then
                    text:SetColor(elevel.red)
                    text:SetText("Level: "..i.." - \t"..elevel:Formula( i ).."XP")
                elseif i == level then
                    text:SetColor(elevel.green)
                    text:SetText("Level: "..i.." - \t"..elevel:Formula( i ).."XP".."    You need "..elevel:Formula( i ) - xp.." more!")
                else
                    text:SetColor(elevel.grey)
                    text:SetText("Level: "..i.." - \t"..elevel:Formula( i ).."XP")
                end
            end)
        end
    end

    DisplayData( res:GetValue() )
    
    button.DoClick = function()
        DisplayData( res:GetValue() )
    end
end

concommand.Add("elevel_help",elevel.Help)