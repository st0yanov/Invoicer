$(function() {
    var form = $('#loginForm');
    var formAction = form.attr('action');
    var resultText = $('p.result');

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
                resultText.removeClass('error success').addClass('success');
            } else {
                resultText.removeClass('error success').addClass('error');
            }

            resultText.fadeIn();
        });
    });
});
