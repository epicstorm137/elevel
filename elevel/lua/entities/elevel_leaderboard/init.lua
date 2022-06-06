AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("elevel_savelb")

function ENT:Initialize()
    self:SetModel("models/props/cs_assault/billboard.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(false)
    end
    
end

function elevel.lb:SaveEnts()
	local data = {}
	for k ,v in pairs(ents.FindByClass("elevel_leaderboard")) do
		table.insert(data, {pos = v:GetPos(), ang = v:GetAngles()})
	end
	if not file.Exists("elevel/leaderboard" , "DATA") then
		file.CreateDir("elevel/leaderboard")
	end

	file.Write("elevel/leaderboard/"..game.GetMap()..".json", util.TableToJSON(data))
end

function elevel.lb:RemoveEnts()
	for k,v in ipairs(ents.FindByClass("elevel_leaderboard")) do
		v:Remove()
	end
end

function elevel.lb:LoadEnts()
	if file.Exists("elevel/leaderboard/"..game.GetMap()..".json" , "DATA") then
		local data = file.Read("elevel/leaderboard/"..game.GetMap()..".json", "DATA")
		data = util.JSONToTable(data)
		for k, v in pairs(data) do
			local slot = ents.Create("elevel_leaderboard")
			slot:SetPos(v.pos)
			slot:SetAngles(v.ang)
			slot:Spawn()
		end
		print("[ELevel] Finished loading "..#data.." Leaderboards.")
	else
		print("[ELevel] No map data found for Leaderboards. Please place some and do elevel_"..elevel.Config.LBSaveCmd.." to create the data.")
	end
end

hook.Add("InitPostEntity", "elevel:spawnlb", elevel.lb.LoadEnts)
hook.Add("PostCleanupMap","elevel:respawnlb", elevel.lb.LoadEnts)

net.Receive("elevel_savelb",function(len,ply)
    if !elevel.Config.Admins[ply:GetUserGroup()] then return end

    elevel.lb:SaveEnts()
    elevel.lb:RemoveEnts()
    elevel.lb:LoadEnts()

    ply:ELMessage("Saved Leaderboards for "..game.GetMap().."!")
end)