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
			-- TODO: handle this with the paintroller from the colormachine	
			on_punch = function( pos, node, puncher, pointed_thing )
				minetest.swap_node( pos, {name=node.name, param2=(node.param2+8)});
			end,
on_use = function(itemstack, user, pointed_thing)
  local meta = itemstack:get_meta();
  minetest.chat_send_player("singleplayer","itemstack: "..minetest.serialize( meta:to_table() ));
end,
			});

	elseif( def.paramtype2 == "facedir" ) then
		minetest.override_item( node_name, {
			paramtype2 = "colorfacedir",
			palette = "colorfacedir_palette.png", --"unifieddyes_palette_colorwallmounted.png",
			on_punch = function( pos, node, puncher, pointed_thing )
				minetest.swap_node( pos, {name=node.name, param2=(node.param2+32)});
			end,
			});
	else
		print("[morecolor] ERROR: No color support possible for "..tostring( node_name )..
			" due to drawtype: "..tostring(def.drawtpye).." and paramtype2: "..tostring(def.paramtype2));
	end
end


-- color those nodes from default that look pretty acceptable
morecolor.make_colorful("default:clay");
morecolor.make_colorful("default:stone");
morecolor.make_colorful("default:cobble");
morecolor.make_colorful("default:sandstone");
morecolor.make_colorful("default:sandstone_brick");
morecolor.make_colorful("default:silver_sandstone");
morecolor.make_colorful("default:silver_sandstone_brick");
morecolor.make_colorful("default:gravel");
morecolor.make_colorful("default:steelblock");
morecolor.make_colorful("default:cloud");

morecolor.make_colorful("default:wood");
morecolor.make_colorful("default:aspen_wood");
morecolor.make_colorful("default:pine_wood");
morecolor.make_colorful("default:junglewood"); -- does not really work
morecolor.make_colorful("default:brick"); -- looks horrible
morecolor.make_colorful("default:chest");
morecolor.make_colorful("cottages:wool_tent");

morecolor.make_colorful("default:coral_skeleton");

-- stairs and slabs etc work fine
morecolor.make_colorful("stairs:stair_aspen_wood");
morecolor.make_colorful("stairs:slab_aspen_wood");


-- more for..fun..and testing
morecolor.make_colorful("default:dirt_with_grass");
morecolor.make_colorful("cottages:roof_straw");

morecolor.make_colorful("doors:door_steel_a");
morecolor.make_colorful("doors:door_steel_b");
