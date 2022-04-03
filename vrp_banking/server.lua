local lang = vRP.lang
local Luang = module("vrp", "lib/Luang")

local Banking = class("Banking", vRP.Extension)
Banking.event = {}
Banking.tunnel = {}

function Banking:__construct()
	vRP.Extension.__construct(self)
  
	self.cfg = module("vrp_banking", "cfg/cfg")
	
	for k,v in pairs(self.cfg.atms) do
		local x,y,z = table.unpack(v)
		--self:log("\r\27[10;92m["..x..", "..y..", "..z.."] \r\27[0m")	
	end
	for k,v in pairs(self.cfg.banks) do
		local x,y,z = table.unpack(v)
		--self:log("\r\27[10;92m["..x..", "..y..", "..z.."] \r\27[0m")	
	end
	
	-- load lang
	self.luang = Luang()
	self.luang:loadLocale(vRP.cfg.lang, module("vrp_banking", "cfg/lang/"..vRP.cfg.lang))
	self.lang = self.luang.lang[vRP.cfg.lang]
	
end

function Banking.event:playerSpawn(user, first_spawn)
	if first_spawn then
		for k,v in pairs(self.cfg.atms) do
			local name,gtype,x,y,z = table.unpack(v)
			
			local function enter(user)
				local in_vehicle = vRP.EXT.Garage.remote.isInVehicle(user.source)
				local msg = self.lang.main.help_msg()
				
				if in_vehicle then
					vRP.EXT.Base.remote._notify(user.source, self.lang.main.veh.error())
				else
					self.remote._atm(source,msg,v)
				end
			end
			
			local function leave(user)
				self.remote._close(source)
			end
			
			local ment = clone(self.cfg.marker.atm)
			ment[2].title = self.lang.main.title({gtype})
			ment[2].pos = {x,y,z-1}
			vRP.EXT.Map.remote._addEntity(user.source, ment[1], ment[2])

			user:setArea("vRP:ATM:"..k,x,y,z,1,1.5,enter,leave)
		end
		
		for k,v in pairs(self.cfg.banks) do
			local name,gtype,x,y,z = table.unpack(v)
			
			local function enter(user)
				local msg = self.lang.main.help_msg()
				
				self.remote._bank(source,msg,v)
			end
			
			local function leave(user)
				self.remote._close(source)
			end
			
			local ment1 = clone(self.cfg.marker.bank)
			ment1[2].title = self.lang.main.title({gtype})
			ment1[2].pos = {x,y,z-1}
			vRP.EXT.Map.remote._addEntity(user.source, ment1[1], ment1[2])

			user:setArea("vRP:Bank:"..k,x,y,z,1,1.5,enter,leave)
		end
	end
end

function Banking.event:balance()
	local user = vRP.users_by_source[source]
	local info = {}
	
	if user ~= nil then
		local identity = vRP.EXT.Identity:getIdentity(user.cid)
		local firstName = identity.firstname
		local lastName = identity.name
		local content = ""
		
		info.name = content..""..firstName.." "..lastName..""
		info.balance = user:getBank()
		
		self.remote._balance(source, info)
	end
end

function Banking.event:deposit(deposit)
	local user = vRP.users_by_source[source]
	
	if user ~= nil then
		amount = tonumber(deposit)
		local wallet = user:getWallet()
		if amount == nil or amount <= 0 or amount > wallet then
			vRP.EXT.Base.remote._notify(user.source,self.lang.error.invalid_value())
		else
			if user:tryPayment(amount) then
				user:giveBank(amount)
				vRP.EXT.Base.remote._notify(user.source,self.lang.atm.deposit({amount}))
				vRP:triggerEvent("balance")
			else
				vRP.EXT.Base.remote._notify(user.source,self.lang.atm.w_not_enough())
			end
		end
	end
end

function Banking.event:withdraw(withdraw)
	local user = vRP.users_by_source[source]
	local balance = user:getBank()
	
	if user ~= nil then
		amount = tonumber(withdraw)
		local bank = user:getBank()
		if amount == nil or amount <= 0 or amount > bank then
			vRP.EXT.Base.remote._notify(user.source,self.lang.error.invalid_value())
		else
			if user:tryWithdraw(amount) then
				vRP.EXT.Base.remote._notify(user.source,self.lang.atm.withdraw({amount}))
				vRP:triggerEvent("balance")
			else
				vRP.EXT.Base.remote._notify(user.source,self.lang.atm.b_not_enough())
			end
		end
	end
end

function Banking.event:transfer(transfer, to)
	local user = vRP.users_by_source[source]
	local tuser = vRP.users_by_source[to]
	local content = ""
	
	for id, user in pairs(vRP.users) do 
		-- user info
		local user_identity = vRP.EXT.Identity:getIdentity(user.cid)
		local user_first 	= user_identity.firstname
		local user_last 	= user_identity.name
		user_bal 			= user:getBank()
		user_name 			= content.."<div>"..user_first.." "..user_last.."</div>"
		--tuser info
		local tuser_identity = vRP.EXT.Identity:getIdentity(user.cid)
		local tuser_first 	= tuser_identity.firstname
		local tuser_last 	= tuser_identity.name
		tuser_name 			= content.."<div>"..tuser_first.." "..tuser_last.."</div>"
		
		if tuser ~= nil then
			if id == tonumber(to) then
				vRP.EXT.Base.remote._notify(user.source,self.lang.transfer.error())
			else
				if balance <= 0 or balance < tonumber(transfer) or tonumber(transfer) <= 0 then
					vRP.EXT.Base.remote._notify(user.source,self.lang.transfer.not_enough())
				else
					user_bank = user_bal - transfer
					user:setBank(user_bank)

					tuser:giveBank(transfer)
					vRP.EXT.Base.remote._notify(user.source,self.lang.transfer.sent({transfer, tuser_name}))
					vRP.EXT.Base.remote._notify(tuser.source,self.lang.transfer.recieved({transfer, user_name}))
				end
			end
		else
			vRP.EXT.Base.remote._notify(user.source,self.lang.transfer.no_player())
		end
	end
end

function Banking.tunnel:getBalance()
	vRP:triggerEvent("balance")
end

function Banking.tunnel:deposit(deposit)
	vRP:triggerEvent("deposit", deposit)
end
function Banking.tunnel:depositAll()
	local user = vRP.users_by_source[source]
	local deposit = user:getWallet()
	
	vRP:triggerEvent("deposit", deposit)
end

function Banking.tunnel:withdraw(withdraw)
	vRP:triggerEvent("withdraw", withdraw)
end
function Banking.tunnel:withdrawAll()
	local user = vRP.users_by_source[source]
	local withdraw = user:getBank()
	
	vRP:triggerEvent("withdraw", withdraw)
end

function Banking.tunnel:transfer(transfer, to)
	vRP:triggerEvent("transfer", transfer, to)
end

function Banking.tunnel:error()
	local user = vRP.users_by_source[source]
	vRP.EXT.Base.remote._notify(user.source,self.lang.error.invalid_value())
end

vRP:registerExtension(Banking)