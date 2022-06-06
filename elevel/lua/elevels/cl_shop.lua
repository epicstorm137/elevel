elevel.shop = elevel.shop or {}

net.Receive("elevel_openshopmenu",function()
    local itemdata = util.JSONToTable(util.Decompress(net.ReadData(1048000)))

    local frame = vgui.Create("DFrame")
    frame:SetSize(0,0)
    frame:Center()
    frame:MakePopup()
    frame:DockPadding(10,35,10,10)
    elevel.MakeFrame(frame,"ELevel Shop",300,500)

    local stat = vgui.Create("DPanel",frame)
    stat:Dock(BOTTOM)
    stat:SetHeight(40)
    stat.Paint = function(s,w,h)
        surface.SetDrawColor(elevel.bglight)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("You Have: "..LocalPlayer():GetXP().."XP   Level: "..LocalPlayer():GetLevel(),"ELevelFontUI",w/2,h/2,HSVToColor(  ( CurTime() * 50 ) % 360, 1, 1 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local scroll = vgui.Create("DScrollPanel",frame)
    scroll:Dock(FILL)

    for k,v in ipairs(itemdata) do
        local panel = vgui.Create("DPanel",scroll)
        panel:Dock(TOP)
        panel:SetHeight(40)
        panel:DockMargin(0,10,0,0)
        panel.Paint = function()end

        local button = vgui.Create("DButton",panel)
        button:Dock(FILL)
        if LocalPlayer():CanAfford(v.Cost) then
            elevel.MakeButton(button,v.PrintName.." - "..v.Cost.."XP",elevel.green)
        else
            elevel.MakeButton(button,v.PrintName.." - "..v.Cost.."XP",elevel.red)
        end
        button.DoClick = function()
            frame:Close()
            elevel:RequestPurchase(v)
        end

    end

end)