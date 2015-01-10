local EditBox={}
local editboxes = 0
function createCustomEdit(x, y, w, h, text, rel, par)
	editboxes = editboxes+1
	local id = editboxes
	EditBox[id] = {}

	EditBox[id]["Back"] = GuiStaticImage.create(x, y, w, h, "images/pane.png", rel, par)
	EditBox[id]["Back"]:setProperty("ImageColours", "tl:0 tr:0 bl:0 br:0") --FF3498DB

	EditBox[id]["Label"] = GuiLabel.create(0, 0, 1, 1, "  "..text, true, EditBox[id]["Back"])
	EditBox[id]["Label"]:setVerticalAlign("center")
	EditBox[id]["Label"]:setProperty("AlwaysOnTop", "True")

	EditBox[id]["Edit"] = GuiEdit.create(0, 0, 1, 1, text, true, EditBox[id]["Label"])
	EditBox[id]["Edit"]:setAlpha(0)

	EditBox[id]["Selector"] = GuiStaticImage.create(0, 0, 0, h, "images/pane.png", false, EditBox[id]["Back"])
	EditBox[id]["Selector"]:setAlpha(1)
	EditBox[id]["Selector"]:setProperty("ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB") --FF3498DB

	EditBox[id]["Hided"] = false

	addEventHandler("onClientGUIChanged", root, function()
		if source == EditBox[id]["Edit"] then
			if not EditBox[id]["Hided"] then 
				EditBox[id]["Label"]:setText("  "..EditBox[id]["Edit"]:getText())
			else
				EditBox[id]["Label"]:setText("  "..string.rep("*", EditBox[id]["Edit"]:getText():len()))
			end
			EditBox[id]["Selector"]:setPosition(0, 0, false)
			EditBox[id]["Selector"]:setSize(0, 0, false)
		end
	end)

	addEventHandler("onClientMouseEnter", root, function()
		if source == EditBox[id]["Edit"] then		
			setCursorImage("images/cursor/text.png")
		end
	end)

	addEventHandler("onClientMouseLeave", root, function()
		if source == EditBox[id]["Edit"] then		
			setCursorImage("images/cursor/cursor.png")
		end
	end)

	local setSelection = false
	local Position = 0
	addEventHandler("onClientGUIMouseUp", root, function()
		setSelection = false
	end)
	addEventHandler("onClientGUIClick", root, function()
		if source == EditBox[id]["Edit"] then

			EditBox[id]["Selector"]:setPosition(0, 0, false)
			EditBox[id]["Selector"]:setSize(0, 0, false)

		end
	end)

	addEventHandler("onClientGUIMouseDown", root, function(btn, CurX)
		if source == EditBox[id]["Edit"] then
			if btn == "left" then
				setSelection = true
				local x = getGUIOnScreenPosition(EditBox[id]["Label"])
				Position = CurX-x
				--outputDebugString(tostring(x).." "..tostring(Position))
			end
		end
	end)
	addEventHandler("onClientCursorMove", root, function(_, _, cursx)
		if setSelection == true then
			local _, h = EditBox[id]["Edit"]:getSize(false)
			local x = getGUIOnScreenPosition(EditBox[id]["Label"])
			local CursorS = cursx-x
			local PosX = Position
			local awid = math.abs(CursorS-PosX)
			if CursorS < PosX then PosX = CursorS end

			EditBox[id]["Selector"]:setPosition(PosX, 0, false)
			EditBox[id]["Selector"]:setSize(awid, h, false)

		end
	end)

	return EditBox[id]["Edit"], EditBox[id]["Label"], EditBox[id]["Back"]
end

function customEditSetFont(id, font, size)
	if not tonumber(id) then id = getCustomEdit(id)
	else id = tonumber(id) end
	if not isElement(EditBox[id]["Label"]) then return false end

	EditBox[id]["Label"]:setFont(GuiFont.create(font, tonumber(size)))
	EditBox[id]["Edit"]:setFont(GuiFont.create(font, tonumber(size)))
end

function customEditSetMasked(id, bool)
	if not tonumber(id) then id = getCustomEdit(id)
	else id = tonumber(id) end
	if not isElement(EditBox[id]["Label"]) then return false end
	if bool ~= true and bool ~= false then bool = false end
	EditBox[id]["Edit"]:setMasked(bool)
	EditBox[id]["Hided"] = bool
	if bool == true then EditBox[id]["Label"]:setText("  "..string.rep("*", EditBox[id]["Edit"]:getText():len()))
	else EditBox[id]["Label"]:setText("  "..EditBox[id]["Edit"]:getText()) end
end

function getCustomEdit(element)
	local ID = nil
	for i in pairs(EditBox) do
		if ID == nil then
			if element == EditBox[i]["Edit"] or element == EditBox[id]["Label"] then
				ID = i
			end
		else break end
	end
	return ID
end

function getGUIOnScreenPosition(element)
	local x, y = guiGetPosition(element, false)
	local child = element
	for i = 0, 10 do
		if getElementParent(child).type ~= "guiroot" then
			local x1, y1 = guiGetPosition(getElementParent(child), false)
			--outputDebugString(tostring(x1).." "..tostring(x))
			x, y = x+x1, y+y1 
			child = getElementParent(child)
		else break end
	end
	return x, y
end

local a, b = createCustomEdit(400, 200, 200, 25, "text", false)
local Test = GuiStaticImage.create(0, 24, 200, 1, "images/pane.png", false, b)
customEditSetFont(a, "fonts/OSL.ttf", 12)
--customEditSetMasked(a, true)
