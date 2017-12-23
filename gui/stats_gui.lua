module("lurpg_stats_gui", package.seeall)
require "stats/functions"

function close_GUI(id)
	if game.players[id].gui.top.lurpg_stats_gui then
		game.players[id].gui.top.lurpg_stats_gui.destroy()
	end
end

function open_GUI(id)
	local crafted = global.players[id].stats.crafted or 0
	local mined = global.players[id].stats.mined or 0
	local built = global.players[id].stats.built or 0
	local walked = math.floor(global.players[id].stats.walked or 0)
	local researches = global.players[id].stats.research or 0

	local kills = global.stats.kills or 0
	local scans = global.stats.scanned or 0
	local ghostBuilt = global.stats.ghostbuilt or 0
	local ghostMined = global.stats.ghostmined or 0

	local str = global.players[id].attributes.strength
	local agi = global.players[id].attributes.agility
	local dex = global.players[id].attributes.dexterity
	local int = global.players[id].attributes.intelligence

	local frame1 = game.players[id].gui.top.add{type = "frame", name = "lurpg_stats_gui", direction = "vertical", caption = {"lurpg_stats_gui.title"}}
	local frameflow = frame1.add{type = "flow", name = "flow", direction = "vertical"}
	
	-- stats
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_crafted", (crafted)}}
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_mined", (mined)}}
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_built", (built)}}
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_walked", (walked)}}
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_researches", (researches)}}

	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_kills", (kills)}}
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_scans", (scans)}}
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_robotbuilt", (ghostBuilt)}}
	--frameflow.add{type = "label", caption = {"lurpg_stats_gui.stats_robotmined", (ghostMined)}}
	-- player attributes
	str_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.strength", (global.players[id].attributes.strength)}}
	str_label.tooltip = {"lurpg_stats_gui.strength_tooltip", kills, mined, built}
	agi_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.agility", (global.players[id].attributes.agility)}}
	agi_label.tooltip = {"lurpg_stats_gui.agility_tooltip", walked}
	dex_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.dexterity", (global.players[id].attributes.dexterity)}}
	dex_label.tooltip = {"lurpg_stats_gui.dexterity_tooltip", crafted, built}
	int_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.intelligence", (global.players[id].attributes.intelligence)}}
	int_label.tooltip = {"lurpg_stats_gui.intelligence_tooltip", kills, mined, ghostBuilt + ghostMined}
	-- resulting bonuses
	hp_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.health", 
		(game.entity_prototypes["player"].max_health + game.players[id].character_health_bonus)}}
	hp_label.tooltip = {"lurpg_stats_gui.health_tooltip"}

	invslots_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.invslots", 
		(game.entity_prototypes["player"].get_inventory_size(1) + game.players[id].character_inventory_slots_bonus)}}
	invslots_label.tooltip = {"lurpg_stats_gui.invslots_tooltip"}

	speed_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.speed", 
		(round(game.players[id].character_running_speed_modifier+1, 2))}}
	speed_label.tooltip = {"lurpg_stats_gui.speed_tooltip"}

	miningspeed_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.miningspeed", 
		(round(game.players[id].character_mining_speed_modifier+1, 2))}}
	miningspeed_label.tooltip = {"lurpg_stats_gui.miningspeed_tooltip"}

	craftspeed_label = frameflow.add{type = "label", caption = {"lurpg_stats_gui.craftspeed", 
		(round(game.players[id].character_crafting_speed_modifier+1, 2))}}
	craftspeed_label.tooltip = {"lurpg_stats_gui.craftspeed_tooltip"}
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end