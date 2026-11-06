select(2, ...).SetupGlobalFacade()

DungeonGuideInfos = { }

local function addGuide(guideID, description, templateName, condition)
	table.insert(DungeonGuideInfos, {
		description = description,
		group = "Mazmorras",
		condition = condition,
		moduleID = "Dungeons",
		guideID = guideID,
		templateName = templateName,
	})
end

addGuide("DNG_HD1316RFC", "13-16 Sima Ígnea", "JoanasGuides-HD1316RFC", "HORDE")
addGuide("DNG_HD1516ROL", "15-20 Ruinas de Lordaeron", "JoanasGuides-HD1516ROL", "HORDE")
addGuide("DNG_AD1721DM", "17-21 Las Minas de la Muerte", "JoanasGuides-AD1721DM", "ALLIANCE")
addGuide("DNG_AD1722WC", "17-22 Las Cuevas de los Lamentos", "JoanasGuides-AD1722WC", "ALLIANCE")
addGuide("DNG_HD1722WC", "17-22 Las Cuevas de los Lamentos", "JoanasGuides-HD1722WC", "HORDE")
addGuide("DNG_HD1826SFK", "18-26 Castillo de Colmillo Oscuro", "JoanasGuides-HD1826SFK", "HORDE")
addGuide("DNG_HD2228BFD", "22-28 Cavernas de Brazanegra", "JoanasGuides-HD2228BFD", "HORDE")
addGuide("DNG_AD2228BFD", "22-28 Cavernas de Brazanegra", "JoanasGuides-AD2228BFD", "ALLIANCE")
addGuide("DNG_AD2329ST", "23-29 Las Mazmorras", "JoanasGuides-AD2329ST", "ALLIANCE")
addGuide("DNG_HD2632ESW", "26-32 Excavación: Los Humedales", "JoanasGuides-HD2632ESW", "HORDE")
addGuide("DNG_AD2433RFK", "24-33 Horado Rajacieno", "JoanasGuides-AD2433RFK", "ALLIANCE")
addGuide("DNG_HD2433RFK", "24-33 Horado Rajacieno", "JoanasGuides-HD2433RFK", "HORDE")
addGuide("DNG_AD2534GM", "25-34 Gnomeregan", "JoanasGuides-AD2534GM", "ALLIANCE")
addGuide("DNG_HD2534GM", "25-34 Gnomeregan", "JoanasGuides-HD2534GM", "HORDE")
addGuide("DNG_HD2833COD", "28-33 Ciudad de Dalaran", "JoanasGuides-HD2833COD", "HORDE")
addGuide("DNG_AD3042SM", "30-42 Monasterio Escarlata", "JoanasGuides-AD3042SM", "ALLIANCE")
addGuide("DNG_HD3042SM", "30-42 Monasterio Escarlata", "JoanasGuides-HD3042SM", "HORDE")
addGuide("DNG_AD3441RFD", "34-41 Zahúrda Rojocieno", "JoanasGuides-AD3441RFD", "ALLIANCE")
addGuide("DNG_HD3441RFD", "34-41 Zahúrda Rojocieno", "JoanasGuides-HD3441RFD", "HORDE")
addGuide("DNG_AD3647ULD", "36-47 Uldaman", "JoanasGuides-AD3647ULD", "ALLIANCE")
addGuide("DNG_HD3647ULD", "36-47 Uldaman", "JoanasGuides-HD3647ULD", "HORDE")
addGuide("DNG_AD4348ZF", "43-48 Zul'Farrak", "JoanasGuides-AD4348ZF", "ALLIANCE")
addGuide("DNG_HD4348ZF", "43-48 Zul'Farrak", "JoanasGuides-HD4348ZF", "HORDE")
addGuide("DNG_AD4251MD", "42-51 Maraudon", "JoanasGuides-AD4251MD", "ALLIANCE")
addGuide("DNG_HD4251MD", "42-51 Maraudon", "JoanasGuides-HD4251MD", "HORDE")
addGuide("DNG_AD4755TST", "47-55 El Templo Sumergido", "JoanasGuides-AD4755TST", "ALLIANCE")
addGuide("DNG_HD4755TST", "47-55 El Templo Sumergido", "JoanasGuides-HD4755TST", "HORDE")
addGuide("DNG_AD4859BRD", "48-59 Profundidades de Roca Negra", "JoanasGuides-AD4859BRD", "ALLIANCE")
addGuide("DNG_HD4859BRD", "48-59 Profundidades de Roca Negra", "JoanasGuides-HD4859BRD", "HORDE")
addGuide("DNG_AD5458DME", "54-58 La Masacre - Este", "JoanasGuides-AD5458DME", "ALLIANCE")
addGuide("DNG_HD5458DME", "54-58 La Masacre - Este", "JoanasGuides-HD5458DME", "HORDE")
addGuide("DNG_BD5760DMW", "57-60 La Masacre - Oeste", "JoanasGuides-BD5760DMW")
addGuide("DNG_AD5760DMN", "57-60 La Masacre - Norte", "JoanasGuides-AD5760DMN", "ALLIANCE")
addGuide("DNG_HD5760DMN", "57-60 La Masacre - Norte", "JoanasGuides-HD5760DMN", "HORDE")
addGuide("DNG_HD5560LBRS", "55-60 Cumbre de Roca Negra - Inferior", "JoanasGuides-HD5560LBRS", "HORDE")
addGuide("DNG_HD5760UBRS", "57-60 Cumbre de Roca Negra - Superior", "JoanasGuides-HD5760UBRS", "HORDE")
addGuide("DNG_HD5760SCH", "57-60 Scholomance", "JoanasGuides-HD5760SCH", "HORDE")