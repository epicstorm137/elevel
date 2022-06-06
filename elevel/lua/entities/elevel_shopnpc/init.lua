include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("elevel_saveshopnpc")

function ENT:Initialize()

	self:SetModel(elevel.Config.DefaultSNPCModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
	self:DropToFloor()

end

function ENT:Use( activator )

	if ( activator:IsPlayer() ) then

		activator:NetworkShopData()
	
	end

end

function elevel.shop.npc:SaveEnts()
	local data = {}
	for k ,v in pairs(ents.FindByClass("elevel_shopnpc")) do
		table.insert(data, {pos = v:GetPos(), ang = v:GetAngles()})
	end
	if not file.Exists("elevel/shopnpc" , "DATA") then
		file.CreateDir("elevel/shopnpc")
	end

	file.Write("elevel/shopnpc/"..game.GetMap()..".json", util.TableToJSON(data))
end

function elevel.shop.npc:RemoveEnts()
	for k,v in ipairs(ents.FindByClass("elevel_shopnpc")) do
		v:Remove()
	end
end

function elevel.shop.npc:LoadEnts()
	if file.Exists("elevel/shopnpc/"..game.GetMap()..".json" , "DATA") then
		local data = file.Read("elevel/shopnpc/"..game.GetMap()..".json", "DATA")
		data = util.JSONToTable(data)
		for k, v in pairs(data) do
			local slot = ents.Create("elevel_shopnpc")
			slot:SetPos(v.pos)
			slot:SetAngles(v.ang)
			slot:Spawn()
		end
		print("[ELevel] Finished loading "..#data.." Shop NPC's.")
	else
		print("[ELevel] No map data found for Shop NPC's. Please place some and do elevel_"..elevel.Config.SNPCSaveCmd.." to create the data.")
	end
end

hook.Add("InitPostEntity", "elevel:spawnsnpc", elevel.shop.npc.LoadEnts)
hook.Add("PostCleanupMap","elevel:respawnsnpc", elevel.shop.npc.LoadEnts)

net.Receive("elevel_saveshopnpc",function(len,ply)
    if !elevel.Config.Admins[ply:GetUserGroup()] then return end

    elevel.shop.npc:SaveEnts()
    elevel.shop.npc:RemoveEnts()
    elevel.shop.npc:LoadEnts()

    ply:ELMessage("Saved Shop NPC's for "..game.GetMap().."!")
end)