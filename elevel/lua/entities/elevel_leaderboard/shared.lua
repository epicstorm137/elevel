ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Leaderboard"
ENT.Author = "Epicstorm"
ENT.Category = "ELevel"
ENT.Spawnable = true

elevel.lb = elevel.lb or {}

local metaply = FindMetaTable("Player")

if SERVER then
    util.AddNetworkString("elevel_lb_networkdata")
    util.AddNetworkString("elevel_lb_forcenwdata")

    function metaply:NetworkLBVars()
        local query = sql.Query("SELECT * FROM elevel ORDER BY level DESC, xp DESC LIMIT 3;")
        net.Start("elevel_lb_networkdata")
        net.WriteData(util.Compress(util.TableToJSON(query)))
        net.Send(self)
    end

    timer.Create("elevel:lb:networkvars",elevel.Config.LBNWTime,0,function()
        for _,v in ipairs(player.GetAll()) do
            v:NetworkLBVars()
        end
    end)

    net.Receive("elevel_lb_forcenwdata",function(len,ply)
        if !elevel.Config.Admins[ply:GetUserGroup()] then return end

        for _,v in ipairs(player.GetAll()) do
            v:NetworkLBVars()
        end
        ply:PrintMessage(HUD_PRINTCONSOLE,"Forced refresh of server data!")
    end)
else
    elevel.lb.LBData = elevel.lb.LBData or {}
    elevel.lb.Default = {
        {
            ["Name"] = "No Player",
            ["SteamID"] = "STEAM_0:0:0",
            ["level"] = 0,
            ["xp"] = 0,
        },
        {
            ["Name"] = "No Player",
            ["SteamID"] = "STEAM_0:0:0",
            ["level"] = 0,
            ["xp"] = 0,
        },{
            ["Name"] = "No Player",
            ["SteamID"] = "STEAM_0:0:0",
            ["level"] = 0,
            ["xp"] = 0,
        }
    }
    
    net.Receive("elevel_lb_networkdata",function()
        table.Empty(elevel.lb.LBData)
        local data = util.JSONToTable(util.Decompress(net.ReadData(250000)))
        for k,v in ipairs(data) do
            if v.SteamID == "BOT" then data[k].Name = "BOT" else
                steamworks.RequestPlayerInfo(util.SteamIDTo64(v.SteamID),function(name)
                    data[k].Name = string.Left(name,20)
                end)
            end
            table.insert(elevel.lb.LBData,v)
        end
        for k,v in ipairs(elevel.lb.Default) do
            table.insert(elevel.lb.LBData,v)
        end
        elevel:SetCanDrawLB( true )
    end)

end