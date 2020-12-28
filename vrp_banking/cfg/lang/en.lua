
local lang = {
	main = {
		bank = {
			title = "Bank",
		},
		atm = {
			title = "ATM",
		},
		veh = {
			error = "You cannot be in a Vehicle",
		},
	},
	error = {
		not_enough = "~r~Not enough money.",
		invalid_value = "~r~Invalid value.",
	},
	atm = {
		deposit = "~g~${1} ~s~deposited.",
		withdraw = "~g~${1} ~s~withdrawn.",
		w_not_enough = "~r~You don't have enough money in your bank.",
		b_not_enough = "~r~You don't have enough money in your wallet.",
	},
	transfer = {
		error = "~r~You can't transfer money alone.",
		not_enough = "~r~You don't have enough money in your bank.",
		no_player = "~r~The player is not connected.",
		sent = "~g~you have sent ${1} to {2}",
		recieved = "~g~you got ${1} from {2}",
	},
}

return lang
