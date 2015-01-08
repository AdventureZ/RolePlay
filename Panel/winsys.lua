--Window System
local Width, Height = guiGetScreenSize()
local WindowSystem = {}
local Windows = 0
local EnableMoving = {}
local EnableResizing = {}
local AnimatedOpen = {}
local AnimatedClose = {}
local AnimatedFullscreen = {}
function createWindow(x, y, w, h, title)
	Windows = Windows+1
	id = Windows
	WindowSystem[id] = {}
	x = tonumber(x) or 50
	y = tonumber(y) or 10
	w = tonumber(w) or 50
	h = tonumber(h) or 20
	WindowSystem[id]["Back"] = GuiStaticImage.create(x-4, y-4, w+8, h+28, "images/pane.png", false)
	WindowSystem[id]["Back"]:setProperty("ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000") 

	WindowSystem[id]["BackTopLeft"] = GuiStaticImage.create(0, 0, 8, 8, "images/backtl.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackTopLeft"]:setEnabled(false)

	WindowSystem[id]["BackTop"] = GuiStaticImage.create(8, 0, w-8, 8, "images/backt.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackTop"]:setEnabled(false)

	WindowSystem[id]["BackTopRight"] = GuiStaticImage.create(w, 0, 8, 8, "images/backtr.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackTopRight"]:setEnabled(false)

	WindowSystem[id]["BackRight"] = GuiStaticImage.create(w, 8, 8, h+20-8, "images/backr.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackRight"]:setEnabled(false)

	WindowSystem[id]["BackBottomRight"] = GuiStaticImage.create(w, h+28-8, 8, 8, "images/backbr.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackBottomRight"]:setEnabled(false)

	WindowSystem[id]["BackBottom"] = GuiStaticImage.create(8, h+28-8, w-8, 8, "images/backb.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackBottom"]:setEnabled(false)

	WindowSystem[id]["BackBottomLeft"] = GuiStaticImage.create(0, h+28-8, 8, 8, "images/backbl.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackBottomLeft"]:setEnabled(false)

	WindowSystem[id]["BackLeft"] = GuiStaticImage.create(0, 8, 8, h+20-8, "images/backl.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["BackLeft"]:setEnabled(false)


	WindowSystem[id]["Window"] = GuiStaticImage.create(4, 4, w, h+20, "images/pane.png", false, WindowSystem[id]["Back"])
	WindowSystem[id]["Window"]:setProperty("ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB") --FF1BC5E8 FF2962D8 FF3498DB FF4183D7 

	WindowSystem[id]["Frame"] = GuiStaticImage.create(0, 20, w, h, "images/pane.png", false, WindowSystem[id]["Window"])

	WindowSystem[id]["Title"] = GuiLabel.create(0, 0, w, 20, tostring(title) or "Title", false, WindowSystem[id]["Window"])
	WindowSystem[id]["Title"]:setHorizontalAlign("center")
	WindowSystem[id]["Title"]:setFont(GuiFont.create("fonts/OSR.ttf", 10))

	WindowSystem[id]["FullScreen"] = GuiStaticImage.create(w-42, 0, 21, 21, "images/aleft.png", false, WindowSystem[id]["Title"])
	WindowSystem[id]["FullScreenRound"] = GuiStaticImage.create(0, 0, 21, 21, "images/left.png", false, WindowSystem[id]["FullScreen"])
	WindowSystem[id]["FullScreen"]:setProperty("ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000") 
	WindowSystem[id]["FullScreenRound"]:setProperty("ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF") 

	WindowSystem[id]["Close"] = GuiStaticImage.create(w-21, 0, 21, 21, "images/aright.png", false, WindowSystem[id]["Title"])
	WindowSystem[id]["CloseRound"] = GuiStaticImage.create(0, 0, 21, 21, "images/right.png", false, WindowSystem[id]["Close"])
	WindowSystem[id]["Close"]:setProperty("ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000") 
	WindowSystem[id]["CloseRound"]:setProperty("ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF") 

	WindowSystem[id]["Resize"] = GuiStaticImage.create(w-7, h-7, 7, 7, "images/resizer.png", false, WindowSystem[id]["Frame"])
	WindowSystem[id]["Resize"]:setProperty("ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")


	addEventHandler("onClientMouseEnter", root, function()
		if source == WindowSystem[id]["FullScreenRound"] then
			WindowSystem[id]["FullScreen"]:setProperty("ImageColours", "tl:FFEB974E tr:FFEB974E bl:FFEB974E br:FFEB974E") 	
		end
		if source == WindowSystem[id]["CloseRound"] then
			WindowSystem[id]["Close"]:setProperty("ImageColours", "tl:FFD64541 tr:FFD64541 bl:FFD64541 br:FFD64541") 	
		end
	end)

	addEventHandler("onClientMouseLeave", root, function()
		if source == WindowSystem[id]["FullScreenRound"] then
			WindowSystem[id]["FullScreen"]:setProperty("ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000") 	
		end
		if source == WindowSystem[id]["CloseRound"] then
			WindowSystem[id]["Close"]:setProperty("ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000") 	
		end
	end)




	WindowSystem[id]["Moving"] = true
	WindowSystem[id]["Resizing"] = true






	AnimatedClose[id] = false
	AnimatedOpen[id] = false
	AnimatedFullscreen[id] = false
	addEventHandler("onClientGUIClick", root, function()
		if source == WindowSystem[id]["FullScreenRound"] then
			AnimatedFullscreen[id] = true
		end
		if source == WindowSystem[id]["CloseRound"] then
			AnimatedClose[id] = true
		end
	end)

	local boned = 0
	local Vars={}
	local Fullscreened = false
	addEventHandler("onClientRender", root, function()
		if AnimatedFullscreen[id] then
			AnimatedClose[id] = false
			AnimatedOpen[id] = false

			if Fullscreened == false then

				if boned == 0 then

					local w, h = WindowSystem[id]["Back"]:getSize(false) 
					local ax, y = WindowSystem[id]["Back"]:getPosition(false)
					Vars = {w, h, ax, y, WindowSystem[id]["Moving"], WindowSystem[id]["Resizing"]}
					boned = 1

				elseif boned == 1 then

					local w, h = WindowSystem[id]["Back"]:getSize(false)
					h = h-30
					if h < 30 then h = 0 end
					WindowSystem[id]["Back"]:setSize(w, h, false)
					if h == 0 then boned = 2 end

				elseif boned == 2 then

					setStaticWindowPosition(id, 0, 40, false)
					setStaticWindowSize(id, Width-8, Height-68)
					WindowSystem[id]["Back"]:setSize(Width, 0, false)	
					setStaticWindowMovable(id, false)
					setStaticWindowSizable(id, false)		
					boned = 3

				elseif boned == 3 then

					local w, h = WindowSystem[id]["Back"]:getSize(false)
					h = h+30
					if h > Height-60 then h = Height-40 end
					WindowSystem[id]["Back"]:setSize(w, h, false)	
					if h == Height-40 then
						boned = 0
						AnimatedFullscreen[id] = false
						Fullscreened = true
					end		
				end
				

			elseif Fullscreened == true then

				if boned == 0 then

					local w, h = WindowSystem[id]["Back"]:getSize(false)
					h = h-30
					if h < 30 then h = 0 end
					WindowSystem[id]["Back"]:setSize(w, h, false)
					if h == 0 then boned = 1 end

				elseif boned == 1 then

					--setStaticWindowPosition(id, Vars[3], Vars[4], false)
					WindowSystem[id]["Back"]:setPosition(Vars[3], Vars[4], false)
					setStaticWindowSize(id, Vars[1]-8, Vars[2]-28)
					WindowSystem[id]["Back"]:setSize(Vars[1], 0, false)					
					setStaticWindowMovable(id, Vars[5])
					setStaticWindowSizable(id, Vars[6])
					boned = 2

				elseif boned == 2 then					

					local w, h = WindowSystem[id]["Back"]:getSize(false)
					h = h+30
					if h > Vars[2]-30 then h = Vars[2] end
					WindowSystem[id]["Back"]:setSize(w, h, false)	
					if h == Vars[2] then
						boned = 0
						AnimatedFullscreen[id] = false
						Fullscreened = false
					end	

				end

			end
		end





		if AnimatedClose[id] == true then
			AnimatedOpen[id] = false
			AnimatedFullscreen[id] = false

			if boned == 0 then
				local w, h = WindowSystem[id]["Back"]:getSize(false) 
				local x, y = WindowSystem[id]["Back"]:getPosition(false)
				if not Fullscreened then Vars = {w, h, x, y, WindowSystem[id]["Moving"], WindowSystem[id]["Resizing"]} end
				boned = 1
			elseif boned == 1 then
				local w, h = WindowSystem[id]["Back"]:getSize(false)
				h = h-30
				if h < 30 then h = 0 end
				WindowSystem[id]["Back"]:setSize(w, h, false)
				if h == 0 then AnimatedClose[id] = false boned = 0 end
			end

		end

		if AnimatedOpen[id] == true then
			AnimatedClose[id] = false
			AnimatedFullscreen[id] = false

			if boned == 0 then
				
				local w, h = WindowSystem[id]["Back"]:getSize(false) 
				if h <= 10 then 
					boned = 1 
				else 
					AnimatedOpen[id] = false 
				end
			
			elseif boned == 1 then				

				local w, h = WindowSystem[id]["Back"]:getSize(false)
				h = h+30
				local f
				if not Fullscreened then f = Vars[2]
				else f = Height-40 end

				if h > f-30 then 
					h = f
				end

				WindowSystem[id]["Back"]:setSize(w, h, false)	
				if h == f then
					boned = 0
					AnimatedOpen[id] = false
				end

			end
		end
	end)

	EnableMoving[id] = false
	EnableResizing[id] = false
	local Positions = {}

	addEventHandler("onClientGUIMouseUp", root, function()
		EnableMoving[id] = false
		EnableResizing[id] = false
	end)

	addEventHandler("onClientGUIMouseDown", root, function(_, CurX, CurY)
		if source == WindowSystem[id]["Title"] then 
			if WindowSystem[id]["Moving"] == true then
				EnableMoving[id] = true
				local x, y = WindowSystem[id]["Back"]:getPosition(false)
				Positions = {CurX-x, CurY-y}
			end
		end
		if source == WindowSystem[id]["Resize"] then
			if WindowSystem[id]["Resizing"] == true then
				EnableResizing[id] = true
				local w, h = WindowSystem[id]["Frame"]:getSize(false)
				Positions = {CurX-w, CurY-h}
			end
		end
	end)
	addEventHandler("onClientCursorMove", root, function(_, _, cursx, cursy)
		if EnableMoving[id] then
			setStaticWindowPosition(id, cursx-Positions[1], cursy-Positions[2], false)
		end
		if EnableResizing[id] then
			setStaticWindowSize(id, cursx-Positions[1], cursy-Positions[2])
		end
	end)

	return WindowSystem[id]["Frame"]
end

function setStaticWindowPosition(win, x, y, rel)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	if not WindowSystem[ident]["Back"] then return false end
	local w, h = WindowSystem[ident]["Back"]:getSize(false)
	if rel ~= true and rel ~= false then rel = false end
	if x < -5 then x = -5 end
	if y < -5 then y = -5 end
	if x > Width-w+5 then x = Width-w+5 end
	if y > Height-h+5 then y = Height-h+5 end

	triggerEvent("onClientWindowSetPosition", localPlayer, x, y, rel)

	return WindowSystem[ident]["Back"]:setPosition(x, y, rel)
end

function setStaticWindowSize(win, w, h)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	if not WindowSystem[ident]["Back"] then return false end
	if w < 100 then w = 100 end
	if h < 30 then h = 30 end

	WindowSystem[id]["BackTop"]:setSize(w-8, 8, false)
	WindowSystem[id]["BackTopRight"]:setPosition(w, 0, false)

	WindowSystem[id]["BackRight"]:setPosition(w, 8, false)
	WindowSystem[id]["BackRight"]:setSize(8, h+20-8, false)

	WindowSystem[id]["BackBottomRight"]:setPosition(w, h+28-8, false)
	WindowSystem[id]["BackBottom"]:setPosition(8, h+28-8, false)

	WindowSystem[id]["BackBottom"]:setSize(w-8, 8, false)
	WindowSystem[id]["BackBottomLeft"]:setPosition(0, h+28-8, false)

	WindowSystem[id]["BackLeft"]:setSize(8, h+20-8, false)
	WindowSystem[id]["Window"]:setSize(w, h+20, false)

	WindowSystem[id]["Frame"]:setSize(w, h, false)
	WindowSystem[id]["Title"]:setSize(w, 20, false)

	WindowSystem[id]["FullScreen"]:setPosition(w-42, 0, false)
	WindowSystem[id]["Close"]:setPosition(w-21, 0, false)

	WindowSystem[id]["Resize"]:setPosition(w-7, h-7, false)

	triggerEvent("onClientWindowSetSize", localPlayer, w, h)

	return WindowSystem[ident]["Back"]:setSize(w+8, h+28, false)
end

function getStaticWindowID(win)
	local ID = nil
	for i in pairs(WindowSystem) do
		if WindowSystem[i]["Frame"] == win then 
			ID = i
		end
	end
	return ID
end

function setStaticWindowMovable(win, bool)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	if not WindowSystem[ident]["Back"] then return false end
	if bool ~= true and bool ~= false then bool = not WindowSystem[ident]["Moving"] end

	WindowSystem[ident]["Moving"] = bool
end

function setStaticWindowSizable(win, bool)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	if not WindowSystem[ident]["Back"] then return false end
	if bool ~= true and bool ~= false then bool = not WindowSystem[ident]["Resizing"] end

	WindowSystem[ident]["Resizing"] = bool
	WindowSystem[ident]["Resize"]:setVisible(bool)
end

function setStaticWindowTitle(win, titletext)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	if not WindowSystem[ident]["Back"] then return false end
	if not tostring(titletext) then titletext = "" end

	WindowSystem[ident]["Title"]:setText(tostring(titletext))
end

function getStaticWindowPosition(win, bool)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	if not WindowSystem[ident]["Back"] then return false end
	if bool ~= true and bool ~= false then bool = false end
	local x, y = WindowSystem[ident]["Back"]:getPosition(bool)
	return x, y
end

function getStaticWindowSize(win, bool)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	if not WindowSystem[ident]["Back"] then return false end
	if bool ~= true and bool ~= false then bool = false end
	local w, h = WindowSystem[ident]["Frame"]:getSize(bool)
	return w, h
end

function openStaticWindow(win)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	AnimatedOpen[ident] = true
end

function closeStaticWindow(win)
	local ident
	if not tonumber(win) then ident = getStaticWindowID(win)
	else ident = tonumber(win) end
	AnimatedClose[ident] = true
end

local window = createWindow(108, 100, 450, 200, "MTA Role Play")
addCommandHandler("show", function()
	openStaticWindow(window)
end)