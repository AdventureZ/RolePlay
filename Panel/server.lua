--Серверсайдная функция добавления нотификации
function addNotification(player, title, text)
	if player.type == "player" then --Если типом player является тип игрока, то кароч кидаем событие на клиент, шоб оно там нотификацию вызвало у игрока кароч
		triggerClientEvent(player, "addNotification", player, tostring(title), tostring(text))
	end
end