$(function() {
	$('.deletePayment').on('submit', function(e) {
		e.preventDefault();

		var form = $(this);
		var formAction = form.attr('action');

		$.ajax({
            url: formAction,
            type: 'DELETE',
            dataType: 'json'
        }).done(function(data) {
            if (data['success']) {
            	form.closest('tr').remove();
            }
            alert(data['message']);
        });
	});
});