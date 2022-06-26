local wezterm = require("wezterm");
wezterm.on("update-right-status", function(window, pane)
	local cells = {};
	local cwd_uri = pane:get_current_working_dir();
	if cwd_uri then
		cwd_uri = cwd_uri:sub(8);
		local slash = cwd_uri:find("/");
		local cwd = "";
		local hostname = "";
		if slash then
			hostname = cwd_uri:sub(1, slash - 1);
			local dot = hostname:find("[.]");
			if dot then
				hostname = hostname:sub(1, dot - 1);
			end;
			cwd = cwd_uri:sub(slash);
			table.insert(cells, cwd);
			table.insert(cells, hostname);
		end;
	end;
	local date = wezterm.strftime("%a %b %-d %H:%M");
	table.insert(cells, date);
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100));
	end;
	local LEFT_ARROW = utf8.char(57523);
	local SOLID_LEFT_ARROW = utf8.char(57522);
	local colors = {
		"#3c1361",
		"#52307c",
		"#663a82",
		"#7c5295",
		"#b491c8"
	};
	local text_fg = "#c0c0c0";
	local elements = {};
	local num_cells = 0;
	function push(text, is_last)
		local cell_no = num_cells + 1;
		table.insert(elements, {
			Foreground = {
				Color = text_fg
			}
		});
		table.insert(elements, {
			Background = {
				Color = colors[cell_no]
			}
		});
		table.insert(elements, {
			Text = " " .. text .. " "
		});
		if not is_last then
			table.insert(elements, {
				Foreground = {
					Color = colors[cell_no + 1]
				}
			});
			table.insert(elements, {
				Text = SOLID_LEFT_ARROW
			});
		end;
		num_cells = num_cells + 1;
	end;
	while #cells > 0 do
		local cell = table.remove(cells, 1);
		push(cell, #cells == 0);
	end;
	window:set_right_status(wezterm.format(elements));
end);
function do_tables_match(a, b)
	return table.concat(a) == table.concat(b);
end;
function shuffle(t)
	local tbl = {};
	for i = 1, #t do
		tbl[i] = t[i];
	end;
	for i = #tbl, 2, -1 do
		local j = math.random(i);
		tbl[i], tbl[j] = tbl[j], tbl[i];
	end;
	if do_tables_match(t, tbl) then
		tbl = shuffle(t);
	end;
	return tbl;
end;
return {
	font = wezterm.font_with_fallback(shuffle({
		"Recursive",
	        "Rec Mono Casual",
		"Rec Mono Duotone",
		"Rec Mono Linear",
		"Rec Mono Semicasual"
	})),
	font_size = 18.6,
	-- color_scheme = "AlienBlood",
	-- color_scheme = "Batman",
	-- color_scheme = "Espresso",
	-- color_scheme = "Fideloper",
	-- color_scheme = "Dracula+",
	-- color_scheme = "ToyChest",
	color_scheme = shuffle({
		"AlienBlood",
		"Galaxy",
		"Batman",
		"Espresso",
		"Dracula",
		"Dracula+",
		"N0tch2k",
		"Desert",
		"darkmatrix",
		"Ubuntu",
		"UltraViolent",
		"UltraDark",
		"UnderTheSea",
		"Urple",
		"Grape",
		"The Hulk",
		"ToyChest",
		"Zenburn",
		"Seafoam Pastel",
		"seoulbones_dark",
		"Sublette",
	})[1],
	-- color_scheme = "Sublette",
	exit_behavior = "Close",
	keys = {
		{
			key = "d",
			mods = "SUPER",
			action = wezterm.action({
				SplitHorizontal = {
					domain = "CurrentPaneDomain"
				}
			})
		},
		{
			key = "h",
			mods = "SUPER",
			action = wezterm.action({
				SplitVertical = {
					domain = "CurrentPaneDomain"
				}
			})
		},
		{
			key = "n",
			mods = "SUPER",
			action = "SpawnWindow"
		}
	},
	window_padding = {
		left = 5,
		right = 5,
		top = 0,
		bottom = 5
	},
	-- harfbuzz_features = {
	--	"zero"
	-- },
	scrollback_lines = 1000000,
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	term = "wezterm"
};
