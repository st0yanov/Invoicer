$(function() {
    var form = $('#loginForm');
    var formAction = form.attr('action');
    var resultText = $('div.result');

    form.on('submit', function(e) {
        e.preventDefault();

        resultText.fadeOut();

        var formData = $(this).serialize();

        $.ajax({
            url: formAction,
            type: 'POST',
            data: formData,
            dataType: 'json'
        }).done(function(data) {
            resultText.text(data['message']);

            if (data['success']) {
                resultText.removeClass('alert-success alert-danger').addClass('alert-success');
                setTimeout(function() {
                    window.location = '/partners';
                }, 1500);
            } else {
                resultText.removeClass('alert-success alert-danger').addClass('alert-danger');
            }

            resultText.fadeIn();
        });
    });
});
