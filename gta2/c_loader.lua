-- by Xenius / 2016.01.02.

local loadedModels = {}
allTXD = engineLoadTXD("files/wil.txd")
function tryToLoadCustomModel(model, file)
	if not loadedModels[file] then
		loadedModels[file] = true
		if fileExists("files/"..file..".dff") then
			if fileExists("files/"..file..".col") then
				engineReplaceCOL(engineLoadCOL("files/"..file..".col"), model)
			end
			engineImportTXD(allTXD, model)
			engineReplaceModel(engineLoadDFF("files/"..file..".dff", model), model)
			return true
		end
	end
end

function loadCustomIPL()
	local iplLines = split(iplData, "\n")
	for k, v in ipairs(iplLines) do
		local objData = split(v, ", ")
		local x, y, z = objData[4], objData[5], objData[6]
		local rx, ry, rz = objData[7], objData[8], objData[9]
		local isCustom = tryToLoadCustomModel(objData[1], objData[2])
		local obj = createObject(objData[1], x, y, z, rx, ry, rz)
		if obj then
			setElementDoubleSided(obj, true)
			if isCustom then
				local lod = createObject(objData[1], x, y, z, rx, ry, rz, true)
				setLowLODElement(obj, lod)
				engineSetModelLODDistance(objData[1], 4000)
			end
		else
			outputChatBox(objData[2])
		end
	end
end

function removeWorld()
	for i=550,20000 do
		removeWorldModel(i,10000,0,0,0)
	end
	setOcclusionsEnabled(false)
	
	createWater(-2998, -2998, 0.1, 2998, -2998, 0.1, -2998, 2998, 0.1, 2998, 2998, 0.1)
end

function restoreWorld()
	for i=550,20000 do
		restoreWorldModel(i,10000,0,0,0)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	removeWorld()
	loadCustomIPL()
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	restoreWorld()
end)