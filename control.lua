require "gui/stats_gui"
require "script/stats/functions"

-- player hooks
script.on_event(defines.events.on_player_created, function(event)
	stats_functions.create_player(event.player_index)
end)

script.on_event(defines.events.on_player_respawned, function(event)
	local id = event.player_index
	global.players[id].Alive = true
end)

script.on_event(defines.events.on_player_died, function(event)
	local id = event.player_index
	global.players[id].Alive = false
end)

-- workaround for when this mod is not loaded at startup
script.on_event(defines.events.on_player_joined_game, function(event)
	if not global.players or not global.players[event.player_index] then
		stats_functions.create_player(event.player_index)
	end
end)


-- game event hooks
script.on_event(defines.events.on_player_crafted_item, function(event)
	stats_functions.increment_global_stat("crafted", event.item_stack.count)
	stats_functions.increment_stat(event.player_index, "crafted", event.item_stack.count)
end)

script.on_event(defines.events.on_player_mined_item, function(event)
	stats_functions.increment_global_stat("mined", event.item_stack.count)
	stats_functions.increment_stat(event.player_index, "mined", event.item_stack.count)
end)

script.on_event(defines.events.on_built_entity, function(event)
	stats_functions.increment_stat(event.player_index, "built", 1)
end)

script.on_event(defines.events.on_robot_mined, function(event)
	stats_functions.increment_global_stat("ghostmined", event.item_stack.count)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	stats_functions.increment_global_stat("ghostbuild", 1)
end)

script.on_event(defines.events.on_sector_scanned, function(event)
	stats_functions.increment_global_stat("scans", 1)
end)

script.on_event(defines.events.on_entity_died, function(event)
	if event.force.name == "player" then
		stats_functions.increment_global_stat("kills", 1)
	end
end)


script.on_event(defines.events.on_research_finished, function(event)
	stats_functions.update_research_points()
end)


script.on_event(defines.events.on_tick, function(event)
	if event.tick%(60)==0 then
		if not global.players then
			-- mod has not been setup properly.
			for id, p in pairs(game.players) do
				stats_functions.create_player(id)
			end
			stats_functions.update_research_points()
		end
		for id, v in pairs(global.players) do
			local player = game.players[id]
			-- refresh stats gui
			if player.connected and v.statsGUIActive and v.Alive then
				lurpg_stats_gui.close_GUI(id)
				lurpg_stats_gui.open_GUI(id)
			end
			-- calculate walking distance
			stats_functions.update_walking_distance(id)
			-- calculate new attributes for all players
			stats_functions.calculate_attributes(id)
		end
	end
end)

-- keybinding hooks
script.on_event("lurpg-toggle-stats", function(event)
	local id = event.player_index
	if global.players[id].statsGUIActive then
		global.players[id].statsGUIActive = false
		lurpg_stats_gui.close_GUI(id)
	else
		global.players[id].statsGUIActive = true
		lurpg_stats_gui.open_GUI(id)
	end
end)