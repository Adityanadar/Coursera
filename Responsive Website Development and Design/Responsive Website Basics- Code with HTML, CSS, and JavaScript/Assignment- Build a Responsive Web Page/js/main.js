$(document).ready(function() {
	setTimeout(welcomeModal, 3000);
	
	$('#userForm').submit(function(e) {
		e.preventDefault();
		alert("Log in with credentials:\nEmail: " + this.email.value + "\nPassword: " + this.password.value);
	});
	
	$('#inspiration').click(function(e) {
		e.preventDefault();
		alert("\"Traveling – it leaves you speechless, then turns you into a storyteller\" – Ibn Battuta");
	});
	
	$('#goPlace').click(function(e) {
		e.preventDefault();
		var place = $('#place').val();
		$('#myPlace').html(place);
	});
	
	function welcomeModal() {
		$('#modalWelcome').modal({
			show: true
		});
	}
});