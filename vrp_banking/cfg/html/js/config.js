/* Config  for quick button ammounts */

$(function()
{

/* ############# Quick Deposit values ############# */
	var symbol =   "$ ";
	var deposit_1 = "100";
	var deposit_2 = "500";
	var deposit_3 = "1000";
	var deposit_4 = "ALL";	// dont change to value

/* ############# Quick withdraw values ############# */
	var withdraw_1 = "100";
	var withdraw_2 = "500";
	var withdraw_3 = "1000";
	var withdraw_4 = "ALL";	// dont change to value

/* ############################################################# */
/* ################### Dont Change beyond this point ################# */

/* ############# Quick Deposit ############# */
	
	var deposit_btn = new Array("deposit_btn-1", "deposit_btn-2","deposit_btn-3","deposit_btn-4");
	var withdraw_btn = new Array("withdraw_btn-1", "withdraw_btn-2","withdraw_btn-3","withdraw_btn-4");

	for(var i=0; i < deposit_btn.length; i++) {
		document.getElementById(deposit_btn[i]).style.color = "#c4c4c4";
		document.getElementById(deposit_btn[i]).style.fontSize = "x-large";
	}
	
	for(var i=0; i < withdraw_btn.length; i++) {
		document.getElementById(withdraw_btn[i]).style.color = "#c4c4c4";
		document.getElementById(withdraw_btn[i]).style.fontSize = "x-large";
	}

	/*	########## Quick Deposit Button text ########## */
	document.getElementById("deposit_btn-1").innerHTML = symbol + deposit_1;
	document.getElementById("deposit_btn-2").innerHTML = symbol + deposit_2;
	document.getElementById("deposit_btn-3").innerHTML = symbol + deposit_3;
	document.getElementById("deposit_btn-4").innerHTML = deposit_4;
	/* ########## Quick Deposit Button Value ########## */
	document.getElementById("deposit_btn-1").value = deposit_1;
	document.getElementById("deposit_btn-2").value = deposit_2;
	document.getElementById("deposit_btn-3").value = deposit_3;
	document.getElementById("deposit_btn-4").value = deposit_4;
	/* ########## Quick Withdraw button Text ########## */
	document.getElementById("withdraw_btn-1").innerHTML = symbol + withdraw_1;
	document.getElementById("withdraw_btn-2").innerHTML = symbol + withdraw_2;
	document.getElementById("withdraw_btn-3").innerHTML = symbol + withdraw_3;
	document.getElementById("withdraw_btn-4").innerHTML = withdraw_4;
	/* ########## Quick Withdraw button value ########## */
	document.getElementById("withdraw_btn-1").value = withdraw_1;
	document.getElementById("withdraw_btn-2").value = withdraw_2;
	document.getElementById("withdraw_btn-3").value = withdraw_3;
	document.getElementById("withdraw_btn-4").value = withdraw_4;

	/* ################################################################## */
	/* ########## click events ##########*/
	window.addEventListener('click', function(event) {
		var deposit_btn_1 = "deposit_btn-1";	var deposit_btn_2 = "deposit_btn-2";
		var deposit_btn_3 = "deposit_btn-3";	var deposit_btn_4 = "deposit_btn-4";

		var withdraw_btn_1 = "withdraw_btn-1";	var withdraw_btn_2 = "withdraw_btn-2";
		var withdraw_btn_3 = "withdraw_btn-3";	var withdraw_btn_4 = "withdraw_btn-4";

		if (event.target.id == deposit_btn_1){
			console.log(event.target.val);
			$.post('http://vrp_banking/info', JSON.stringify({deposit: $("#deposit_btn-1").val()}));
		}if (event.target.id == deposit_btn_2){
			$.post('http://vrp_banking/info', JSON.stringify({deposit: $("#deposit_btn-2").val()}));
		}if (event.target.id == deposit_btn_3){
			$.post('http://vrp_banking/info', JSON.stringify({deposit: $("#deposit_btn-3").val()}));
		}if (event.target.id == deposit_btn_4){
			$.post('http://vrp_banking/deposit_all');
		}

		if (event.target.id == withdraw_btn_1){
			$.post('http://vrp_banking/info', JSON.stringify({withdraw: $("#withdraw_btn-1").val()}));
		}if (event.target.id == withdraw_btn_2){
			$.post('http://vrp_banking/info', JSON.stringify({withdraw: $("#withdraw_btn-2").val()}));
		}if (event.target.id == withdraw_btn_3){
			$.post('http://vrp_banking/info', JSON.stringify({withdraw: $("#withdraw_btn-3").val()}));
		}if (event.target.id == withdraw_btn_4){
			$.post('http://vrp_banking/withdraw_all');
		}
	});
	/* ################################################################## */
	/* ########## Special ##########*/

	//Card Year auto change to next year
	var d = new Date();
	var D = d.getFullYear()+ 1;
	document.getElementById("card_exp-year").innerHTML = D;
});
