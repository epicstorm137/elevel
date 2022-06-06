local CATEGORY_NAME = "ELevel"

function ulx.givexp( calling_ply, target_plys, amount )
	for i=1, #target_plys do
		target_plys[ i ]:AddXP( amount )
	end
	ulx.fancyLogAdmin( calling_ply, "#A added #i xp to #T", amount, target_plys )
end
local xp = ulx.command( CATEGORY_NAME, "ulx addxp", ulx.givexp, "!addxp" )
xp:addParam{ type=ULib.cmds.PlayersArg }
xp:addParam{ type=ULib.cmds.NumArg, min=-2^32/2-1, max=2^32/2-1, hint="xp", ULib.cmds.round }
xp:defaultAccess( ULib.ACCESS_ADMIN )
xp:help( "Adds XP to the target(s)." )

function ulx.takexp( calling_ply, target_plys, amount )
	for i=1, #target_plys do
		target_plys[ i ]:AddXP( -amount )
	end
	ulx.fancyLogAdmin( calling_ply, "#A removed #i xp from #T", amount, target_plys )
end
local rxp = ulx.command( CATEGORY_NAME, "ulx removexp", ulx.takexp, "!removexp" )
rxp:addParam{ type=ULib.cmds.PlayersArg }
rxp:addParam{ type=ULib.cmds.NumArg, min=-2^32/2-1, max=2^32/2-1, hint="xp", ULib.cmds.round }
rxp:defaultAccess( ULib.ACCESS_ADMIN )
rxp:help( "Removes XP to the target(s)." )