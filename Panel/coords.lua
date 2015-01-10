local cmt = false
addCommandHandler("camera", function()
	if cmt == false then
		setCameraMatrix(1832.4893, -1395.0977, 229.5771, 1768.2651, -1372.1788, 226.7269)
		cmt = true
	else
		setCameraTarget(localPlayer)
	end
end)