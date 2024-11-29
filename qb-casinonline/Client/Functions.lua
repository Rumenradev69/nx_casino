Citizen.CreateThread(function()
	if GetResourceState("qb-core") == "started" then
		Framework = exports['qb-core']:GetCoreObject()
	elseif GetResourceState("vrp") == "started" then
		Framework = exports.vrp:GetCoreObject()
	else 
	end
end)

---@param msg string
function ShowHelpNotification(msg)
    AddTextEntry('esxHelpNotification', msg)
	DisplayHelpTextThisFrame('esxHelpNotification', false)
end

---@param x float
---@param y float
---@param z float
---@param text string
function drawText3D(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


-- CreateThread(function()
-- 	exports['qb-target']:AddTargetModel(Props, {
-- 		options = {
-- 			{
-- 				event = 'ctake:client:open',
-- 				type = 'client',
-- 				icon = "fas fa-credit-card",
-- 				label = "Enter Casino",
-- 			},
-- 		},
-- 		distance = 1.5,
-- 	})
-- end)