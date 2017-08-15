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
			palette = "morecolor_facedir_8colors_palette.png",
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

-- tell the colormachine about the palettes added here
if( minetest.get_modpath( "colormachine")) then
	local palette_name = "morecolor_facedir_8colors_palette.png";
	-- this palette supports only 8 colors
	colormachine.dye_palette_colors[     palette_name ] = { "red","orange","yellow","green","blue","magenta"};
	-- normal shade only
	colormachine.dye_palette_shades[     palette_name ] = { ''};
	-- ..plus white and grey
	colormachine.dye_palette_grey_names[ palette_name ] = { "white", "grey"};
	-- the 8-color-palette is so small that we can easily add it manually here
	colormachine.dye_palette[            palette_name ] = {
		{ -1, -1,  1, "dye:white",    0, "ffffff"}, -- 1
		{  1,  3, -1, "dye:red",      1, "8b0000"}, -- 2
		{  2,  3, -1, "dye:orange",   2, "ffa500"}, -- 3
		{  3,  3, -1, "dye:yellow",   3, "eeee00"}, -- 4
		{  5,  3, -1, "dye:green",    4, "006400"}, -- 5
		{  9,  3, -1, "dye:blue",     5, "00008b"}, -- 6
		{ -1, -1,  3, "dye:grey",     6, "808080"}, -- 7
		{ 11,  3, -1, "dye:magenta",  7, "ff1493"}, -- 8
	};

	local palette_name = "unifieddyes_palette_colorwallmounted.png";
	-- more or less standard colors provided by the colormachine
	colormachine.dye_palette_colors[     palette_name ] = {
		"red","orange","yellow","lime","green","spring","cyan","azure","blue","violet","magenta","rose"};
	-- pretty much the standard shades used by the colormachine
	colormachine.dye_palette_shades[     palette_name ] = {
		'light_', '', 'medium_', 'dark_'};

	-- 24 colors
	-- we have some left (standard: 15 dyes)
	-- dark green is darker than normal green; necessary because
	-- the colors ought to be the same as for the 8-color-palette
	colormachine.dye_palette[ "unifieddyes_palette_colorwallmounted.png"] = {
		{ -1, -1,  1, "dye:white",      0, "ffffff"}, --  1 white
		{ -1, -1,  2, "",               1, "bfbfbf"}, --  2 light grey
		{ -1, -1,  3, "dye:grey",       2, "808080"}, --  3 grey
		{ -1, -1,  4, "dye:dark_grey",  3, "404040"}, --  4 dark grey
		{ -1, -1,  5, "dye:black",      4, "141414"}, --  5 black

		{  8,  1, -1, "",               5, "8080ff"}, --  6 azure?
		{  2,  4, -1, "dye:brown",      6, "aa5500"}, --  7 ocker brown
		{ 12,  1, -1, "dye:pink",       7, "ffc1da"}, --  8 pink

		{  1,  1, -1, "",               8, "ff0000"}, --  9 bright red
		{  2,  1, -1, "dye:orange",     9, "ff8000"}, -- 10 bright orange
		{  3,  1, -1, "dye:yellow",    10, "ffff00"}, -- 11 bright yellow
		{  5,  1, -1, "",              11, "00ff00"}, -- 12 bright green
		{  7,  1, -1, "",              12, "00ffff"}, -- 13 bright cyan
		{  9,  1, -1, "",              13, "0000ff"}, -- 14 bright blue
		{ 10,  1, -1, "",              14, "8000ff"}, -- 15 bright violet
		{ 11,  1, -1, "dye:magenta",   15, "ff00ff"}, -- 16 bright magenta

		{  1,  3, -1, "dye:red",       16, "a80000"}, -- 17 dark red
		{  2,  3, -1, "",              17, "a85400"}, -- 18 dark orange
		{  3,  3, -1, "",              18, "a8a800"}, -- 19 dark yellow
		{  5,  3, -1, "dye:dark_green",19, "00a800"}, -- 20 dark green
		{  7,  3, -1, "dye:cyan",      20, "00a8a8"}, -- 21 dark cyan
		{  9,  3, -1, "",              21, "0000a8"}, -- 22 dark blue
		{ 10,  3, -1, "dye:violet",    22, "5400a8"}, -- 23 dark violet
		{ 11,  3, -1, "",              23, "a800a8"}, -- 24 dark magenta

		{  1,  5, -1, "",              24, "550000"}, -- 25 very dark red
		{  2,  5, -1, "",              25, "552a00"}, -- 26 also: very dark orange
		{  3,  5, -1, "",              26, "555500"}, -- 27 very dark yellow
		{  5,  5, -1, "dye:green",     27, "005500"}, -- 28 (very dark green)
		{  7,  5, -1, "",              28, "005500"}, -- 29 very dark cyan
		{  9,  5, -1, "dye:blue",      29, "000055"}, -- 30 (very dark blue)
		{ 10,  5, -1, "",              30, "2a0055"}, -- 31 very dark violet
		{ 11,  5, -1, "",              31, "550055"}, -- 32 very dark mangeta
	};
end
