Config = {}
Config.ShipmentCooldown = 120 -- minutes
Config.MafiaCooldown = 7200
Config.InterceptingCost = 10000 -- dirty money
Config.Duration = 900000 -- milliseconds
Config.ShipmentSetup = vector3(920.68,-1142.56,25.96)

Config.admins = {
	'steam:11000013af55e45', -- cfx
	'steam:110000119b9b40b', -- JIMBOY
	'steam:110000140412dff', -- DON B
}

Config.Shipments = {
	{ x = 910.10, y = -3078.89, z = 5.90 },
	{ x = 910.31, y = -3093.47, z = 5.90 },
	{ x = 924.44, y = -3098.74, z = 5.90 },
	{ x = 924.14, y = -3080.17, z = 5.90 },
	{ x = 938.14, y = -3080.44, z = 5.90 },
	{ x = 937.89, y = -3093.48, z = 5.90 },
	{ x = 955.05, y = -3093.40, z = 5.90 },
	{ x = 952.10, y = -3080.20, z = 5.90 },
	{ x = 816.97, y = -3080.07, z = 5.90 },
	{ x = 830.13, y = -3093.09, z = 5.90 },
	{ x = 831.14, y = -3077.48, z = 5.90 },
	{ x = 844.91, y = -3080.02, z = 5.90 },
	{ x = 844.93, y = -3090.69, z = 5.90 },
	{ x = 858.92, y = -3096.06, z = 5.90 },
	{ x = 859.20, y = -3077.29, z = 5.90 },
	{ x = 992.63, y = -3077.49, z = 5.90 },
	{ x = 1006.99, y = -3080.13, z = 5.90 },
	{ x = 1006.96, y = -3093.55, z = 5.90 },
	{ x = 1021.16, y = -3080.20, z = 5.90 },
	{ x = 1034.98, y = -3080.20, z = 5.90 },
	{ x = 1049.00, y = -3096.18, z = 5.90 },
	{ x = 1048.88, y = -3077.53, z = 5.90 },
	{ x = 896.50, y = -3031.72, z = 5.90 },
	{ x = 910.42, y = -3039.61, z = 5.90 },
	{ x = 924.52, y = -3026.37, z = 5.90 },
	{ x = 924.60, y = -3044.99, z = 5.90 },
	{ x = 938.48, y = -3026.30, z = 5.90 },
	{ x = 938.34, y = -3044.89, z = 5.90 },
	{ x = 952.48, y = -3026.33, z = 5.90 },
	{ x = 992.89, y = -3026.39, z = 5.90 },
	{ x = 1006.97, y = -3039.75, z = 5.90 },
	{ x = 1020.77, y = -3023.74, z = 5.90 },
	{ x = 1034.76, y = -3039.70, z = 5.90 },
	{ x = 1034.76, y = -3023.76, z = 5.90 },
	{ x = 1048.98, y = -3031.66, z = 5.90 },
	{ x = 1052.00, y = -3045.20, z = 5.90 },
	{ x = 1094.08, y = -3026.37, z = 5.90 },
	{ x = 1107.88, y = -3023.60, z = 5.90 },
	{ x = 1122.04, y = -3039.67, z = 5.90 },
	{ x = 1136.09, y = -3026.36, z = 5.90 },
	{ x = 1149.86, y = -3042.38, z = 5.90 },
	{ x = 1163.88, y = -3042.30, z = 5.90 },
	{ x = 1163.99, y = -3031.49, z = 5.90 },
	{ x = 1164.06, y = -3023.69, z = 5.90 },
	{ x = 896.24, y = -2973.94, z = 5.90 },
	{ x = 910.48, y = -2987.18, z = 5.90 },
	{ x = 924.44, y = -2971.33, z = 5.90 },
	{ x = 938.37, y = -2987.16, z = 5.90 },
	{ x = 965.39, y = -2978.93, z = 5.90 },
	{ x = 993.06, y = -2971.05, z = 5.90 },
	{ x = 992.99, y = -2993.43, z = 5.90 },
	{ x = 1006.94, y = -2973.84, z = 5.90 },
	{ x = 1020.97, y = -2978.83, z = 5.90 },
	{ x = 1034.96, y = -2973.58, z = 5.90 },
	{ x = 1048.95, y = -2973.91, z = 5.90 },
	{ x = 1048.71, y = -2989.87, z = 5.90 },
	{ x = 1094.14, y = -2989.78, z = 5.90 },
	{ x = 1107.92, y = -2973.26, z = 5.90 },
	{ x = 1121.90, y = -2973.58, z = 5.90 },
	{ x = 1148.77, y = -2976.12, z = 5.90 },
	{ x = 1149.85, y = -2989.75, z = 5.90 },
	{ x = 1177.01, y = -2989.52, z = 5.90 }
}

Config.ItemShipments = {
	{ name = "minismg_crate", minqty = 1, maxqty = 3 },
	{ name = "compactrif_crate", minqty = 1, maxqty = 3 },
	{ name = "assultrif_crate", minqty = 1, maxqty = 3 },		
	--{ name = "packed_crystalmeth", minqty = 1, maxqty = 3 },
	--{ name = "packed_weed", minqty = 1, maxqty = 3 },
	--{ name = "c4_bank", minqty = 1, maxqty = 1 },
	--{ name = "ammo_pistol", minqty = 24, maxqty = 42 },
	--{ name = "ammo_rifle", minqty = 60, maxqty = 120 },
	--{ name = "ammo_smg", minqty = 60, maxqty = 120 },
	--{ name = "ammo_shotgun", minqty = 16, maxqty = 36 },
	--{ name = "oxy", minqty = 1, maxqty = 2 },
	--{ name = "adrenaline", minqty = 1, maxqty = 2 },
	--{ name = "stitching_kit", minqty = 1, maxqty = 2 },
	--{ name = "advanced_lockpick", minqty = 1, maxqty = 2 },
	--{ name = "humane_id", minqty = 1, maxqty = 1 },
	--{ name = "rebreather", minqty = 1, maxqty = 2 },
	--{ name = "electric_sweeper", minqty = 1, maxqty = 1 },
	--{ name = "vpn_router", minqty = 1, maxqty = 1 },
	--{ name = "circuit_board", minqty = 1, maxqty = 1 },
	--{ name = "bolt_cutter", minqty = 1, maxqty = 2 },
	--{ name = "stolen_package", minqty = 1, maxqty = 1}
}

Config.admins = {
    'steam:11000013af55e45',
}