local Width, Height = guiGetScreenSize()


--Локальные переменные, распространяющиеся по всему коду для написания системы тем
local RealTine={} --Время/погода/локация
local WeatherIcon, Notification, NotificationBar --Ченджер погоды, добавление уведомлений
local AnimationPixels = 20 --Количество пикселей на мув/ресайз
local colorChanger={} --Таймеры--, забил на них
local closeTabs, openTabs = true, false --Открыть/закрыть главное меню (Справа)
local openCloseTimeR = 0 --Открыть/закрыть меню время/погода (1 - закрыть, 2 - открыть)
local openNotification = 0 --Открыть/закрыть уведомление (1 - закрыть, 2 - открыть)
local CloseNotificationPanel --Кнопка для закрытия панели уведомлений
local TopBarIcons={} --Таблица иконок топбара

addEventHandler("onClientResourceStart", root, function(res)

	if res ~= getThisResource() then return false end --если ресурс не этот, то слать всё в песду
	

	-- Blur на экране, тестил, может пригодится

	--[[local blur = dxCreateShader("motion.fx")
	local screen = dxCreateScreenSource(Width, Height)
	dxSetShaderValue(blur, "ScreenTexture", screen)

	addEventHandler("onClientRender", root, function()
		dxSetShaderValue(blur, "BlurAmount", 0.001)
		dxSetRenderTarget()
		dxUpdateScreenSource(screen)
		--dxDrawImageSection(400, 300, 300, 300, 400, 300, 300, 300, blur)
		--dxDrawImageSection(100, 300, 100, 100, 100, 300, 100, 100, blur)
	end)]]





	local topbr = guiCreateStaticImage(0, 0, Width, 40, "images/pane.png", false) --Панель топбар
	guiSetProperty(topbr, "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")

	local weatbar = guiCreateStaticImage(71, 0, 40, 40, "images/pane.png", false, topbr) --Иконка под погодой
	guiSetProperty(weatbar, "ImageColours", "tl:B34183D7 tr:B34183D7 bl:B34183D7 br:B34183D7")

	WeatherIcon = guiCreateStaticImage(6, 6, 28, 28, "images/weather/sunny.png", false, weatbar) --Иконка погоды
	guiSetProperty(WeatherIcon, "ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")

	local timebar = guiCreateStaticImage(0, 0, 70, 40, "images/pane.png", false, topbr) --Иконка под временем
	guiSetProperty(timebar, "ImageColours", "tl:B34183D7 tr:B34183D7 bl:B34183D7 br:B34183D7")

	TopBarIcons[1]= guiCreateStaticImage(Width-50, 0, 50, 40, "images/pane.png", false, topbr) --Иконка под юзером
	guiSetProperty(TopBarIcons[1], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
	local UserTab = guiCreateStaticImage(--[[Width-34]]11, 6, 28, 28, "images/menu/account.png", false, --[[topbr]]TopBarIcons[1]) --Иконка юзера

	TopBarIcons[2] = guiCreateStaticImage(Width-100, 0, 50, 40, "images/pane.png", false, topbr) --Иконка под инфо
	guiSetProperty(TopBarIcons[2], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
	local InfoTab = guiCreateStaticImage(--[[Width-70]]11, 6, 28, 28, "images/menu/info.png", false, --[[topbr]]TopBarIcons[2]) --Иконка инфы

	TopBarIcons[3] = guiCreateStaticImage(Width-150, 0, 50, 40, "images/pane.png", false, topbr) -- Иконка под настройками
	guiSetProperty(TopBarIcons[3], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
	local SettingsTab = guiCreateStaticImage(--[[Width-106]]11, 6, 28, 28, "images/menu/settings.png", false, --[[topbr]]TopBarIcons[3]) --Иконка настроек

	TopBarIcons[4] = guiCreateStaticImage(Width-200, 0, 50, 40, "images/pane.png", false, topbr) --Иконка под инвентарём
	guiSetProperty(TopBarIcons[4], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
	local EnvironmentTab = guiCreateStaticImage(--[[Width-142]]11, 6, 28, 28, "images/menu/inventory.png", false, --[[topbr]]TopBarIcons[4]) --Иконка инвентаря

	TopBarIcons[5] = guiCreateStaticImage(Width-250, 0, 50, 40, "images/pane.png", false, topbr) --Иконка под магазином
	guiSetProperty(TopBarIcons[5], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
	local ShopTab = guiCreateStaticImage(--[[Width-178]]11, 6, 28, 28, "images/menu/shop.png", false, --[[topbr]]TopBarIcons[5]) --Иконка магазина

	RealTine[1] = guiCreateLabel(0, 0, 70, 36, "12:30", false, timebar) --Время в топбаре
	guiLabelSetVerticalAlign(RealTine[1], "center")
	guiLabelSetHorizontalAlign(RealTine[1], "center")
	guiSetFont(RealTine[1], guiCreateFont("fonts/OSL.ttf", 16.6) )

	TopBarIcons[6] = guiCreateStaticImage((Width/2)-110, 0, 220, 40, "images/pane.png", false, topbr) --Иконка под уведомлениями
	guiSetProperty(TopBarIcons[6], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")

	Notification = guiCreateLabel(0, 0, 1, 0.94, "Test Notification", true, TopBarIcons[6]) --Текст уведомления
	guiLabelSetVerticalAlign(Notification, "center")
	guiLabelSetHorizontalAlign(Notification, "center")
	guiSetFont(Notification, guiCreateFont("fonts/OSL.ttf", 16.6) )


	--Time menu
	--Закоментированные проперти - это если в дизайне будет размытие под менюшками

	local timetops = guiCreateStaticImage(30, 45, 14, 7, "images/title.png", false) --Стрелочка к окну уведомлений
	--guiSetProperty(timetops, "ImageColours", "tl:AAFFFFFF tr:AAFFFFFF bl:AAFFFFFF br:AAFFFFFF")
	local CentralTW = guiCreateStaticImage(0, 52, 111, 135, "images/pane.png", false) --Центральная часть окна времени и погоды
	--guiSetProperty(CentralTW, "ImageColours", "tl:AAFFFFFF tr:AAFFFFFF bl:AAFFFFFF br:AAFFFFFF") 


	--Не пригодится в новом дизайне 
	--local timeweathertop = guiCreateStaticImage(0, 0, 150, 40, "images/pane.png", false, CentralTW) --Верхняя часть окна погоды и времени
	--guiSetProperty(timeweathertop, "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")

	--[[local twtop = guiCreateLabel(0, 0, 1, 0.94, "Время", true, timeweathertop) --Текст вехней части
	guiLabelSetVerticalAlign(twtop, "center") 
	guiLabelSetHorizontalAlign(twtop, "center")
	guiSetFont(twtop, guiCreateFont("fonts/OSL.ttf", 16) ]]
	--[[local SwitchLeft = guiCreateStaticImage(19, 69, 22, 22, "images/aleft.png", false) --Переключатель влево ко времени
	guiSetProperty(SwitchLeft, "AlwaysOnTop", "True")

	local SwitchRight = guiCreateStaticImage(169, 69, 22, 22, "images/aright.png", false) --Переключатель вправо к погоде
	guiSetProperty(SwitchRight, "AlwaysOnTop", "True")]]

	local timemenu = guiCreateStaticImage(0, 0, 111, 135, "images/pane.png", false, CentralTW)

	local CentralTWRound = guiCreateStaticImage(5, 5, 101, 101, "images/round.png", false, timemenu) --Круг времени
	guiSetProperty(CentralTWRound, "ImageColours", "tl:FF1BC5E8 tr:FF1BC5E8 bl:FF2962D8 br:FF2962D8")
	
	--Цвета часов в разное время суток
	--FFF5D940 FFE3A716 - morning
	--FF1BC5E8 FF2962D8 - day
	--FFFF5E3A FFFF2A68 - evening
	--FF9C7BC6 FF240085 - night

	RealTine[2] = guiCreateLabel(0, 0, 1, 1, "12:30", true, CentralTWRound) --Время в круге
	guiLabelSetVerticalAlign(RealTine[2], "center")
	guiLabelSetHorizontalAlign(RealTine[2], "center")
	guiSetFont(RealTine[2], guiCreateFont("fonts/OSL.ttf", 20) )

	RealTine[3] = guiCreateLabel(0, 110, 111, 30, "Location", false, timemenu) --Локация во времени
	--guiLabelSetVerticalAlign(RealTine[3], "center")
	guiLabelSetHorizontalAlign(RealTine[3], "center")
	guiSetFont(RealTine[3], guiCreateFont("fonts/OSL.ttf", 11) )
	guiLabelSetColor(RealTine[3], 41, 98, 216)

	--Weather tab

	--В новом дизайне врятли пригодится
	--[[local WeatherTop = guiCreateLabel(0, 0, 1, 0.94, "Погода", true, timeweathertop) --Текст вехней части
	guiLabelSetVerticalAlign(WeatherTop, "center") 
	guiLabelSetHorizontalAlign(WeatherTop, "center")
	guiSetFont(WeatherTop, guiCreateFont("fonts/OSL.ttf", 16) )
	guiSetPosition(WeatherTop, 1, 0, true)]]


	local WeatherScroller = guiCreateStaticImage(0, 0, 111, 135, "images/pane.png", false, CentralTW) --Панель с погодой, передвигаемая
	guiSetProperty(WeatherScroller, "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")

	local WeatherRound = guiCreateStaticImage(5, 5, 101, 101, "images/round.png", false, WeatherScroller) --Круг в панели
	guiSetProperty(WeatherRound, "ImageColours", "tl:FF1BC5E8 tr:FF1BC5E8 bl:FF2962D8 br:FF2962D8")

	RealTine[4] = guiCreateLabel(0, 0, 101, 101, "солнечно", false, WeatherRound) --Погода во вкладке
	guiLabelSetVerticalAlign(RealTine[4], "center")
	guiLabelSetHorizontalAlign(RealTine[4], "center")
	guiSetFont(RealTine[4], guiCreateFont("fonts/OSL.ttf", 14) )
	--guiLabelSetColor(RealTine[4], 41, 98, 216)

	--RealTine[5] = guiCreateStaticImage(21, 21, 28, 28, "images/weather/sunny.png", false, WeatherRound) --Погода в круге
	--[[RealTine[5] = guiCreateLabel(0, 120, 150, 20, "солнечно", false, WeatherScroller) --Погода в круге
	--guiLabelSetVerticalAlign(RealTine[6], "center")
	guiLabelSetHorizontalAlign(RealTine[6], "center")
	guiSetFont(RealTine[6], guiCreateFont("fonts/OSL.ttf", 10) )
	guiLabelSetColor(RealTine[6], 41, 98, 216)]]

	RealTine[6] = guiCreateLabel(0, 110, 111, 30, "Location", false, WeatherScroller) --Локация в погоде
	--guiLabelSetVerticalAlign(RealTine[6], "center")
	guiLabelSetHorizontalAlign(RealTine[6], "center")
	guiSetFont(RealTine[6], guiCreateFont("fonts/OSL.ttf", 11) )
	guiLabelSetColor(RealTine[6], 41, 98, 216)



	--При старом дизайне:
	--local switchingTime = 0 
	--[[addEventHandler("onClientGUIClick", root, function()
		if source == SwitchLeft then
			--guiSetPosition(RealTine[2], -1, 0.05, true)
			guiSetPosition(CentralTWRound, 9-150, 49, false)
			guiSetPosition(twtop, -1, 0, true)

			--guiSetPosition(RealTine[4], 0, 70, false)
			--guiSetPosition(RealTine[5], 0+36, 5, false)
			guiSetPosition(WeatherScroller, 0, 40, false)
			guiSetPosition(WeatherTop, 0, 0, true)

			switchingTime = 1
			guiSetVisible(SwitchLeft, false)
			guiSetVisible(SwitchRight, true)
		elseif source == SwitchRight then
			--guiSetPosition(RealTine[2], 0, 0.05, true)
			guiSetPosition(CentralTWRound, 9, 49, false)
			guiSetPosition(twtop, 0, 0, true)

			--guiSetPosition(RealTine[4], 132, 70, false)
			--guiSetPosition(RealTine[5], 132+36, 5, false)
			guiSetPosition(WeatherScroller, 150, 40, false)
			guiSetPosition(WeatherTop, 1, 0, true)

			switchingTime = 2
			guiSetVisible(SwitchLeft, true)
			guiSetVisible(SwitchRight, false)	
		end
	end)]]

	openCloseTimeR = 1 --1 - закрыть; 2 - открыть (Время/Погода)
	addEventHandler("onClientGUIClick", root, function()
		if source == WeatherIcon or source == weatbar then --Если кликаем по погоде в топбаре

			local x = guiGetPosition(WeatherScroller, false) --Ищем позицию панели погоды с релативом
			local _, h = guiGetSize(CentralTW, false) --Ищем высоту центральной панели

			if h <= 95 then openCloseTimeR = 2 end --Открываем панель погоды/времени, если высота меньше 95

			if x >= 1 then switchingTime = 2; --[[guiSetVisible(SwitchLeft, true); guiSetVisible(SwitchRight, false)]] return 1 end --Если позиция больше, либо равна 1, то свитчим со времени к погоде
			if h > 95 then openCloseTimeR = 1 end --Если высота больше 95, то закрываем панель погоды/времени

		end
	end)
	addEventHandler("onClientGUIClick", RealTine[1], function()
		if source == RealTine[1] then --Если кликаем по времени в топбаре

			local x = guiGetPosition(WeatherScroller, false) --Ищем позицию панели погоды с релативом
			local _, h = guiGetSize(CentralTW, false) --Ищем высоту центральной панели

			if h <= 95 then openCloseTimeR = 2 end --Открываем панель погоды/времени, если высота меньше 95

			if x < 1 then switchingTime = 1; --[[guiSetVisible(SwitchLeft, false); guiSetVisible(SwitchRight, true)	]] return 1 end --Если позиция меньше 1, то свитчим с погоды ко времени
			if h > 95 then openCloseTimeR = 1 end --Если высота больше 95, то закрываем панель погоды/времени

		end
	end, false)

	switchingTime = 1 --При старте свитчим с погоды ко времени
	--guiSetVisible(SwitchLeft, false)
	--guiSetVisible(SwitchRight, true)


	--Notifications

	local nottops = guiCreateStaticImage((Width/2)-7, 45, 14, 7, "images/title.png", false) --Стрелочка к окну уведомлений
	--guiSetProperty(nottops, "ImageColours", "tl:AAFFFFFF tr:AAFFFFFF bl:AAFFFFFF br:AAFFFFFF")

	local NotifiPane = guiCreateStaticImage((Width/2)-110, 52, 220, 200, "images/pane.png", false) --Панель уведомлений
	--guiSetProperty(NotifiPane, "ImageColours", "tl:AAFFFFFF tr:AAFFFFFF bl:AAFFFFFF br:AAFFFFFF")

	CloseNotificationPanel = guiCreateStaticImage((Width/2)-12, 240, 24, 24, "images/arrow.png", false) --Скрыть панель уведомлений
	guiSetProperty(CloseNotificationPanel, "AlwaysOnTop", "True")

	local scNotBar = guiCreateScrollPane(0, 22, 240, 156, false, NotifiPane) --Скроллер уведомлений (нахуй надо, если не скроллится?)
	NotificationBar = guiCreateStaticImage(0, 0, 220, 156, "images/pane.png", false, scNotBar) --панель уведомлений в скроллере
	guiSetProperty(NotificationBar, "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")

	openNotification = 1 --1 - close; 2 - open
	guiSetVisible(CloseNotificationPanel, false) --Скроем при старте уведомления


	addEventHandler("onClientGUIClick", root, function()
		if source == Notification or source == CloseNotificationPanel then --Если кликаем по уведомлению в топбаре или закрывашке уведомух, то

			local _, h = guiGetSize(NotifiPane, false) --Проверяем высоту панели уведомлений

			if h > 190 then --Если высота больше 190, то скрываем панель и кнопку скрытия
				openNotification = 1 
				guiSetVisible(CloseNotificationPanel, false) 

			else --Иначе открываем панели, и делаем стрелочку видимой
				openNotification = 2 
				guiSetVisible(nottops, true) end 

		end
	end)


	--Settings Panel (главное меню типа)

	local statePanel = guiCreateStaticImage(Width-132, 45, 14, 7, "images/title.png", false) --Стрелочка к окну настроек
	--guiSetProperty(statePanel, "ImageColours", "tl:AAFFFFFF tr:AAFFFFFF bl:AAFFFFFF br:AAFFFFFF")

	local OpenedSettsPane = guiCreateStaticImage(Width-250, 52, 250, 250, "images/pane.png", false)	--Панель настроек
	--guiSetProperty(OpenedSettsPane, "ImageColours", "tl:AAFFFFFF tr:AAFFFFFF bl:AAFFFFFF br:AAFFFFFF")

	local ShopInterface = guiCreateStaticImage(0, 0, 250, 250, "images/pane.png", false, OpenedSettsPane) --Меню магазина
	local ShopInters = guiCreateStaticImage(0, 0, 1, 250, "images/pane.png", false, ShopInterface) --Цветной индикатор
	guiSetProperty(ShopInters, "ImageColours", "tl:FF00FF00 tr:FF00FF00 bl:FF00FF00 br:FF00FF00")
	guiSetProperty(ShopInterface, "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")

	local InventInterface = guiCreateStaticImage(250, 0, 250, 250, "images/pane.png", false, OpenedSettsPane) --Меню инвентаря
	local InventInters = guiCreateStaticImage(0, 0, 1, 250, "images/pane.png", false, InventInterface) --Цветной индикатор
	guiSetProperty(InventInters, "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
	guiSetProperty(InventInterface, "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")

	local SettingsInterface = guiCreateStaticImage(250, 0, 250, 250, "images/pane.png", false, OpenedSettsPane) --Меню настроек
	local SettingsInters = guiCreateStaticImage(0, 0, 1, 250, "images/pane.png", false, SettingsInterface) --Цветной индикатор
	guiSetProperty(SettingsInters, "ImageColours", "tl:FF6600FF tr:FF6600FF bl:FF6600FF br:FF6600FF")
	guiSetProperty(SettingsInterface, "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")

	local InfoInterface = guiCreateStaticImage(250, 0, 250, 250, "images/pane.png", false, OpenedSettsPane) --Меню инфо
	local InfoInters = guiCreateStaticImage(0, 0, 1, 250, "images/pane.png", false, InfoInterface) --Цветной индикатор
	guiSetProperty(InfoInters, "ImageColours", "tl:FFFFF000 tr:FFFFF000 bl:FFFFF000 br:FFFFF000")
	guiSetProperty(InfoInterface, "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")

	local UserInterface = guiCreateStaticImage(250, 0, 250, 250, "images/pane.png", false, OpenedSettsPane) --Меню юзера
	local UserInters = guiCreateStaticImage(0, 0, 1, 250, "images/pane.png", false, UserInterface) --Цветной индикатор
	guiSetProperty(UserInters, "ImageColours", "tl:FFFF0000 tr:FFFF0000 bl:FFFF0000 br:FFFF0000")
	guiSetProperty(UserInterface, "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")

	local Enable={} --Курсор на gui-элементе
	local ScrollPad={} --Перемещение
	closeTabs, openTabs = true, false --При старте закроем главное меню

	ScrollPad[1] = true --Откроем вкладку пользователя
	local elementMoving = ShopInterface --Двигающимся основным элементом сделаем меню магазина

	addEventHandler("onClientGUIClick", root, function()
		if source == UserTab or source == TopBarIcons[1]  then --Если кликаем по вкладке пользователя, то

			openTabs = true --Открываем меню
			local x = guiGetPosition(UserInterface, false) --Ищем позицию страницы пользователя


			--Спрячем остальные вкладки
			local x1 = guiGetPosition(InfoInterface, false)
			local x2 = guiGetPosition(SettingsInterface, false)
			local x3 = guiGetPosition(InventInterface, false)
			local x4 = guiGetPosition(ShopInterface, false)

			if x1 ~= 0 then guiSetPosition(InfoInterface, 250, 0, false) 
			else elementMoving = InfoInterface end
			if x2 ~= 0 then guiSetPosition(SettingsInterface, 250, 0, false) 
			else elementMoving = SettingsInterface end
			if x3 ~= 0 then guiSetPosition(InventInterface, 250, 0, false) 
			else elementMoving = InventInterface end
			if x4 ~= 0 then guiSetPosition(ShopInterface, 250, 0, false) 
			else elementMoving = ShopInterface end
			--В случае "иначе" выбираем открытую вкладку

			if x < 250 then closeTabs = true return false end --Если вкладка активна, то закрываем панель

			ScrollPad[1] = true --открое вкладку пользователя
			guiSetPosition(UserInterface, 250, 0, false) --Установим ей позицию для слайда, чтобы была невидима






		elseif source == InfoTab or source == TopBarIcons[2]  then --Если кликаем по информации, то

			openTabs = true --Открываем меню
			local x = guiGetPosition(InfoInterface, false) --Ищем позицию страницы инфо


			--Спрячем остальные вкладки
			local x1 = guiGetPosition(UserInterface, false)
			local x2 = guiGetPosition(SettingsInterface, false)
			local x3 = guiGetPosition(InventInterface, false)
			local x4 = guiGetPosition(ShopInterface, false)

			if x1 ~= 0 then guiSetPosition(UserInterface, 250, 0, false) 
			else elementMoving = UserInterface end
			if x2 ~= 0 then guiSetPosition(SettingsInterface, 250, 0, false) 
			else elementMoving = SettingsInterface end
			if x3 ~= 0 then guiSetPosition(InventInterface, 250, 0, false) 
			else elementMoving = InventInterface end
			if x4 ~= 0 then guiSetPosition(ShopInterface, 250, 0, false) 
			else elementMoving = ShopInterface end
			--В случае "иначе" выбираем открытую вкладку

			if x < 250 then closeTabs = true return false end --Если вкладка активна, то закрываем панель

			ScrollPad[2] = true --открое вкладку инфо
			guiSetPosition(InfoInterface, 250, 0, false) --Установим ей позицию для слайда, чтобы была невидима






		elseif source == SettingsTab or source == TopBarIcons[3]  then --Если кликаем по настройкам, то

			openTabs = true --Открываем меню
			local x = guiGetPosition(SettingsInterface, false) --Ищем позицию страницы настроек



			--Спрячем остальные вкладки
			local x1 = guiGetPosition(InfoInterface, false)
			local x2 = guiGetPosition(UserInterface, false)
			local x3 = guiGetPosition(InventInterface, false)
			local x4 = guiGetPosition(ShopInterface, false)

			if x1 ~= 0 then guiSetPosition(InfoInterface, 250, 0, false) 
			else elementMoving = InfoInterface end
			if x2 ~= 0 then guiSetPosition(UserInterface, 250, 0, false) 
			else elementMoving = UserInterface end
			if x3 ~= 0 then guiSetPosition(InventInterface, 250, 0, false) 
			else elementMoving = InventInterface end
			if x4 ~= 0 then guiSetPosition(ShopInterface, 250, 0, false)  
			else elementMoving = ShopInterface end
			--В случае "иначе" выбираем открытую вкладку

			if x < 250 then closeTabs = true return false end --Если вкладка активна, то закрываем панель

			ScrollPad[3] = true --открое вкладку настроек
			guiSetPosition(SettingsInterface, 250, 0, false) --Установим ей позицию для слайда, чтобы была невидима






		elseif source == EnvironmentTab or source == TopBarIcons[4]  then --Если кликаем по инвентарю, то

			openTabs = true --Открываем меню
			local x = guiGetPosition(InventInterface, false) --Ищем позицию страницы инвентаря



			--Спрячем остальные вкладки
			local x1 = guiGetPosition(InfoInterface, false)
			local x2 = guiGetPosition(SettingsInterface, false)
			local x3 = guiGetPosition(UserInterface, false)
			local x4 = guiGetPosition(ShopInterface, false)

			if x1 ~= 0 then guiSetPosition(InfoInterface, 250, 0, false) 
			else elementMoving = InfoInterface end
			if x2 ~= 0 then guiSetPosition(SettingsInterface, 250, 0, false) 
			else elementMoving = SettingsInterface end
			if x3 ~= 0 then guiSetPosition(UserInterface, 250, 0, false) 
			else elementMoving = UserInterface end
			if x4 ~= 0 then guiSetPosition(ShopInterface, 250, 0, false) 
			else elementMoving = ShopInterface end
			--В случае "иначе" выбираем открытую вкладку


			if x < 250 then closeTabs = true return false end --Если вкладка активна, то закрываем панель

			ScrollPad[4] = true --открое вкладку инвентаря
			guiSetPosition(InventInterface, 250, 0, false) --Установим ей позицию для слайда, чтобы была невидима






		elseif source == ShopTab or source == TopBarIcons[5]  then --Если кликаем по магазину, то

			openTabs = true --Открываем меню
			local x = guiGetPosition(ShopInterface, false) --Ищем позицию страницы магазина



			--Спрячем остальные вкладки
			local x1 = guiGetPosition(InfoInterface, false)
			local x2 = guiGetPosition(SettingsInterface, false)
			local x3 = guiGetPosition(InventInterface, false)
			local x4 = guiGetPosition(UserInterface, false)

			if x1 ~= 0 then guiSetPosition(InfoInterface, 250, 0, false) 
			else elementMoving = InfoInterface end
			if x2 ~= 0 then guiSetPosition(SettingsInterface, 250, 0, false) 
			else elementMoving = SettingsInterface end
			if x3 ~= 0 then guiSetPosition(InventInterface, 250, 0, false) 
			else elementMoving = InventInterface end
			if x4 ~= 0 then guiSetPosition(UserInterface, 250, 0, false) 
			else elementMoving = UserInterface end
			--В случае "иначе" выбираем открытую вкладку


			if x < 250 then closeTabs = true return false end --Если вкладка активна, то закрываем панель

			ScrollPad[5] = true --открое вкладку магазина
			guiSetPosition(ShopInterface, 250, 0, false) --Установим ей позицию для слайда, чтобы была невидима
		end
	end)

	--local XPosition = {} --Нахуй надо?

	--Blur в панелях
	--[[addEventHandler("onClientRender", root, function()
		local w, h = guiGetSize(OpenedSettsPane, false)		
		local x, y = guiGetPosition(OpenedSettsPane, false)
		dxDrawImageSection(x, y, w, h, x, y, w, h, blur)

		w, h = guiGetSize(NotifiPane, false)
		x, y = guiGetPosition(NotifiPane, false)
		dxDrawImageSection(x, y, w, h, x, y, w, h, blur)

		w, h = guiGetSize(CentralTW, false)
		x, y = guiGetPosition(CentralTW, false)
		dxDrawImageSection(x, y, w, h, x, y, w, h, blur)
	end)]]

	--Настройки
	addEventHandler("onClientRender", root, function()
		if openTabs == true then --Если открытие панель, то будем её открывать

			local w, hs = guiGetSize(OpenedSettsPane, false) --Ищем размеры главного меню
			if hs == 250 then openTabs = false return false end --Если высота равна 250, то меню уже открыто
			closeTabs = false --Закрытие панели отключаем

			guiSetVisible(statePanel, true) --Делаем видимым стрелочку панели

			hs = hs+AnimationPixels --К найденной высоте добавляем определённое значение
			if hs >= 240 then hs = 250 end --Если высота достигает 240, то, чтобы не скакала в обратном направлении, ставим сразу 250

			guiSetSize(OpenedSettsPane, w, hs, false) --Меняем высоту

		end

		if closeTabs == true then --Если закрытие панели, то будем её закрывать
			local w, h = guiGetSize(OpenedSettsPane, false) --Ищем размеры меню
			if h == 0 then guiSetVisible(statePanel, false) closeTabs = false return false end --Если высота равна нулю, то меню уже закрыто

			h = h-AnimationPixels --От найденной высоты отнимаем определённое значение
			if h <= 10 then h = 0 end --Если высота доходит до 10, то, чтобы не скакала в обратном направлении, ставим сразу 0

			guiSetSize(OpenedSettsPane, w, h, false) --Меняем высоту

		end

		if ScrollPad[1] == true then --Если мы листаем меню юзверя
			local xz = guiGetPosition(UserInterface, false) --Ищем позицию вкладки
			local gx, gy = guiGetPosition(statePanel, false) --Ищем позицию стрелочки



			--Тут мы меняем позицию стрелочки
			if gx < Width-34 then --Если позиция стрелочки меньше позиции, заданной вкладкой, то
				
				gx = gx+10 --Добавляем ей по 10
				if gx >= Width-34 then gx = Width-34 end --Если она достигла или перешагнула это значение, то ставим ей значение, заданное вкладкой

				guiSetPosition(statePanel, gx, gy, false) --Меняем позицию
			elseif gx > Width-34 then --Иначе, если позиция больше
				
				gx = gx-10 --Отнимаем по 10
				if gx <= Width-34 then gx = Width-34 end --Если она достигла или перешагнула это значение, то ставим ей значение, заданное вкладкой

				guiSetPosition(statePanel, gx, gy, false) --Меняем позицию
			end



			--Тут мы меняем позицию самой вкладки
			if xz >= AnimationPixels then --Если позиция больше заданного значение вкладкой
				xz = xz-AnimationPixels --То отнимаем от него это значение
				guiBringToFront(UserInterface) --Переносим вкладку вперёд
				guiSetPosition(UserInterface, xz, 0, false) --Меняем ей позицию
				guiSetPosition(elementMoving, xz-250, 0, false) --Меняем позицию бывшей активной вкладке

			else  --В другом случае
				--Ставим нашей вкладке активность, а другие перемещаем вправо в конец
				guiSetPosition(UserInterface, 0, 0, false) 
				guiSetPosition(InfoInterface, 250, 0, false) 
				guiSetPosition(SettingsInterface, 250, 0, false) 
				guiSetPosition(InventInterface, 250, 0, false) 
				guiSetPosition(ShopInterface, 250, 0, false) 
				if gx == Width-34 then ScrollPad[1] = false end --Если стрелочка достигла назначения, отключить рендер этой части
			end

		elseif ScrollPad[2] == true then
			local xz = guiGetPosition(InfoInterface, false)			
			local gx, gy = guiGetPosition(statePanel, false)




			if gx < Width-84 then
				
				gx = gx+10
				if gx >= Width-84 then gx = Width-84 end

				guiSetPosition(statePanel, gx, gy, false)
			elseif gx > Width-84 then
				
				gx = gx-10
				if gx <= Width-84 then gx = Width-84 end

				guiSetPosition(statePanel, gx, gy, false)
			end




			if xz >= AnimationPixels then
				xz = xz-AnimationPixels
				guiBringToFront(InfoInterface)
				guiSetPosition(InfoInterface, xz, 0, false)
				guiSetPosition(elementMoving, xz-250, 0, false)

			else 
				guiSetPosition(UserInterface, 250, 0, false) 
				guiSetPosition(InfoInterface, 0, 0, false) 
				guiSetPosition(SettingsInterface, 250, 0, false) 
				guiSetPosition(InventInterface, 250, 0, false) 
				guiSetPosition(ShopInterface, 250, 0, false)  
				if gx == Width-84 then ScrollPad[2] = false end
			end

		elseif ScrollPad[3] == true then
			local xz = guiGetPosition(SettingsInterface, false)
			local gx, gy = guiGetPosition(statePanel, false)




			if gx < Width-134 then
				
				gx = gx+10
				if gx >= Width-134 then gx = Width-134 end

				guiSetPosition(statePanel, gx, gy, false)
			elseif gx > Width-134 then
				
				gx = gx-10
				if gx <= Width-134 then gx = Width-134 end

				guiSetPosition(statePanel, gx, gy, false)
			end



			if xz >= AnimationPixels then
				xz = xz-AnimationPixels
				guiBringToFront(SettingsInterface)
				guiSetPosition(SettingsInterface, xz, 0, false)
				guiSetPosition(elementMoving, xz-250, 0, false)

			else 
				guiSetPosition(UserInterface, 250, 0, false) 
				guiSetPosition(InfoInterface, 250, 0, false) 
				guiSetPosition(SettingsInterface, 0, 0, false) 
				guiSetPosition(InventInterface, 250, 0, false) 
				guiSetPosition(ShopInterface, 250, 0, false) 
				if gx == Width-134 then ScrollPad[3] = false end
			end

		elseif ScrollPad[4] == true then
			local xz = guiGetPosition(InventInterface, false)
			local gx, gy = guiGetPosition(statePanel, false)




			if gx < Width-184 then
				
				gx = gx+10
				if gx >= Width-184 then gx = Width-184 end

				guiSetPosition(statePanel, gx, gy, false)
			elseif gx > Width-184 then
				
				gx = gx-10
				if gx <= Width-184 then gx = Width-184 end

				guiSetPosition(statePanel, gx, gy, false)
			end




			if xz >= AnimationPixels then
				xz = xz-AnimationPixels
				guiBringToFront(InventInterface)
				guiSetPosition(InventInterface, xz, 0, false)
				guiSetPosition(elementMoving, xz-250, 0, false)

			else 
				guiSetPosition(UserInterface, 250, 0, false) 
				guiSetPosition(InfoInterface, 250, 0, false) 
				guiSetPosition(SettingsInterface, 250, 0, false) 
				guiSetPosition(InventInterface, 0, 0, false) 
				guiSetPosition(ShopInterface, 250, 0, false)  
				if gx == Width-184 then ScrollPad[4] = false end
			end

		elseif ScrollPad[5] == true then
			local xz = guiGetPosition(ShopInterface, false)
			local gx, gy = guiGetPosition(statePanel, false)




			if gx < Width-234 then
				
				gx = gx+10
				if gx >= Width-234 then gx = Width-234 end

				guiSetPosition(statePanel, gx, gy, false)
			elseif gx > Width-234 then
				
				gx = gx-10
				if gx <= Width-234 then gx = Width-234 end

				guiSetPosition(statePanel, gx, gy, false)
			end




			if xz >= AnimationPixels then
				xz = xz-AnimationPixels
				guiBringToFront(ShopInterface)
				guiSetPosition(ShopInterface, xz, 0, false)		
				guiSetPosition(elementMoving, xz-250, 0, false)	

			else 
				guiSetPosition(UserInterface, 250, 0, false) 
				guiSetPosition(InfoInterface, 250, 0, false) 
				guiSetPosition(SettingsInterface, 250, 0, false) 
				guiSetPosition(InventInterface, 250, 0, false) 
				guiSetPosition(ShopInterface, 0, 0, false) 
				if gx == Width-234 then ScrollPad[5] = false end
			end
		end
	end)

	addEventHandler("onClientMouseEnter", root, function()
		if source == UserTab or source == TopBarIcons[1] then
			Enable[1] = true
			--guiSetProperty(TopBarIcons[1], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")
		elseif source == InfoTab or source == TopBarIcons[2]  then
			Enable[2] = true
			--guiSetProperty(TopBarIcons[2], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")
		elseif source == SettingsTab or source == TopBarIcons[3]  then
			Enable[3] = true
			--guiSetProperty(TopBarIcons[3], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")
		elseif source == EnvironmentTab or source == TopBarIcons[4]  then
			Enable[4] = true
			--guiSetProperty(TopBarIcons[4], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")
		elseif source == ShopTab or source == TopBarIcons[5]  then
			Enable[5] = true
			--guiSetProperty(TopBarIcons[5], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")
		elseif source == Notification then
			Enable[6] = true
		elseif source == RealTine[1] then
			Enable[7] = true
		elseif source == weatbar or source == WeatherIcon then
			Enable[8] = true
		end
	end)

	addEventHandler("onClientMouseLeave", root, function()
		if source == UserTab or source == TopBarIcons[1]  then
			Enable[1] = false
			--guiSetProperty(TopBarIcons[1], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
		elseif source == InfoTab or source == TopBarIcons[2]  then
			Enable[2] = false
			--guiSetProperty(TopBarIcons[2], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
		elseif source == SettingsTab or source == TopBarIcons[3] then
			Enable[3] = false
			--guiSetProperty(TopBarIcons[3], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
		elseif source == EnvironmentTab or source == TopBarIcons[4] then
			Enable[4] = false
			--guiSetProperty(TopBarIcons[4], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
		elseif source == ShopTab or source == TopBarIcons[5] then
			Enable[5] = false
			--guiSetProperty(TopBarIcons[5], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
		elseif source == Notification then
			Enable[6] = false
		elseif source == RealTine[1] then
			Enable[7] = false
		elseif source == weatbar or source == WeatherIcon then
			Enable[8] = false
		end
	end)

	local ddx={}

	local timers, boolTime, tileTime = 0, false, "%.2i:%.2i"


	--TopBar Render
	addEventHandler("onClientRender", root, function()
		for i in pairs(Enable) do

			if Enable[i] == true then
				if i == 7 or i == 8 then
					if ddx[i] == nil then ddx[i] = 178 end
					ddx[i] = ddx[i] + 11
					if ddx[i] >= 255 then ddx[i] = 255 end
					if i == 7 then guiSetColor(timebar, ddx[i], 65, 131, 215)
					else guiSetColor(weatbar, ddx[i], 65, 131, 215) end
				else

					if ddx[i] == nil then ddx[i] = 0 end
					ddx[i] = ddx[i] + 25
					if ddx[i] >= 255 then ddx[i] = 255 end
					guiSetColor(TopBarIcons[i], ddx[i], 65, 131, 215)

				end

			elseif Enable[i] == false then
				if i == 7 or i == 8 then

					if ddx[i] == nil then ddx[i] = 255 end
					ddx[i] = ddx[i] - 11
					if ddx[i] <= 178 then ddx[i] = 178 end
					if i == 7 then guiSetColor(timebar, ddx[i], 65, 131, 215)
					else guiSetColor(weatbar, ddx[i], 65, 131, 215) end

				else

					if ddx[i] == nil then ddx[i] = 255 end
					ddx[i] = ddx[i] - 25
					if ddx[i] <= 0 then ddx[i] = 0; Enable[i] = nil return 1 end
					guiSetColor(TopBarIcons[i], ddx[i], 65, 131, 215)

				end

			elseif Enable[i] == nil then return false 	
			end
		end

		if guiGetVisible(RealTine[1]) then 
			guiSetText(RealTine[1], string.format("%.2i:%.2i", getRealTime().hour, getRealTime().minute )) 
		end

		if guiGetVisible(RealTine[2]) then
			--[[if boolTime == false then
				timers = timers + 1
				if timers == 30 then tileTime = "%.2i %.2i"; boolTime = true end
			else
				timers = timers - 6
				if timers == 0 then tileTime = "%.2i:%.2i"; boolTime = false end
			end]]
			local ar, ab = getTime()
			guiSetText(RealTine[2], string.format(tileTime, ar, ab)) 
		end
		if guiGetVisible(RealTine[3]) then
			guiSetText(RealTine[3], getZoneName(Vector3(getElementPosition(localPlayer)), true))
		end
		if guiGetVisible(RealTine[6]) then
			guiSetText(RealTine[6], getZoneName(Vector3(getElementPosition(localPlayer)), true))
		end



		--Round switching
		if guiGetVisible(CentralTWRound) then
			if switchingTime == 1 then
				local x = AnimationPixels
				local x1, y1 = guiGetPosition(timemenu, false)
				--local x2, y2 = guiGetPosition(twtop, false)
				local x3, y3 = guiGetPosition(WeatherScroller, false) --Y=70
				--local x4, y4 = guiGetPosition(WeatherTop, false)
				local x5, y5 = guiGetPosition(timetops, false)
				x1, x3, x5 = x1+x, x3+x, x5-10
				if x5 <= 30 then x5 = 30 end
				if x3 > 100 then 
					switchingTime = 0 
					--guiSetPosition(RealTine[2], 0, 0.05, true)
					guiSetPosition(timemenu, 0, 0, false)
					guiSetPosition(timetops, 30, 45, false)
					--guiSetPosition(twtop, 0, 0, true)

					--guiSetPosition(RealTine[4], 132, 70, false)
					--guiSetPosition(RealTine[5], 132+36, 5, false)
					guiSetPosition(WeatherScroller, 111, 0, false)
					--guiSetPosition(WeatherTop, 1, 0, true)
					return false 
				end
				guiSetPosition(timemenu, x1, y1, false)
				--guiSetPosition(twtop, x2, y2, false)
				guiSetPosition(WeatherScroller, x3, y3, false)
				--guiSetPosition(WeatherTop, x4, y4, false)
				guiSetPosition(timetops, x5, 45, false)
			elseif switchingTime == 2 then
				local x = AnimationPixels
				local x1, y1 = guiGetPosition(timemenu, false)
				--local x2, y2 = guiGetPosition(twtop, false)
				local x3, y3 = guiGetPosition(WeatherScroller, false)
				--local x4, y4 = guiGetPosition(WeatherTop, false)
				local x5, y5 = guiGetPosition(timetops, false)
				x1, x3, x5 = x1-x, x3-x, x5+10
				if x5 >= 80 then x5 = 80 end
				if x3 < 0 then 
					switcingTime = 0 
					--guiSetPosition(RealTine[2], -1, 0.05, true)
					guiSetPosition(timemenu, -111, 0, false)
					guiSetPosition(timetops, 80, 45, false)
					--guiSetPosition(twtop, -1, 0, true)

					--guiSetPosition(RealTine[4], 0, 70, false)
					--guiSetPosition(RealTine[5], 0+36, 5, false)
					guiSetPosition(WeatherScroller, 0, 0, false)
					--guiSetPosition(WeatherTop, 0, 0, true)
					return false 
				end
				guiSetPosition(timemenu, x1, y1, false)
				--guiSetPosition(twtop, x2, y2, false)
				guiSetPosition(WeatherScroller, x3, y3, false)
				--guiSetPosition(WeatherTop, x4, y4, false)
				guiSetPosition(timetops, x5, 45, false)
			else return false end
		end
	end)



	--Notification render
	addEventHandler("onClientRender", root, function()
		if guiGetVisible(NotifiPane) then
			if openNotification == 1 then
				local y = AnimationPixels
				local w, h =guiGetSize(NotifiPane, false)
				h = h-y
				if h < 0 then
					h = 0
					guiSetSize(NotifiPane, w, h, false)
					guiSetVisible(nottops, false) 
					openNotification = 0
					return false
				end
				guiSetSize(NotifiPane, w, h, false)
			elseif openNotification == 2 then
				local y = AnimationPixels
				local w, h =guiGetSize(NotifiPane, false)
				h = h+y
				if h > 200 then
					h = 200
					guiSetSize(NotifiPane, w, h, false)
					openNotification = 0
					guiSetVisible(CloseNotificationPanel, true)
					return false
				end
				guiSetSize(NotifiPane, w, h, false)
			else return false
			end 
		end
	end)

	--Open/close notifications
	addEventHandler("onClientRender", root, function()
		if openCloseTimeR == 1 then
			local y = AnimationPixels
			local x1, y1 = guiGetSize(CentralTW, false)
			y1 = y1-y
			if y1 <= 0 then
				y1 = 0
				openCloseTimeR = 0
				guiSetSize(CentralTW, x1, y1, false)
				guiSetVisible(timetops, false)
				--guiSetSize(SwitchLeft, 0, 0, false)
				--guiSetSize(SwitchRight, 0, 0, false)
				return false
			end
			guiSetSize(CentralTW, x1, y1, false)

		elseif openCloseTimeR == 2 then
			local y = AnimationPixels
			local x1, y1 = guiGetSize(CentralTW, false)
			y1 = y1+y
			if y1 >= 120 then
				y1 = 135
				openCloseTimeR = 0
				guiSetSize(CentralTW, x1, y1, false)
				--guiSetSize(SwitchLeft, 22, 22, false)
				--guiSetSize(SwitchRight, 22, 22, false)
				return false
			end
			guiSetSize(CentralTW, x1, y1, false)
			guiSetVisible(timetops, true)

		end

	end)

	local MR, MG, MB = fromHEXToRGB("F5D940") 
	local MR2, MG2, MB2 = fromHEXToRGB("E3A716") 

	local DR, DG, DB = fromHEXToRGB("1BC5E8") 
	local DR2, DG2, DB2 = fromHEXToRGB("2962D8") 

	local ER, EG, EB = fromHEXToRGB("FF5E3A") 
	local ER2, EG2, EB2 = fromHEXToRGB("FF2A68") 

	local NR, NG, NB = fromHEXToRGB("9C7BC6") 
	local NR2, NG2, NB2 = fromHEXToRGB("241085") 


	local numeric = 1
	addEventHandler("onClientRender", root, function()
		local h = getTime()
		if h >= 6 and h < 12 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)

			if r > MR then r = r-numeric
			elseif r < MR then r = r+numeric 
			elseif r < 0 or r > 255 then r = MR end

			if g > MG then g = g-numeric
			elseif g < MG then g = g+numeric 
			elseif g < 0 or g > 255 then g = MG end

			if b > MB then b = b-numeric
			elseif b < MB then b = b+numeric 
			elseif b < 0 or b > 255 then b = MB end

			if r1 > MR2 then r1 = r1-numeric
			elseif r1 < MR2 then r1 = r1+numeric 
			elseif r1 < 0 or r1 > 255 then r1 = MR2 end

			if g1 > MG2 then g1 = g1-numeric
			elseif g1 < MG2 then g1 = g1+numeric 
			elseif g1 < 0 or g1 > 255 then g1 = MG2 end

			if b1 > MB2 then b1 = b1-numeric
			elseif b1 < MB2 then b1 = b1+numeric 
			elseif b1 < 0 or b1 > 255 then b1 = MB2 end

			local sx = string.format("%2x%2x%2x%2x", 255, r, g, b)
			local sy = string.format("%2x%2x%2x%2x", 255, r1, g1, b1)
			guiSetProperty(CentralTWRound, "ImageColours", "tl:"..sx.." tr:"..sx.." bl:"..sy.." br:"..sy)
		elseif h >= 12 and h < 18 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)

			if r > DR then r = r-numeric
			elseif r < DR then r = r+numeric 
			elseif r < 0 or r > 255 then r = DR end

			if g > DG then g = g-numeric
			elseif g < DG then g = g+numeric 
			elseif g < 0 or g > 255 then g = DG end

			if b > DB then b = b-numeric
			elseif b < DB then b = b+numeric 
			elseif b < 0 or b > 255 then b = DB end

			if r1 > DR2 then r1 = r1-numeric
			elseif r1 < DR2 then r1 = r1+numeric 
			elseif r1 < 0 or r1 > 255 then r1 = DR2 end

			if g1 > DG2 then g1 = g1-numeric
			elseif g1 < DG2 then g1 = g1+numeric 
			elseif g1 < 0 or g1 > 255 then g1 = DG2 end

			if b1 > DB2 then b1 = b1-numeric
			elseif b1 < DB2 then b1 = b1+numeric 
			elseif b1 < 0 or b1 > 255 then b1 = DB2 end

			local sx = string.format("%2x%2x%2x%2x", 255, r, g, b)
			local sy = string.format("%2x%2x%2x%2x", 255, r1, g1, b1)
			guiSetProperty(CentralTWRound, "ImageColours", "tl:"..sx.." tr:"..sx.." bl:"..sy.." br:"..sy)
		elseif h >= 18 and h < 22 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)

			if r > ER then r = r-numeric
			elseif r < ER then r = r+numeric
			elseif r < 0 or r > 255 then r = ER end

			if g > EG then g = g-numeric
			elseif g < EG then g = g+numeric 
			elseif g < 0 or g > 255 then g = EG end

			if b > EB then b = b-numeric
			elseif b < EB then b = b+numeric
			elseif b < 0 or b > 255 then b = EB end

			if r1 > ER2 then r1 = r1-numeric
			elseif r1 < ER2 then r1 = r1+numeric 
			elseif r1 < 0 or r1 > 255 then r1 = ER2 end

			if g1 > EG2 then g1 = g1-numeric
			elseif g1 < EG2 then g1 = g1+numeric 
			elseif g1 < 0 or g1 > 255 then g1 = EG2 end

			if b1 > EB2 then b1 = b1-numeric
			elseif b1 < EB2 then b1 = b1+numeric 
			elseif b1 < 0 or b1 > 255 then b1 = EB2 end

			local sx = string.format("%2x%2x%2x%2x", 255, r, g, b)
			local sy = string.format("%2x%2x%2x%2x", 255, r1, g1, b1)
			guiSetProperty(CentralTWRound, "ImageColours", "tl:"..sx.." tr:"..sx.." bl:"..sy.." br:"..sy)
		elseif h >= 22 and h <= 24 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)

			if r > NR then r = r-numeric
			elseif r < NR then r = r+numeric 
			elseif r < 0 or r > 255 then r = NR end

			if g > NG then g = g-numeric
			elseif g < NG then g = g+numeric 
			elseif g < 0 or g > 255 then g = NG end

			if b > NB then b = b-numeric
			elseif b < NB then b = b+numeric 
			elseif b < 0 or b > 255 then b = NB end

			if r1 > NR2 then r1 = r1-numeric
			elseif r1 < NR2 then r1 = r1+numeric 
			elseif r1 < 0 or r1 > 255 then r1 = NR2 end

			if g1 > NG2 then g1 = g1-numeric
			elseif g1 < NG2 then g1 = g1+numeric 
			elseif g1 < 0 or g1 > 255 then g1 = NG2 end

			if b1 > NB2 then b1 = b1-numeric
			elseif b1 < NB2 then b1 = b1+numeric 
			elseif b1 < 0 or b1 > 255 then b1 = NB2 end

			local sx = string.format("%2x%2x%2x%2x", 255, r, g, b)
			local sy = string.format("%2x%2x%2x%2x", 255, r1, g1, b1)
			guiSetProperty(CentralTWRound, "ImageColours", "tl:"..sx.." tr:"..sx.." bl:"..sy.." br:"..sy)
		elseif h >= 0 and h < 6 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)

			if r > NR then r = r-numeric
			elseif r < NR then r = r+numeric 
			elseif r < 0 or r > 255 then r = NR end

			if g > NG then g = g-numeric
			elseif g < NG then g = g+numeric 
			elseif g < 0 or g > 255 then g = NG end

			if b > NB then b = b-numeric
			elseif b < NB then b = b+numeric 
			elseif b < 0 or b > 255 then b = NB end

			if r1 > NR2 then r1 = r1-numeric
			elseif r1 < NR2 then r1 = r1+numeric 
			elseif r1 < 0 or r1 > 255 then r1 = NR2 end

			if g1 > NG2 then g1 = g1-numeric
			elseif g1 < NG2 then g1 = g1+numeric 
			elseif g1 < 0 or g1 > 255 then g1 = NG2 end

			if b1 > NB2 then b1 = b1-numeric
			elseif b1 < NB2 then b1 = b1+numeric 
			elseif b1 < 0 or b1 > 255 then b1 = NB2 end

			local sx = string.format("%2x%2x%2x%2x", 255, r, g, b)
			local sy = string.format("%2x%2x%2x%2x", 255, r1, g1, b1)
			guiSetProperty(CentralTWRound, "ImageColours", "tl:"..sx.." tr:"..sx.." bl:"..sy.." br:"..sy)
		end

	end)

	--[[addEventHandler("onClientRender", root, function()
		local h, m = getTime()
		
		if h >= 6 and h < 12 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)
			if not isTimer(colorChanger[CentralTWRound]) then colorChange(CentralTWRound, 
				r, g, b, 255, 
				MR, MG, MB, 255, 
				50, 
				r1, g1, b1, 255, 
				MR2, MG2, MB2, 255) end
		elseif h >= 12 and h < 18 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)
			if not isTimer(colorChanger[CentralTWRound]) then colorChange(CentralTWRound, 
				r, g, b, 255, 
				DR, DG, DB, 255, 
				50, 
				r1, g1, b1, 255, 
				DR2, DG2, DB2, 255) end
		elseif h >= 18 and h < 22 then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)
			if not isTimer(colorChanger[CentralTWRound]) then colorChange(CentralTWRound, 
				r, g, b, 255, 
				ER, EG, EB, 255, 
				50, 
				r1, g1, b1, 255, 
				ER2, EG2, EB2, 255) end
		elseif (h >= 22 and h <= 24) or (h >= 0 and h < 6) then
			local r, g, b, a, r1, g1, b1, a1 = fromPropertyToColor(CentralTWRound)
			if not isTimer(colorChanger[CentralTWRound]) then colorChange(CentralTWRound, 
				r, g, b, 255,
				NR, NG, NB, 255, 
				50, 
				r1, g1, b1, 255, 
				NR2, NG2, NB2, 255) end
		end
	end)]]
	addNotification("Username", "Добро пожаловать на наш тес...")
	addNotification("Testing this shit", "Notifications Presetner")
	addNotification("Блять", "Ну это уже полнейший пиздец")
	addNotification("Блять", "Ну это уже полнейший пиздец")

end)

--Иногда впадлу писать проперти для gui-staticimage
function guiSetColor(element, a, r, g, b)
	if not isElement(element) and getElementType(element) ~= "gui-static-image" then return false end
	if a < 0 or a > 255 then a = 255 end
	if r < 0 or r > 255 then r = 255 end
	if g < 0 or g > 255 then g = 255 end
	if b < 0 or b > 255 then b = 255 end

	local hex = string.format("%2x%2x%2x%2x", a, r, g, b)
	return guiSetProperty(element, "ImageColours", "tl:"..hex.." tr:"..hex.." bl:"..hex.." br:"..hex)
end

--Хуёво-работающая функция colorChange, которая была написана для Lunix Phone, но переделанная под себя
function colorChange(element, fromred, fromgreen, fromblue, fromalpha, tored, togreen, toblue, toalpha, time, fr2, fg2, fb2, fa2, tr2, tg2, tb2, ta2)
    if not isElement(element) then return false end
    if isTimer(colorChanger[element]) then 
    	killTimer(colorChanger[element]) 
    	--destroyElement(colorChanger[element]) 
    end
    
    
    if fromred == nil or fromred < 0 or fromred > 255 or not tonumber(fromred) then fromred = 255 end
    if fromgreen == nil or fromgreen < 0 or fromgreen > 255 or not tonumber(fromgreen) then fromgreen = 255 end
    if fromblue == nil or fromblue < 0 or fromblue > 255 or not tonumber(fromblue) then fromblue = 255 end
    if fromalpha == nil or fromalpha < 0 or fromalpha > 255 or not tonumber(fromalpha) then fromalpha = 255 end
    if tored == nil or tored < 0 or tored > 255 or not tonumber(tored) then tored = 255 end
    if togreen == nil or togreen < 0 or togreen > 255 or not tonumber(togreen) then togreen = 255 end
    if toblue == nil or toblue < 0 or toblue > 255 or not tonumber(toblue) then toblue = 255 end
    if toalpha == nil or toalpha < 0 or toalpha > 255 or not tonumber(toalpha) then toalpha = 255 end
    if not time or time < 50 or time > 100 or not tonumber(time) then time = 50 end
    if fr2 == nil or fr2 < 0 or fr2 > 255 or not tonumber(fr2) then fr2 = fromred end
    if fg2 == nil or fg2 < 0 or fg2 > 255 or not tonumber(fg2) then fg2 = fromgreen end
    if fb2 == nil or fb2 < 0 or fb2 > 255 or not tonumber(fb2) then fb2 = fromblue end
    if fa2 == nil or fa2 < 0 or fa2 > 255 or not tonumber(fa2) then fa2 = fromalpha end
    if tr2 == nil or tr2 < 0 or tr2 > 255 or not tonumber(tr2) then tr2 = tored end
    if tg2 == nil or tg2 < 0 or tg2 > 255 or not tonumber(tg2) then tg2 = togreen end
    if tb2 == nil or tb2 < 0 or tb2 > 255 or not tonumber(tb2) then tb2 = toblue end
    if ta2 == nil or ta2 < 0 or ta2 > 255 or not tonumber(ta2) then ta2 = toalpha end
    
    local colores = tonumber(string.format("%i", math.sqrt(time)))
    
    local redpog, greenpog, bluepog, alphapog, rr2, gg2, bb2, aa2
    redpog = math.fmod(math.abs(fromred-tored), colores) 
    greenpog = math.fmod(math.abs(fromgreen-togreen), colores) 
    bluepog = math.fmod(math.abs(fromblue-toblue), colores) 
    alphapog = math.fmod(math.abs(fromalpha-toalpha), colores) 
    rr2 = math.fmod(math.abs(fr2-tr2), colores) 
    gg2 = math.fmod(math.abs(fg2-tr2), colores) 
    bb2 = math.fmod(math.abs(fb2-tb2), colores) 
    aa2 = math.fmod(math.abs(fa2-ta2), colores) 
    
    local numeric = 0
    colorChanger[element] = setTimer(function()    
        
        if numeric == 0 then
            numeric = 1
            if fromred > tored then fromred = fromred-redpog end
            if fromgreen > togreen then fromgreen = fromgreen-greenpog end
            if fromblue > toblue then fromblue = fromblue-bluepog end
            if fromalpha > toalpha then fromalpha = fromalpha-alphapog end
            if fr2 > tr2 then fr2 = fr2-rr2 end
            if fg2 > tg2 then fg2 = fg2-gg2 end
            if fb2 > tb2 then fb2 = fb2-bb2 end
            if fa2 > ta2 then fa2 = fa2-aa2 end
            
            if fromred < tored then fromred = fromred+redpog end
            if fromgreen < togreen then fromgreen = fromgreen+greenpog end
            if fromblue < toblue then fromblue = fromblue+bluepog end
            if fromalpha < toalpha then fromalpha = fromalpha+alphapog end
            if fr2 < tr2 then fr2 = fr2+rr2 end
            if fg2 < tg2 then fg2 = fg2+gg2 end
            if fb2 < tb2 then fb2 = fb2+bb2 end
            if fa2 < ta2 then fa2 = fa2+aa2 end
        else
            if fromred > tored then fromred = fromred-colores end
            if fromgreen > togreen then fromgreen = fromgreen-colores end
            if fromblue > toblue then fromblue = fromblue-colores end
            if fromalpha > toalpha then fromalpha = fromalpha-colores end
            if fr2 > tr2 then fr2 = fr2-colores end
            if fg2 > tg2 then fg2 = fg2-colores end
            if fb2 > tb2 then fb2 = fb2-colores end
            if fa2 > ta2 then fa2 = fa2-colores end
            
            if fromred < tored then fromred = fromred+colores end
            if fromgreen < togreen then fromgreen = fromgreen+colores end
            if fromblue < toblue then fromblue = fromblue+colores end
            if fromalpha < toalpha then fromalpha = fromalpha+colores end
            if fr2 < tr2 then fr2 = fr2+colores end
            if fg2 < tg2 then fg2 = fg2+colores end
            if fb2 < tb2 then fb2 = fb2+colores end
            if fa2 < ta2 then fa2 = fa2+colores end
        end
        
        if getElementType(element) == "gui-staticimage" then 
            local st = string.format("%.2x%.2x%.2x%.2x", fromalpha, fromred, fromgreen, fromblue)
            local st2 = string.format("%.2x%.2x%.2x%.2x", fa2, fr2, fg2, fb2)
            guiSetProperty(element, "ImageColours", "tl:"..st.." tr:"..st.." bl:"..st2.." br:"..st2)
        end
        if getElementType(element) == "gui-label" then
            guiLabelSetColor(element, fromred, fromgreen, fromblue)
            guiSetAlpha(element, fromalpha/2.55)
        end
        if getElementType(element) ~= "gui-staticimage" and getElementType(element) ~= "gui-label" then
            local st = string.format("%.2x%.2x%.2x%.2x", fromalpha, fromred, fromgreen, fromblue)
            local st2 = string.format("%.2x%.2x%.2x%.2x", fa2, fr2, fg2, fb2)
            guiSetProperty(element, "NormalTextColour", "tl:"..st.." tr:"..st.." bl:"..st2.." br:"..st2)
        end
        if (fromred == tored or fromred < 0 or fromred > 255) 
            and (fromgreen == togreen or fromgreen < 0 or fromgreen > 255) 
            and (fromblue == toblue or fromblue < 0 or fromblue > 255) 
            and (fromalpha == toalpha or fromalpha < 0 or fromalpha > 255)
            and (fr2 == tr2 or fr2 < 0 or fr2 > 255) 
            and (fg2 == tg2 or fg2 < 0 or fg2 > 255) 
            and (fb2 == tb2 or fb2 < 0 or fb2 > 255) 
            and (fa2 == ta2 or fa2 < 0 or fa2 > 255)
            then 
                if getElementType(element) == "gui-staticimage" then 
                    local st = string.format("%.2x%.2x%.2x%.2x", toalpha, tored, togreen, toblue)
                    local st2 = string.format("%.2x%.2x%.2x%.2x", ta2, tr2, tg2, tb2)
                    guiSetProperty(element, "ImageColours", "tl:"..st.." tr:"..st.." bl:"..st2.." br:"..st2)
                end
                killTimer(colorChanger[element]) 
                colorChanger[element] = nil
                outputDebugString("Finished")
                --destroyElement(colorChanger[element])
            return 1;
        else 
        	killTimer(colorChanger[element])
            colorChanger[element] = nil
        	outputDebugString("Shitty finished")
        end
    end, time, 0)
	return true
end

--Получаем цвет из проперти статик-имаги
function fromPropertyToColor(element)
    if getElementType(element) ~= "gui-staticimage" then return false end
    local str = guiGetProperty(element, "ImageColours")
    local r = tonumber(str:sub(6, 7), 16)
  	local g = tonumber(str:sub(8, 9), 16)
  	local b = tonumber(str:sub(10, 11), 16)
    local a = tonumber(str:sub(4, 5), 16)
   	local r1 = tonumber(str:sub(str:len()-5, str:len()-4), 16)
    local g1 = tonumber(str:sub(str:len()-3, str:len()-2), 16)
    local b1 = tonumber(str:sub(str:len()-1, str:len()), 16)
    local a1 = tonumber(str:sub(str:len()-7, str:len()-6), 16)
    --outputDebugString(r.." "..g.." "..b.." "..a.." LOL "..r1.." "..g1.." "..b1.." "..a1)
    return r, g, b, a, r1, g1, b1, a1

end

--Из проперти сразу в HEX
function fromPropertyToHEX(element)
    if getElementType(element) ~= "gui-staticimage" then return false end
    local str = guiGetProperty(element, "ImageColours"):sub(4, 12)
    return str
end

--Функция, которая переведёт HEX код в RGBA формат
function fromHEXToRGB(color)
    if tostring(color):len() == 8 then return tonumber(color:sub(3, 4), 16), tonumber(color:sub(5, 6), 16), tonumber(color:sub(7, 8), 16), tonumber(color:sub(1, 2), 16)
    elseif tostring(color):len() == 6 then return tonumber(color:sub(1, 2), 16), tonumber(color:sub(3, 4), 16), tonumber(color:sub(5, 6), 16)
    end
end







local AllNotifications={} --Таблица элементов уведомления
local NotifCount = 0 --Счётчик уведомлений
--Создаст уведомление
function addNotification(title, text, func)
	local ElementY = NotifCount*52
	NotifCount = NotifCount+1
	local id = NotifCount
	if not func then func = function() return false end end
	local r, g, b = fromHEXToRGB("4183D7")
	local r1, g1, b1 = fromHEXToRGB("AA0000")

	local number = {}
	number[id] = 0

	AllNotifications[id]={}

	AllNotifications[id]["Background"] = guiCreateStaticImage(0, ElementY, 220, 50, "images/pane.png", false, NotificationBar)
	guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")

	--if tostring(title):len() > 18 then title = tostring(title):sub(0, 15).."..." end

	AllNotifications[id]["Title"] = guiCreateLabel(10, 0, 210, 25, tostring(title), false, AllNotifications[id]["Background"])
	guiLabelSetVerticalAlign(AllNotifications[id]["Title"], "center")
	guiSetFont(AllNotifications[id]["Title"], guiCreateFont("fonts/OSR.ttf", 13))

	--if tostring(text):len() > 30 then text = tostring(text):sub(0, 27).."..." end

	AllNotifications[id]["Text"] = guiCreateLabel(15, 25, 205, 20, tostring(text), false, AllNotifications[id]["Background"])
	guiLabelSetVerticalAlign(AllNotifications[id]["Text"], "center")
	guiSetFont(AllNotifications[id]["Text"], guiCreateFont("fonts/OSL.ttf", 10))

	AllNotifications[id]["Moving"] = guiCreateStaticImage(0, 0, 1, 1, "images/pane.png", true, AllNotifications[id]["Background"])
	guiSetProperty(AllNotifications[id]["Moving"], "ImageColours", "tl:00000000 tr:00000000 bl:00000000 br:00000000")
	guiBringToFront(AllNotifications[id]["Moving"])

	AllNotifications[id]["Close"] = guiCreateStaticImage(210, 0, 50, 50, "images/cross.png", false, AllNotifications[id]["Moving"])
	guiSetProperty(AllNotifications[id]["Close"], "ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")

	addEventHandler("onClientMouseEnter", root, function()
		if source == AllNotifications[id]["Moving"] then
			guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")
		end
		if source == AllNotifications[id]["Close"] then
			local x = guiGetPosition(AllNotifications[id]["Close"], false)
			if x == 210 then
				guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")
			else
				guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF990000 tr:FF990000 bl:FF990000 br:FF990000")
			end
		end
	end)
	addEventHandler("onClientMouseLeave", root, function()
		if source == AllNotifications[id]["Moving"] then
			guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
		end
		if source == AllNotifications[id]["Close"] then
			guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF3498DB tr:FF3498DB bl:FF3498DB br:FF3498DB")
		end
	end)

	AllNotifications[id]["OpenClose"] = 0
	AllNotifications[id]["Destroy"] = false
	--local Yses = {}
	addEventHandler("onClientGUIClick", root, function()
		if source == AllNotifications[id]["Close"] then
			local x = guiGetPosition(AllNotifications[id]["Close"], false)
			if x == 210 then 
				AllNotifications[id]["OpenClose"] = 1
				guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF990000 tr:FF990000 bl:FF990000 br:FF990000")
			else
				AllNotifications[id]["Destroy"] = true
				for i in pairs(AllNotifications) do number[i] = 0 end
			end
		end   

		if source == AllNotifications[id]["Moving"] then
			local x = guiGetPosition(AllNotifications[id]["Close"], false)
			if x == 210 then
				--AllNotifications[id]["Destroy"] = true
				--for i in pairs(AllNotifications) do number[i] = 0 end
				closeNotifications()
				func()
			else
				AllNotifications[id]["OpenClose"] = 2	
				guiSetProperty(AllNotifications[id]["Background"], "ImageColours", "tl:FF4183D7 tr:FF4183D7 bl:FF4183D7 br:FF4183D7")			
			end
		end
	end)

	addEventHandler("onClientRender", root, function()
		if AllNotifications[id]["OpenClose"] == 1 then
			if not isElement(AllNotifications[id]["Close"]) then return false end
			local zx, zy = guiGetPosition(AllNotifications[id]["Close"], false)
			zx = zx-2
			if zx <= 170 then zx = 170 end
			guiSetPosition(AllNotifications[id]["Close"], zx, zy, false)
			guiBringToFront(AllNotifications[id]["Moving"])
			if zx == 170 then AllNotifications[id]["OpenClose"] = 0 end 
		elseif AllNotifications[id]["OpenClose"] == 2 then
			if not isElement(AllNotifications[id]["Close"]) then return false end
			local zx, zy = guiGetPosition(AllNotifications[id]["Close"], false)
			zx = zx+2
			if zx >= 210 then zx = 210 end
			guiSetPosition(AllNotifications[id]["Close"], zx, zy, false)
			guiBringToFront(AllNotifications[id]["Moving"])
			if zx == 210 then AllNotifications[id]["OpenClose"] = 0 end 
		end

		if AllNotifications[id]["Destroy"] == true then
			local x, y = guiGetPosition(AllNotifications[id]["Background"], false)
			local w, h = guiGetSize(AllNotifications[id]["Background"], false)
			h = h-4
			for i in pairs(AllNotifications) do
				--Да, я хитрожопый апельсин
				if isElement(AllNotifications[i]["Background"]) then
					local x1, y1 = guiGetPosition(AllNotifications[i]["Background"], false)
					if y1 > y then 
						--Каждому уведомлению меняем позицию
						number[i] = number[i]+1 --Наверное не нужно
						y1 = y1-4
						if number[i] > 14 then return false end --Наверное не нужно
						guiSetPosition(AllNotifications[i]["Background"], x1, y1, false)
					end
				end
				--[[if isElement(AllNotifications[i]["Background"]) then
					local x1, y1 = guiGetPosition(AllNotifications[i]["Background"], false)
					Yses[i+1] = y1
					if i-1 > 0 then
						if isElement(AllNotifications[i-1]["Background"]) then
							y2 = Yses[i-1]
						end
					else y2 = y end
					outputDebugString(tostring(i-1))
					if y1 > y2 then
						number = number+1
						y1 = y1-4
						if number == 14 then return false end
						guiSetPosition(AllNotifications[i]["Background"], x1, y1, false)
						guiBringToFront(AllNotifications[i]["Moving"])
						if y1/13 then return false end
					end
				end]]
			end
			if h <= 0 then 
				--Удаляем нотификацию
				AllNotifications[id]["Destroy"] = false
				destroyElement(AllNotifications[id]["Background"])
				NotifCount = NotifCount-1
				return false
			end
			guiSetSize(AllNotifications[id]["Background"], w, h, false)
		end
	end)

	--[[AllNotifications[id]["Closing"] = false
	AllNotifications[id]["Closed"] = 0
	local oldX = 0	
	addEventHandler("onClientGUIMouseDown", root, function(button, x)
		if button == "left" then
			if source == AllNotifications[id]["Moving"] then
				AllNotifications[id]["Closing"] = true
				oldX = x
			end
		end
	end)
	local CursX = 0
	addEventHandler("onClientGUIMouseUp", root, function(button, x)
		for i in pairs(AllNotifications) do
			if isElement(AllNotifications[i]["Background"]) then AllNotifications[i]["Closing"] = false end
		end
		if source == AllNotifications[id]["Moving"] then
			CursX = x-((Width/2)-110)
			if CursX < 20 or CursX > 200 then
				AllNotifications[id]["Closed"] = 1
			else
				AllNotifications[id]["Closed"] = 2
			end
		end
	end)

	addEventHandler("onClientRender", root, function()
		if AllNotifications[id]["Closed"] == 1 then
			if not isElement(AllNotifications[id]["Background"]) then AllNotifications[id]["Closed"] = 0 return false end
			local x, y = guiGetPosition(AllNotifications[id]["Background"], false)

			local Fun = function()
				for i in pairs(AllNotifications) do
					if isElement(AllNotifications[i]["Background"]) then		
						local x1, y1 = guiGetPosition(AllNotifications[i]["Background"], false)
						if y1 > y then 
							guiSetPosition(AllNotifications[i]["Background"], x1, y1-52, false) 
						end
					end
				end
				destroyElement(AllNotifications[id]["Background"])
				NotifCount = NotifCount-1
			end

			if CursX < 110 then
				x = x-AnimationPixels
				if x < -240 then Fun() return false end
				guiSetPosition(AllNotifications[id]["Background"], x, y, false)
			elseif CursX > 110 then
				x = x+AnimationPixels
				if x > 240 then Fun() return false end
				guiSetPosition(AllNotifications[id]["Background"], x, y, false)
			end
		end
	end)]]

	--[[addEventHandler("onClientCursorMove", root, function(_, _, x, y)
		if AllNotifications[id]["Closing"] == true then
			local NotX, NotY = guiGetPosition(AllNotifications[id]["Background"], false)
			CursorOnNotificationX = x-((Width/2)-110)
			CursorOnNotificationY = y-77-NotY
			NewNotX = x-oldX
			guiSetPosition(AllNotifications[id]["Background"], NewNotX, NotY, false)

			--Проверка курсора внутри нотификации
			if CursorOnNotificationX < 1 then
				setCursorPosition((Width/2)-109, y)
			elseif CursorOnNotificationX > 219 then
				setCursorPosition((Width/2)+109, y)
			end
			if CursorOnNotificationY < 1 then
				setCursorPosition(x, 77+NotY)
			elseif CursorOnNotificationY > 45 then
				setCursorPosition(x, 77+NotY+45)
			end

			if CursorOnNotificationX < 1 and CursorOnNotificationY < 1 then
				setCursorPosition((Width/2)-109, 77+NotY)

			elseif CursorOnNotificationX > 219 and CursorOnNotificationY > 45 then
				setCursorPosition((Width/2)+109, 77+NotY+45)

			elseif CursorOnNotificationX < 1 and CursorOnNotificationY > 45 then
				setCursorPosition((Width/2)-109, 77+NotY+45)

			elseif CursorOnNotificationX > 219 and CursorOnNotificationY < 1 then
				setCursorPosition((Width/2)+109, 77+NotY)
			end 
		end
	end)]]

end


--Тестовая команда создания уведомления
addCommandHandler("notif", function(_, text1, text2)
	if not text1 then text1 = "Test" end
	if not text2 then text2 = "Test notification" end
	addNotification(tostring(text1), tostring(text2))
end)

--Функции для открытия/закрытия меню топбара
function openMainMenu() openTabs = true closeTabs = false end
function closeMainMenu() closeTabs = true openTabs = false end
function openTimeOrWeather() openCloseTimeR = 2 end
function closeTimeOrWeather() openCloseTimeR = 1 end
function openNotifications() openNotification = 2 end
function closeNotifications() openNotification = 1 guiSetVisible(CloseNotificationPanel, false) end

addEvent("addNotification", true)
addEventHandler("addNotification", localPlayer, function(title, text) addNotification(title, text) end)