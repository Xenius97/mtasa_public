local sx, sy = guiGetScreenSize()
local fps = 0
function getCurrentFPS()
    return fps
end

function updateFPS(msSinceLastFrame)
    fps = (1 / msSinceLastFrame) * 1000
end
addEventHandler("onClientPreRender", root, updateFPS)

local oldFPS = 60
addEventHandler("onClientRender", root, function()
	local fps = math.floor(getCurrentFPS())
	if fps > 60 then fps = 60 end
	
	if oldFPS-fps > 15 then
		outputChatBox("FPS DROP "..oldFPS.."-ről "..fps.."-re. (Különbség: "..oldFPS-fps..")")
	end
		
	oldFPS = fps
		
	local objs = #getElementsByType("object", root, true)
	local txt = "Körülötted lévő objectek (stream): "..objs
	local r, g, b = 255, 255, 255
	if objs <= 500 then
		r, g, b = 0, 255, 0
	elseif objs >= 650 then
		r, g, b = 255, 0, 0
	elseif objs > 500 then
		r, g, b = 0, 255, 255
	end
		
	dxDrawText(txt, 2, 2, sx, 130, tocolor(0,0,0,255), 1.2, "default-bold", "center", "center")
	dxDrawText(txt, 0, 0, sx, 130, tocolor(r,g,b,255), 1.2, "default-bold", "center", "center")
end)

addCommandHandler("whatsthis", function()
	local objs = {}
	for k, v in ipairs(getElementsByType("object", root, true)) do
		local model = getElementModel(v)
		if not objs[model] then
			objs[model] = 0
		end
		objs[model] = objs[model] + 1
	end
	
	for model, count in pairs(objs) do
		if count > 10 then
			outputChatBox("["..model.."] => "..count.."db (lod dist: "..engineGetModelLODDistance(model)..")")
		end
	end
end)

addCommandHandler("restream", function()
	engineRestreamWorld()
end)