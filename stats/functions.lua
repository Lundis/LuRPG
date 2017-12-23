module("stats_functions", package.seeall)


function increment_stat(playerId, stat, amount)
	global.players[playerId].stats[stat] = 
		amount + (global.players[playerId].stats[stat] or 0)
	
end

function increment_global_stat(stat, amount)
	global.stats[stat] = amount + (global.stats[stat] or 0)
end

function calculate_attributes(playerId)
	-- player stats
	local crafted = global.players[playerId].stats.crafted or 0
	local mined = global.players[playerId].stats.mined or 0
	local built = global.players[playerId].stats.built or 0
	local walked = global.players[playerId].stats.walked or 0
	local researches = global.players[playerId].stats.research or 0

	-- global stats
	local kills = global.stats.kills or 0
	local scans = global.stats.scanned or 0
	local ghostBuild = global.stats.ghostbuild or 0
	local ghostMined = global.stats.ghostmined or 0

	local str_mult = settings.global["lurpg-attr-str-mult"].value
	local agi_mult = settings.global["lurpg-attr-agi-mult"].value
	local dex_mult = settings.global["lurpg-attr-dex-mult"].value
	local int_mult = settings.global["lurpg-attr-int-mult"].value
	
	local str_exp = str_mult * (kills / 1000 + mined / 100 + built / 1000)
	local agi_exp = agi_mult * (walked / 100000)
	local dex_exp = dex_mult * (crafted / 100 + built / 1000)
	local int_exp = int_mult * (scans + researches + ghostBuild / 1000 + ghostMined / 1000)

	local str_base = settings.global["lurpg-attr-str-base"].value
	local agi_base = settings.global["lurpg-attr-agi-base"].value
	local dex_base = settings.global["lurpg-attr-dex-base"].value
	local int_base = settings.global["lurpg-attr-int-base"].value
	
	local str = math.floor(math.log(1 + str_exp, str_base))
	local agi = math.floor(math.log(1 + agi_exp, agi_base))
	local dex = math.floor(math.log(1 + dex_exp, dex_base))
	local int = math.floor(math.log(1 + int_exp, int_base))

	global.players[playerId].attributes.strength = str
	global.players[playerId].attributes.agility = agi
	global.players[playerId].attributes.dexterity = dex
	global.players[playerId].attributes.intelligence = int


	game.players[playerId].character_health_bonus = math.floor(       5*str +                           int)
	game.players[playerId].character_mining_speed_modifier =    0.01 *str + 0.01 *agi + 0.01*dex 
	game.players[playerId].character_crafting_speed_modifier =                          0.1 *dex + 0.01*int
	game.players[playerId].character_running_speed_modifier =  
		math.min(game.players[playerId].mod_settings["lurpg-player-max-speed-bonus"].value, 
			settings.global["lurpg-map-max-speed-bonus"].value, 0.01 *str + 0.1  *agi)
	game.players[playerId].character_inventory_slots_bonus = math.min(math.floor(str), 140)
	
end


function update_walking_distance(playerId)
	local lastPosition = global.players[playerId].lastPosition
	local position = game.players[playerId].position

	global.players[playerId].stats.walked = 
		get_distance(lastPosition, position) + (global.players[playerId].stats.walked or 0)
end


function get_distance(pos1, pos2)
    -- Get the length for each of the components x and y
    local xDist = pos1.x - pos2.x
    local yDist = pos1.y - pos2.y

    return math.sqrt(xDist^2 + yDist^2)
end

function create_player(playerId)
	-- if first player ever, create global tables
	if not global.stats then 
		global.stats = {
			kills = 0,
			researches = 0,
			scans = 0,
			crafted = 0,
			mined = 0,
			ghostmined = 0,
			ghostbuild = 0,
		}
	end
	if not global.players then
		global.players = {}
	end
	global.players[playerId] =
	{
		alive = true,
		statsGUIActive = false,
		lastPosition = game.players[playerId].position,
		attributes = {
			strength = 0,
			agility = 0,
			dexterity = 0,
			intelligence = 0
		},
		stats = {},
	}

end

function update_research_points()
	for id, _ in pairs(global.players) do
		global.players[id].stats["research"] = #game.players[id].force.technologies
	end
end
