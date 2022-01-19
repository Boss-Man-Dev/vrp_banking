$(function() {
	window.addEventListener('message', function(event) {
		var data = event.data;
		
		if (data.type === "atm"){
			$('#main_login, #login_input-enter').show();
		} 
		if (data.type === "bank"){
			$('#main, #dashboard_account').show();
		} 
		if (data.type === "close"){
			closeAll();
		}
		if (data.type === "player"){
			console.log("player");
			var player = data.player;
			$('#player_money').html(player.money);

			var x = document.querySelectorAll("#player_name");
			var i;
			for (i = 0; i < x.length; i++) {
				x[i].innerHTML = player.name;
			} 
		}if (data.type === "dashboard"){
			var dashboard = data.dashboard;
			document.getElementById("nav_title").innerHTML = "";
			document.getElementById("nav_title").innerHTML = dashboard.name;
		}
	});
});

function closeAll() {
	$('#main_login, #login_input-pin, #login_input-enter, #main, #home_btn, #dashboard_account, #dashboard_deposit, #dashboard_withdraw, #dashboard_transfer').hide();
}

//Login Handling
function pin() {
	var selectors = new Array("pin", "pin_1","pin_2","pin_3");

	for(var i=0; i < selectors.length; i++) {
		document.getElementById(selectors[i]).style.backgroundColor = "#565670";
	}

	setTimeout(function(){
		document.getElementById("pin").style.backgroundColor = "#8d8db6";
	}, 400);
	setTimeout(function(){
		document.getElementById("pin_1").style.backgroundColor = "#8d8db6";
	}, 500);
	setTimeout(function(){
		document.getElementById("pin_2").style.backgroundColor = "#8d8db6";
	}, 600);
	setTimeout(function(){
		document.getElementById("pin_3").style.backgroundColor = "#8d8db6";
	}, 700);
	setTimeout(function(){
		closeAll();
		$('#main, #dashboard_account').show();
	}, 900);
}

$(function () {
    document.onkeyup = function (data) {
        if (data.which == 27) {	// ESC Key
            $.post('http://vrp_banking/exit', JSON.stringify({}));
			closeAll();
            return
        }
    };
});

// Button Handling
$(function() {
	window.addEventListener('click', function(event) {
		var exit = "exit_btn";      		var refresh = "refresh_btn";				var home = "home_btn"; 
		var pin_enter = "input_enter";

		var withdraw = "withdraw";		var deposit = "deposit";		var tranfer = "transfer";

		if (event.target.id == exit){
			$.post('http://vrp_banking/exit', JSON.stringify({}));
			closeAll();
		}if (event.target.id == refresh){
			closeAll();
			$('#main, #dashboard_account').show();
		}if (event.target.id == home){
			closeAll();
			$('#main, #dashboard_account').show();
		}if (event.target.id == withdraw){
			closeAll();
			$('#main, #home_btn, #dashboard_withdraw').show();

		}if (event.target.id == deposit){
			closeAll();
			$('#main, #home_btn, #dashboard_deposit').show();
		}if (event.target.id == tranfer){
			closeAll();
			$('#main, #home_btn, #dashboard_transfer').show();
		}if (event.target.id == pin_enter){
			closeAll();
			$('#main_login, #login_input-pin').show();
			setTimeout(function(){pin();}, 200);
		}
	});
});

// form submitting
$(function() {
	window.addEventListener('submit', function(event) {
		event.preventDefault()
		var deposit = "form_deposit";  				var deposit_submit = "deposit_btn-submit";		
		var withdraw = "form_withdraw"; 			var withdraw_submit = "withdraw_btn-submit";
		var transfer = "form_transfer"; 			var transfer_submit = "transform_btn-submit";
		var transfer_alt = "form_transfer--alt";	var transfer_submit_alt = "transform_btn-submit--alt";

		if (event.target.id == deposit){
			if($("#input_deposit").val() != ''){
				$.post('http://vrp_banking/info', JSON.stringify({
					deposit: $("#input_deposit").val()
				}));
				closeAll();
				$('#main, #dashboard_account').show();
				$("#input_deposit").val('');
			}else{
				$.post('http://vrp_banking/error', JSON.stringify({}));
			}
		}if (event.target.id == deposit_submit){
			if($("#input_deposit").val() != ''){
				$.post('http://vrp_banking/info', JSON.stringify({
					deposit: $("#input_deposit").val()
				}));
				closeAll();
				$('#main, #dashboard_account').show();
				$("#input_deposit").val('');
			}else{
				$.post('http://vrp_banking/error', JSON.stringify({}));
			}
		}if (event.target.id == withdraw){
			if($("#input_withdraw").val() != ''){
				$.post('http://vrp_banking/info', JSON.stringify({
					withdraw: $("#input_withdraw").val()
				}));
				closeAll();
				$('#main, #dashboard_account').show();
				$("#input_withdraw").val('');
			}else{
				$.post('http://vrp_banking/error', JSON.stringify({}));
			}
		}if (event.target.id == withdraw_submit){
			if($("#input_withdraw").val() != ''){
				$.post('http://vrp_banking/info', JSON.stringify({
					withdraw: $("#input_withdraw").val()
				}));
				closeAll();
				$('#main, #dashboard_account').show();
				$("#input_withdraw").val('');
			}else{
				$.post('http://vrp_banking/error', JSON.stringify({}));
			}
		}if (event.target.id == transfer || event.target.id == transfer_alt){
			if($("#input_transfer").val() != '' && $("#input_transfer--alt").val() != ''){
				$.post('http://vrp_banking/info', JSON.stringify({
					transfer: $("#input_transfer").val(),
					to:$("#input_transfer--alt").val()
				}));
				closeAll();
				$('#main, #dashboard_account').show();
				$("#input_transfer").val('');	$("#input_transfer--alt").val('');
			}else{
				$.post('http://vrp_banking/error', JSON.stringify({}));
			}
		}if (event.target.id == transfer_submit || event.target.id == transfer_submit_alt){
			if($("#input_transfer").val() != '' && $("#input_transfer--alt").val() != ''){
				$.post('http://vrp_banking/info', JSON.stringify({
					transfer: $("#input_transfer").val(),
					to:$("#input_transfer--alt").val()
				}));
				closeAll();
				$('#main, #dashboard_account').show();
				$("#input_transfer").val('');	$("#input_transfer--alt").val('');
			}else{
				$.post('http://vrp_banking/error', JSON.stringify({}));
			}
		}
	});
});

