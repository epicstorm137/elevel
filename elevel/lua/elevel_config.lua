elevel.Config = elevel.Config or {}

----//// General Config ////----

-- Usergroups that can access the admin commands (Excluding ULX)
elevel.Config.Admins = {
    ["superadmin"] = true,
}
-- Prefix for chat messages, make sure to add a space after
elevel.Config.ChatPrefix = "[ELevel] "

-- Set to true to enable HUD at top left of a player's XP and Level
elevel.Config.HUDEnable = true



----//// Leaderboard Config ////----

-- This is how far the text above the Leaderboard will render, 3000 is default
elevel.Config.LBRenderDist = 3000

-- Command to save leaderboard, will be elevel_[your command]
elevel.Config.LBSaveCmd = "savelb"

-- This is how often (in seconds) fresh leaderboard data will be networked to the clients, default is 60, requires restart to change
elevel.Config.LBNWTime = 60



----//// Parcel Config ////----

-- How much the minimum a parcel can give out
elevel.Config.ParcelLowerLimit = 10

-- How much the maximum a parcel can give out
elevel.Config.ParcelUpperLimit = 250

-- The max distance someone has to be to receive points, 250 is default
elevel.Config.ParcelXPDist = 250

-- The price a XP Parcel will cost in DarkRP F4, requires restart to change, requires DarkRP
elevel.Config.ParcelPrice = 1000000



----//// Printer Config ////----

-- This is the text that is displayed on the printer's header
elevel.Config.PrinterHeader = "ELevel Printer"

-- How much XP you get when you destroy someone elses printer
elevel.Config.PrinterDestroyXP = 50

-- Print time in seconds for the printer
elevel.Config.PrintTime = 60

-- The price a Printer will cost in DarkRP F4, requires restart to change, requires DarkRP
elevel.Config.PrinterPrice = 10000

-- This is how far the text on the Printer will render, 1000 is default
elevel.Config.PrinterRenderDist = 1000

-- This is how much charge the printer will be deducted by each print
elevel.Config.PrinterDeductCharge = 1



----//// Help NPC Config ////----

-- Text that is displayed above a Help NPC
elevel.Config.HNPCText = "ELevel Help"

-- This is the default model that will be used when you spawn a NPC in
elevel.Config.DefaultHNPCModel = "models/alyx.mdl"

-- Command to save the help npc, will be elevel_[your command]
elevel.Config.HNPCSaveCmd = "savehelpnpc"

-- This is how far the text above the NPC will render, 3000 is default
elevel.Config.HNPCRenderDist = 3000



----//// Shop NPC Config ////---- (If you want to add / remove items from the shop, go to 'sv_shopitems.lua')

-- Text that is displayed above a Shop NPC
elevel.Config.SNPCText = "ELevel Shop"

-- This is the default model that will be used when you spawn a NPC in
elevel.Config.DefaultSNPCModel = "models/alyx.mdl"

-- Command to save the shop npc, will be elevel_[your command]
elevel.Config.SNPCSaveCmd = "saveshopnpc"

-- This is how far the text above the NPC will render, 3000 is default
elevel.Config.SNPCRenderDist = 3000
