local Width, Height = guiGetScreenSize()
local cursored = false
local cursorAlpha = 0
local cursorPath = "images/cursor/cursor.png"
function setCursorVisible(bool)
	if bool ~= true and bool ~= false then bool = not cursored end
	cursored = bool
	showCursor(bool)
end
function setCursorImage(path)
	cursorPath = path
end

addEventHandler("onClientRender", root, function()
	if cursored == true then
		if isMainMenuActive() or isConsoleActive() or isTransferBoxActive() then
			setCursorAlpha(255)
			cursorAlpha = 0
		else 
			setCursorAlpha(0) 
			cursorAlpha = 255
		end

		local x, y = getCursorPosition()
		dxDrawImage(x*Width, y*Height, 16, 16, cursorPath, 0, 0, 0, tocolor(255, 255, 255, cursorAlpha), true)
	end

end)

bindKey("X", "up", function()
	setCursorVisible(not isCursorShowing())
end)