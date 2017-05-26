$(function(){
	$('#btnSignUp').click(function(){
		
		$.ajax({
			url: '/showSignUp',
			data: $('form').serialize(),
			type: 'POST',
			dataType: 'text/json',
			success: function(response){
				console.log(response);
			},
			error: function(error){
				console.log(error);
			}
		});
	});
});