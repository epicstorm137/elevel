local metaply = FindMetaTable("Player")

if SERVER then
    util.AddNetworkString("elevel_plymsg")
    util.AddNetworkString("elevel_plynotif")
    util.AddNetworkString("elevel_clientready")
    util.AddNetworkString("elevel_openshopmenu")
    util.AddNetworkString("elevel_requestpurchase")

    hook.Add("ELevel.LevelUp","elevel:notify",function(ply, level)
        ply:ELMessage("Leveled up to level "..level.."!")
    end)

    timer.Create("elevel:givepassivexp",300,0,function()
        for k,v in ipairs(player.GetAll()) do
            v:AddXP(15)
        end
    end)

    net.Receive("elevel_clientready",function(len,ply)
        ply:CheckXPAccount()
        ply:NetworkLBVars()

        local xp, level = ply:GetStoredXP(), ply:GetStoredLevel()
        ply:SetNWInt("elevel:xp",xp)
        ply:SetNWInt("elevel:level",level)
    end)

    net.Receive("elevel_requestpurchase",function(len,ply)
        local item = util.JSONToTable(util.Decompress(net.ReadData(102000000)))
        ply:PurchaseItem( item )
    end)

    function metaply:ELMessage( str )
        net.Start("elevel_plymsg")
            net.WriteString(str)
        net.Send(self)
    end

    function metaply:ELNotify( str, time, color )
        net.Start("elevel_plynotif")
            net.WriteString(str)
            net.WriteInt( time, 32 )
            net.WriteColor(color)
        net.Send(self)
    end

    function metaply:NetworkShopData()
        net.Start("elevel_openshopmenu")
            net.WriteData(util.Compress(util.TableToJSON(elevel:GetShopData())))
        net.Send( self )
    end
    
else
    hook.Add("InitPostEntity","elevel:clientready",function()
        MsgC(elevel.red,"[ELevel] ",color_white,"Client ready for Network Messages, telling server!\n")
        net.Start("elevel_clientready")
        net.SendToServer()
    end)

    function elevel:ELMessage( str )
        chat.AddText(elevel.green,elevel.Config.ChatPrefix,color_white,str)
    end

    net.Receive("elevel_plymsg",function()
        elevel:ELMessage(net.ReadString())
    end)

    net.Receive("elevel_plynotif",function(len, ply)
        elevel:Notify(net.ReadString(), net.ReadInt(32), net.ReadColor())
    end)

    function elevel:RequestPurchase( tbl )
        if !LocalPlayer():CanAfford(tbl.Cost) then 
            elevel:ELMessage("Error: You cannot afford this!")
            return 
        end
        net.Start("elevel_requestpurchase")
            net.WriteData(util.Compress(util.TableToJSON(tbl)))
        net.SendToServer()
    end
    
end