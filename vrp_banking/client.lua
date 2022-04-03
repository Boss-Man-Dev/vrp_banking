--##########	VRP Main	##########--
-- init vRP server context
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
-- load script in vRP context
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)

local cfg = module("vrp_banking", "cfg/cfg")
local Banking = class("Banking", vRP.Extension)

local active_atm = false
local active_bank = false

function Banking:__construct()
	vRP.Extension.__construct(self)
	
	-- task: start pin animation
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if IsControlJustReleased(0, cfg.keys["ESC"]) and active_atm then 
				SetNuiFocus(false, false)
				SendNUIMessage({type = 'close'})
				active_atm = false
				active_bank = false
			end
		end
	end)
	
	RegisterNUICallback("info", function(data) 
		if data.deposit then
			self.remote._deposit(tonumber(data.deposit))
		elseif data.withdraw then
			self.remote._withdraw(tonumber(data.withdraw))
		elseif data.transfer then
			self.remote._transfer(tonumber(data.transfer), tonumber(data.to))
		end
	end)
	RegisterNUICallback("deposit_all", function() 
		self.remote._depositAll()
	end)
	RegisterNUICallback("withdraw_all", function() 
		self.remote._withdrawAll()
	end)
	RegisterNUICallback("error", function() 
		self.remote._error()
	end)
end

function Banking:atm(msg,v)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local name,gtype,x,y,z = table.unpack(v)
			local pos = GetEntityCoords(GetPlayerPed(-1), true)
			local dist = Vdist(pos.x, pos.y, pos.z, x, y, z)
			local help_msg = string.gsub(msg, "{1}", name)
			local dash = string.gsub("{1} {2}", "{1}", name)
			
			if not active_atm then
				if (dist < 1.0) then
					HelpText(string.gsub(help_msg, "{2}", gtype))
					if(IsControlJustReleased(0, cfg.keys["E"]))then
						SetNuiFocus(true, true)
						SendNUIMessage({type = 'atm'})
						self.remote._getBalance()
						active_atm = true
						Dashboard_Name(string.gsub(dash, "{2}", gtype));
					end
				end
			end
		end
	end)
end

function Banking:bank(msg,v)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local name,gtype,x,y,z = table.unpack(v)
			local pos = GetEntityCoords(GetPlayerPed(-1), true)
			local dist = Vdist(pos.x, pos.y, pos.z, x, y, z)
			local help_msg = string.gsub(msg, "{1}", name)
			local dash = string.gsub("{1} {2}", "{1}", name)
			
			if not active_bank then
				if (dist < 1.0) then
					HelpText(string.gsub(help_msg, "{2}", gtype))
					if(IsControlJustReleased(1, cfg.keys["E"]))then
						SetNuiFocus(true, true)
						SendNUIMessage({type = 'bank'})
						self.remote._getBalance()
						active_bank = true
						
						Dashboard_Name(string.gsub(dash, "{2}", gtype));
					end
				end
			end
		end
	end)
end

function Banking:close()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	active_atm = false
	active_bank = false
end

function Banking:balance(info)
	local formatted
	local player = {}
	local bal = {}
	
	formatted = comma_value(info.balance)
	table.insert(bal, formatted)
	table.insert(player, info.name)
	
	SendNUIMessage({
		type = "player",
		player = {
			name = table.concat(player),
			money = table.concat(bal) 
			
		}
	})
end

function Dashboard_Name(name)
	local dashboard = {}
	table.insert(dashboard, name)
	
	SendNUIMessage({
		type = "dashboard",
		dashboard = {
			name = table.concat(dashboard)
		}
	})
end

function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function HelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

-- toggle off ui
RegisterNUICallback("exit", function(data) 
	SetNuiFocus(false, false)
	active_atm = false
	active_bank = false
end)

Banking.tunnel = {}

-- UI
Banking.tunnel.atm 				= Banking.atm
Banking.tunnel.bank 			= Banking.bank
Banking.tunnel.close 			= Banking.close
--Function
Banking.tunnel.balance 			= Banking.balance

vRP:registerExtension(Banking)
