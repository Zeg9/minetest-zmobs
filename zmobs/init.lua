-- ZMobs by Zeg9
-- Released under WTFPL for code,
--  CC BY-SA 3.0 for data (models and textures)
--  see README.txt for more information.

-- API (only about registering eggs, but never mind)
zmobs = {}
function zmobs:register_egg(modname, mobname, mobdesc)
	minetest.register_craftitem(modname..":egg_"..mobname, {
		description = mobdesc.." egg",
		inventory_image = modname.."_egg_"..mobname..".png",
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			-- Call on_rightclick if the pointed node defines it
			if placer and not placer:get_player_control().sneak then
				local n = minetest.get_node(pointed_thing.under)
				local nn = n.name
				if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
					return minetest.registered_nodes[nn].on_rightclick(pointed_thing.under, n, placer, itemstack) or itemstack
				end
			end
			-- Actually spawn the mob
			minetest.env:add_entity(pointed_thing.above, modname..":"..mobname)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
end

-- Items

minetest.register_craftitem("zmobs:lava_orb", {
	description = "Lava orb",
	inventory_image = "zmobs_lava_orb.png",
	on_place = function(itemstack, placer, pointed_thing)
	end,
})

-- Mobs
mobs:register_mob("zmobs:mese_monster", {
	type = "monster",
	hp_max = 10,
	collisionbox = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "zmobs_mese_monster.x",
	textures = {"zmobs_mese_monster.png"},
	visual_size = {x=1, y=1},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 0.5,
	run_velocity = 2,
	damage = 3,
	drops = {
		{name = "default:mese",
		chance = 9,
		min = 1,
		max = 1,},
		{name = "default:mese_crystal",
		chance = 9,
		min = 1,
		max = 3,},
		{name = "default:mese_crystal_fragment",
		chance = 1,
		min = 1,
		max = 9,},
		{name = "zmobs:egg_mese_monster",
		chance = 3,
		min = 1,
		max = 1,},
	},
	light_resistant = true,
	armor = 80,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	attack_type = "shoot",
	arrow = "zmobs:mese_arrow",
	shoot_interval = .5,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	}
})
mobs:register_spawn("zmobs:mese_monster", {"default:stone"}, 3, -1, 5000, 3, 0)
zmobs:register_egg("zmobs","mese_monster","Mese monster")

mobs:register_arrow("zmobs:mese_arrow", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	textures = {"default_mese_crystal_fragment.png"},
	velocity = 5,
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=1},
		}, vec)
	end,
	hit_node = function(self, pos, node)
	end
})


mobs:register_mob("zmobs:lava_flan", {
	type = "monster",
	hp_max = 10,
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5},
	visual = "mesh",
	mesh = "zmobs_lava_flan.x",
	textures = {"zmobs_lava_flan.png"},
	visual_size = {x=1, y=1},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 0.5,
	run_velocity = 2,
	damage = 3,
	drops = {
		{name = "zmobs:lava_orb",
		chance = 15,
		min = 1,
		max = 1,},
		{name = "zmobs:egg_lava_flan",
		chance = 2,
		min = 1,
		max = 1,},
	},
	light_resistant = true,
	armor = 80,
	drawtype = "front",
	water_damage = 5,
	lava_damage = 0,
	light_damage = 0,
	attack_type = "dogfight",
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 8,
		walk_start = 10,
		walk_end = 18,
		run_start = 20,
		run_end = 28,
		punch_start = 20,
		punch_end = 28,
	}
})
mobs:register_spawn("zmobs:lava_flan", {"default:lava_source"}, 15, -1, 1000, 10, 0)
zmobs:register_egg("zmobs","lava_flan","Lava flan")


mobs:register_mob("zmobs:spider", {
	type = "animal",
	hp_max = 2,
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	visual = "mesh",
	mesh = "zmobs_spider.x",
	textures = {"zmobs_spider.png"},
	makes_footstep_sound = false,
	walk_velocity = 1,
	armor = 200,
	drops = {},
	drawtype = "front",
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 20,
		stand_start = 0,
		stand_end = 8,
		walk_start = 10,
		walk_end = 18,
		run_start = 10,
		run_end = 18,
		punch_start = 10,
		punch_end = 18,
	}
})
mobs:register_spawn("zmobs:spider", {"default:wood"}, 15, -1, 100, 3, 0)


-- TODO
--- Make cobwebs for spiders (requires on_step)

