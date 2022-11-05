addEventHandler("onClientResourceStart", resourceRoot, function()
	local startX, startY, startZ = 1544.9228515625, 1234.3786621094, 10.8125
	local defX, defY, defZ = startX, startY, startZ
	local rot = 90
	for k, v in ipairs(getValidPedModels()) do
		createPed(v, startX, startY, startZ, rot)
		if k%20 == 0 then
			startY = startY + 2
			startX = defX
		else
			startX = startX - 2
		end
	end
end)