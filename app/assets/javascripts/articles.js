function isEmpty(value){
  return (typeof value === "undefined" || value === null);
}

$(document).ready(function(){
  $('div.articulox').on('focus', '[data-autocomplete-field]', function(){
    var input = $(this);
    input.autocomplete({
      source: function(request, response) {
        var sup = $('#_supplier_id').val();
        $.ajax({
          url: input.data('autocomplete-url'),
          dataType: 'json', data: {supplier_id: sup ,  q: request.term },
          success: function(data) {
            response(
              $.map(data, function(item) {
                return {label:  item.label, item: item};
              })
            );
          },
        });
      },
      select: function(event, ui) {
        input.val(ui.item.label);
        $(input.data('autocomplete-for')).val(ui.item.item.id);
      }
    }).removeAttr('data-autocomplete-field'); });

  $('#article_percentaje, #article_price_cost, #article_price_total, #article_iva ').on('keypress', function(){


    var charCode = (evt.which) ? evt.which : event.keyCode;
    if((value.indexOf('.')!=-1) && (charCode != 45 && (charCode < 48 || charCode > 57))){
      return false;
    }
    else if(charCode != 45 && (charCode != 46 || $(this).val().indexOf('.') != -1) && (charCode < 48 || charCode > 57)){
      return false;
    }
    return true;
  })


  $('#article_percentaje, #article_price_cost, #article_iva ').on('blur', function(){
    var price = $('#article_price_cost').val();
    var percentaje_gain = $('#article_percentaje').val();
    var price_total = $('#article_price_total').val();
    var iva = $('#article_iva').val();

    if (percentaje_gain == "" || isNaN(percentaje_gain))
    {
      $('#article_percentaje').val(0);
      percentaje = 0;
    }

    if (price == "" || isNaN(price))
    {
      $('#article_price_cost').val(0);
      price = 0;
    }

    if (iva == "" || isNaN(iva))
    {
      $('#article_iva').val(0);
      iva = 0;
    }

    percentaje = parseFloat(percentaje_gain) + parseFloat(iva);

    if (price != "")
    {
      price_total = ((parseFloat(price) * parseFloat(percentaje))/100) + parseFloat(price);

      console.log(isNaN(price_total));

      if ( isNaN(price_total) || price_total == "")
      {
        $('#article_price_total').val(0);
      }
      else{
        $('#article_price_total').val(price_total.toFixed(2));
      }
    }

    $(this).val(parseFloat($(this).val()).toFixed(2));
  });

});
