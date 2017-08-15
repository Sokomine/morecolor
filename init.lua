morecolor = {};

morecolor.make_colorful = function( node_name )
	if( not( node_name ) or not( minetest.registered_nodes[ node_name ])) then
		return;
	end
	local def = minetest.registered_nodes[ node_name ];

	-- only change those blocks that can be changed
	-- TODO: support "color" for these blocks and wallmounted for others
	if(     (not( def.drawtype ) or def.drawtype == "normal")
	    and (not( def.paramtype2 ) or def.paramtype2 == "none" or def.paramtype2 == "wallmounted")) then
		minetest.override_item( node_name, {
			paramtype2 = "colorwallmounted",
			-- TODO: use other palette for darker nodes
			palette = "unifieddyes_palette_colorwallmounted.png",
--[[
			-- TODO: handle this with the paintroller from the colormachine	
			on_punch = function( pos, node, puncher, pointed_thing )
				minetest.swap_node( pos, {name=node.name, param2=(node.param2+8)});
			end,
on_use = function(itemstack, user, pointed_thing)
  local meta = itemstack:get_meta();
  minetest.chat_send_player("singleplayer","itemstack: "..minetest.serialize( meta:to_table() ));
end,
--]]
			});

	elseif( def.paramtype2 == "facedir" ) then
		minetest.override_item( node_name, {
			paramtype2 = "colorfacedir",
			palette = "colorfacedir_palette.png", --"unifieddyes_palette_colorwallmounted.png",
--[[
			on_punch = function( pos, node, puncher, pointed_thing )
				minetest.swap_node( pos, {name=node.name, param2=(node.param2+32)});
			end,
--]]
			});
	else
		print("[morecolor] ERROR: No color support possible for "..tostring( node_name )..
			" due to drawtype: "..tostring(def.drawtpye).." and paramtype2: "..tostring(def.paramtype2));
	end
end


-- color those nodes from default that look pretty acceptable

-- very useful for chests
morecolor.make_colorful("default:chest");
morecolor.make_colorful("default:chest_locked");

-- nice mostly white blocks that do not come as stairs/slabs/etc
morecolor.make_colorful("default:coral_skeleton");
morecolor.make_colorful("default:cloud");
morecolor.make_colorful("default:gravel");

--morecolor.make_colorful("default:bronzeblock");
--morecolor.make_colorful("default:tinblock");

-- sand; does not exist as stair etc.
morecolor.make_colorful("default:desert_sand");
morecolor.make_colorful("default:sand");
morecolor.make_colorful("default:silver_sand");

-- some blocks that work quite well with paint
-- those blocks come as stairs and slabs as well
local materials = {
	-- very nice whiteish material for building (just a bit rare)
	"clay",
	-- metals; use only steel as those others would remove too
	-- many options for further colored metal blocks
	"steelblock",
	-- stony blocks
	"cobble","mossycobble","desert_cobble",
	"stone","stone_block", "stonebrick",
	"desert_stone", "desert_stone_block", "desert_stone_brick",
	"desert_sandstone", "desert_sandstone_block", "desert_sandstone_brick",
	"sandstone","sandstone_block", "sandstonebrick",
	"silver_sandstone","silver_sandstone_block", "silver_sandstone_brick",
	-- the diffrent wooden plank types
	"wood","junglewood","pine_wood","acacia_wood","aspen_wood"};
for i,m in ipairs( materials ) do
	morecolor.make_colorful("default:"..m);
	morecolor.make_colorful("stairs:stair_"..m);
	morecolor.make_colorful("stairs:slab_"..m);
	morecolor.make_colorful("stairs:stair_inner_"..m);
	morecolor.make_colorful("stairs:stair_outer_"..m);
end


-- support for xconnected
if( minetest.get_modpath( "xconnected" )) then
	woods = {"","_pine","_jungle","_acacia","_aspen"};
	local shapes = {"_c0", "_c1", "_c2", "_c3", "_c4", "_ln", "_lp" };
	for i,w in ipairs( woods ) do
		for j,n in ipairs( shapes ) do
			morecolor.make_colorful("xconnected:fence_"..w..n);
		end
	end
end

morecolor.make_colorful("cottages:wool_tent");
morecolor.make_colorful("cottages:loam");


if( minetest.get_modpath("wool")) then
	-- define two wool nodes
	local groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, wool = 1};
	minetest.register_node("morecolor:wool", {
		description = "Colorable Wool",
		tiles = {"wool_white.png"},
		is_ground_content = false,
		groups = groups,
		});
	stairs.register_stair_and_slab(
		"morecolorwool",
		"morecolor:wool",
		groups,
		{"wool_white.png"},
		"Colored Wool Stair",
		"Colored Wool Slab"
	);
	morecolor.make_colorful("morecolor:wool");
	local m = "coloredwool";
	morecolor.make_colorful("stairs:stair_"..m);
	morecolor.make_colorful("stairs:slab_"..m);
	morecolor.make_colorful("stairs:stair_inner_"..m);
	morecolor.make_colorful("stairs:stair_outer_"..m);

	minetest.register_node("morecolor:carpet", {
		description = "Colored Wool Carpet",
		drawtype = "nodebox",
		-- top, bottom, side1, side2, inner, outer
		tiles = {"wool_white.png"},
		paramtype = "light",
		-- "wallmounted" would be nice as it would allow more colors,
		-- but it would cause problems in other situations
		paramtype2 = "facedir",
		groups = groups,
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.50,  0.5, -0.5+1/16, 0.50},
				},
			},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.50,  0.5, -0.5+1/16, 0.50},
			},
		},
		on_place = minetest.rotate_node,
		is_ground_content = false,
		});
	morecolor.make_colorful("morecolor:carpet");

end

--morecolor.make_colorful("doors:door_steel_a");
--morecolor.make_colorful("doors:door_steel_b");
