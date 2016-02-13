$(function() {
	var form = $('#addPaymentForm');
    var formAction = form.attr('action');
    var resultText = $('div.result');

    form.on('submit', function(e) {
        e.preventDefault();

        var formData = $(this).serialize();

        toggleForm(form);
        resultText.fadeOut();
        $('.form-group').removeClass('has-error');
        $('span.help-block').fadeOut();

        $.ajax({
            url: formAction,
            type: 'POST',
            data: formData,
            dataType: 'json'
        }).done(function(data) {
            toggleForm(form);
            resultText.text(data['message']);

            if (data['success']) {
                form[0].reset();
                resultText.removeClass('alert-success alert-danger').addClass('alert-success');
            } else {
                $.each(data['errors'], function(field, errors) {
                    current_field = form.find('#'+field);
                    current_group = current_field.parent('.form-group');
                    current_group.addClass('has-error');
                    current_group.find('span.help-block').html(errors.join('<br>')).fadeIn();
                });
                resultText.removeClass('alert-success alert-danger').addClass('alert-danger');
            }

            resultText.fadeIn();
        });
    });

    var disabled = false;

    function toggleForm(form) {
        form.find(':input').prop('disabled', !disabled);
        disabled = !disabled;
    }
});