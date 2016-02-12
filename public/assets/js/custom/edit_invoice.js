$(function() {
	var form = $('#addInvoiceForm');
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

    var addItemBtn = $('#addItem');
    var samples = $('#samples');
    var sample_row = samples.find('tr.sample_item');
    var cloned_row = sample_row.clone();
    var item_counter = $('#item_counter');

    //item_counter.val('1');

    addItemBtn.on('click', function(e) {
        e.preventDefault();
        item_counter.val(parseInt(item_counter.val())+1);
        sample_row.clone().removeClass('sample_item').html(function(i, oldHtml) {
            return oldHtml.replace(/{i}/g, item_counter.val());
        }).appendTo('#invoiceItems');

        domUpdate();
    });

    function domUpdate() {
        $('.deleteItem').unbind().on('click', function(e) {
            e.preventDefault();
            $(this).closest('tr').remove();

            var n = 1;
            $('tbody tr').each(function() {
                $(this).find('input, textarea').each(function() {
                    var inpName = $(this).attr('name');
                    var newName = inpName.replace( /\d+/g, n );
                    $(this).attr('name', newName);
                });
                n++;
            });
            item_counter.val(n);

            domUpdate();
        });
    }

    domUpdate();
});