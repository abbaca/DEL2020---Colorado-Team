cmd = UI::Command.new("Solid-to-Glass") {

a5 = UI.messagebox("Have all entities to be evaluated been selected? If nothing was selected, the whole model will be evaluated.", MB_YESNO)

if a5 == 6
	#a1 = UI.messagebox("Include roof amenity in calculation?", MB_YESNO)
	a6 = UI.inputbox(["Exterior surface layer count ", "Material name ", "Material name ", "Material name ", "Material name ", "Material name "], ["Single", "", "", "", "", ""], ["Single|Double", "", "", "", "", ""], "ALL EXTERIOR SURFACE MATERIALS, including glass")
	a2 = UI.inputbox(["Glass surface layer count ", "Material name ", "Material name ", "Material name ", "Material name ", "Material name "], ["Single", "", "", "", "", ""], ["Single|Double", "", "", "", "", ""], "EXTERIOR GLASS MATERIAL")
	a3 = 250 #roof amenity floor elevation in feet
	a4 = 0 #glass sill height at ground floor in feet

	if Sketchup.active_model.selection.count > 0
		e1 = Sketchup.active_model.selection
	else
		e1 = Sketchup.active_model.active_entities
	end

	lGlassArea = []
	lTotalArea = []
	lPositionG = []
	lPositionT = []
	lGlassI = []
	lTotalI = []
	dGlassArea = 0.0
	dSolidArea = 0.0
	dTotalArea = 0.0

	lExplode = e1

	x = 0

	while lExplode.count > 0 do
		lReview = []
		ii = 0
		v = lExplode.count
		while ii < v do
			if lExplode[ii].is_a? Sketchup::Group or lExplode[ii].is_a? Sketchup::ComponentInstance
				if lExplode[ii].visible? == true and lExplode[ii].layer.visible? == true
					iii = 0
					while iii < lExplode[ii].definition.entities.count
						if lExplode[ii].definition.entities[iii].is_a? Sketchup::Group or lExplode[ii].definition.entities[iii].is_a? Sketchup::ComponentInstance
							if lExplode[ii].definition.entities[iii].visible? == true and lExplode[ii].definition.entities[iii].layer.visible? == true
								lReview.insert(lReview.count, lExplode[ii].definition.entities[iii])
							end
						elsif lExplode[ii].definition.entities[iii].is_a? Sketchup::Face
							if lExplode[ii].definition.entities[iii].visible? == true and lExplode[ii].definition.entities[iii].layer.visible? == true and lExplode[ii].definition.entities[iii].normal != Geom::Vector3d.new(0, 0, 1) and lExplode[ii].definition.entities[iii].normal != Geom::Vector3d.new(0, 0, -1)
								if lExplode[ii].definition.entities[iii].material != nil 
									if lExplode[ii].definition.entities[iii].material.name == a6[5] or lExplode[ii].definition.entities[iii].material.name == a6[1] or lExplode[ii].definition.entities[iii].material.name == a6[2] or lExplode[ii].definition.entities[iii].material.name == a6[3] or lExplode[ii].definition.entities[iii].material.name == a6[4]
										lTotalArea.insert(lTotalArea.count, lExplode[ii].definition.entities[iii].area)
										if lExplode[ii].definition.entities[iii].outer_loop.vertices[0].position.z > lExplode[ii].definition.entities[iii].outer_loop.vertices[((lExplode[ii].definition.entities[iii].outer_loop.vertices.count / 2) - 0).round].position.z
											dZ = lExplode[ii].definition.entities[iii].outer_loop.vertices[((lExplode[ii].definition.entities[iii].outer_loop.vertices.count / 2) - 0).round].position.z
										else
											dZ = lExplode[ii].definition.entities[iii].outer_loop.vertices[0].position.z 
										end
										lPositionT.insert(lPositionT.count, dZ)
										i = 0
										if lTotalI.count < 1
											lTotalI.insert(i, lTotalI.count)
										else
											while i < lTotalI.count do
												if lPositionT[lPositionT.count - 1] < lPositionT[lTotalI[i]]
													lTotalI.insert(i, lTotalI.count)
													break
												end
												i += 1	
											end
											if lTotalI.count < lPositionT.count
												lTotalI.insert(lTotalI.count, lTotalI.count)
											end
										end
									end			
									if lExplode[ii].definition.entities[iii].material.name == a2[5] or lExplode[ii].definition.entities[iii].material.name == a2[1] or lExplode[ii].definition.entities[iii].material.name == a2[2] or lExplode[ii].definition.entities[iii].material.name == a2[3] or lExplode[ii].definition.entities[iii].material.name == a2[4]
										lGlassArea.insert(lGlassArea.count, lExplode[ii].definition.entities[iii].area)
										if lExplode[ii].definition.entities[iii].outer_loop.vertices[0].position.z > lExplode[ii].definition.entities[iii].outer_loop.vertices[((lExplode[ii].definition.entities[iii].outer_loop.vertices.count / 2) - 0).round].position.z
											dZ = lExplode[ii].definition.entities[iii].outer_loop.vertices[((lExplode[ii].definition.entities[iii].outer_loop.vertices.count / 2) - 0).round].position.z
										else
											dZ = lExplode[ii].definition.entities[iii].outer_loop.vertices[0].position.z 
										end
										lPositionG.insert(lPositionG.count, dZ)
										i = 0
										if lGlassI.count < 1
											lGlassI.insert(i, lGlassI.count)
										else
											while i < lGlassI.count do
												if lPositionG[lPositionG.count - 1] < lPositionG[lGlassI[i]]
													lGlassI.insert(i, lGlassI.count)
													break
												end
												i += 1	
											end
											if lGlassI.count < lPositionG.count
												lGlassI.insert(lGlassI.count, lGlassI.count)
											end
										end
									end
								end
							end
						end
						iii += 1
					end
				end
			elsif lExplode[ii].is_a? Sketchup::Face
				if lExplode[ii].visible? == true and lExplode[ii].layer.visible? == true and lExplode[ii].material != nil and lExplode[ii].normal != Geom::Vector3d.new(0, 0, 1) and lExplode[ii].normal != Geom::Vector3d.new(0, 0, -1)
					if lExplode[ii].material.name == a6[5] or lExplode[ii].material.name == a6[1] or lExplode[ii].material.name == a6[2] or lExplode[ii].material.name == a6[3] or lExplode[ii].material.name == a6[4]
						lTotalArea.insert(lTotalArea.count, lExplode[ii].area)									
						if lExplode[ii].outer_loop.vertices[0].position.z > lExplode[ii].outer_loop.vertices[((lExplode[ii].outer_loop.vertices.count / 2) - 0).round].position.z
							dZ = lExplode[ii].outer_loop.vertices[((lExplode[ii].outer_loop.vertices.count / 2) - 0).round].position.z
						else
							dZ = lExplode[ii].outer_loop.vertices[0].position.z 
						end
						lPositionT.insert(lPositionT.count, dZ)
						i = 0
						if lTotalI.count < 1
							lTotalI.insert(i, lTotalI.count)
						else
							while i < lTotalI.count do
								if lPositionT[lPositionT.count - 1] < lPositionT[lTotalI[i]]
									lTotalI.insert(i, lTotalI.count)
									break
								end
								i += 1	
							end
							if lTotalI.count < lPositionT.count
								lTotalI.insert(lTotalI.count, lTotalI.count)
							end
						end
					end
					if lExplode[ii].material.name == a2[5] or lExplode[ii].material.name == a2[1] or lExplode[ii].material.name == a2[2] or lExplode[ii].material.name == a2[3] or lExplode[ii].material.name == a2[4]
						lGlassArea.insert(lGlassArea.count, lExplode[ii].area)
						if lExplode[ii].outer_loop.vertices[0].position.z > lExplode[ii].outer_loop.vertices[((lExplode[ii].outer_loop.vertices.count / 2) - 0).round].position.z
							dZ = lExplode[ii].outer_loop.vertices[((lExplode[ii].outer_loop.vertices.count / 2) - 0).round].position.z
						else
							dZ = lExplode[ii].outer_loop.vertices[0].position.z 
						end
						lPositionG.insert(lPositionG.count, dZ)
						i = 0
						if lGlassI.count < 1
							lGlassI.insert(i, lGlassI.count)
						else
							while i < lGlassI.count do
								if lPositionG[lPositionG.count - 1] < lPositionG[lGlassI[i]]
									lGlassI.insert(i, lGlassI.count)
									break
								end
								i += 1	
							end
							if lGlassI.count < lPositionG.count
								lGlassI.insert(lGlassI.count, lGlassI.count)
							end
						end
					end
				end
			end
			ii += 1
		end

		lExplode = lReview
	
		x += 1
	end

	viii = 0

	while viii < lTotalI.count do
		#if a1 == 7 and (lPositionT[lTotalI[viii]] - lPositionT[lTotalI[0]]) >= (a3 * 12)
			#break
		#end

		if a6 == "Single" 
			dTotalArea += (lTotalArea[lTotalI[viii]] / 144)
		else
			dTotalArea += (lTotalArea[lTotalI[viii]] / 288)
		end
		viii += 1
	end

	viii = 0

	while viii < lGlassI.count do
		#if a1 == 7 and (lPositionG[lGlassI[viii]] - lPositionG[lGlassI[0]]) >= ((a3 - a4) * 12)
			#break
		#end

		if a2 == "Single"
			dGlassArea += (lGlassArea[lGlassI[viii]] / 144)
		else
			dGlassArea += (lGlassArea[lGlassI[viii]] / 288)
		end
		viii += 1
	end

	if dGlassArea == 0
		UI.messagebox("0 glass area calculated. Check material names.")
	elsif dTotalArea == 0
		UI.messagebox("0 total facade area calculated. Check material names.")
	else
		dGlassR = (dGlassArea * 100 / dTotalArea).round
		dSolidR = 100 - dGlassR
		dSolidArea = dTotalArea - dGlassArea
		UI.messagebox("Solid-to-Glass Ratio is " + dSolidR.to_s + " / " + dGlassR.to_s)
		UI.messagebox("Solid Area: " + dSolidArea + "sf Glass Area: " + dGlassR + "sf")
	end
end

}

cmd.menu_text = "Solid-to-Glass Ratio"
UI.menu("Extensions").add_item cmd