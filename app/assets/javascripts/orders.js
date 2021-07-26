var calculo_subtotal = function(price, quantity){

  if (price == ""){price = 0}
  if (quantity == ""){quantity = 0}
  var subtotal = parseFloat(price)  * parseFloat(quantity);
  return subtotal;
};

var calculo_invoice_subtotal = function(){
  var precio_total = $('#invoice_subtotal').val();

  if (precio_total == 0 || isNaN(precio_total))
  {
    precio_total = 0.00;
  }
  var  valor = 0;
  $(document).find('.price_subtotal').each(function(){
    precio = $(this).val();
    if (!isNaN(precio) &&  precio != ""){
      valor += parseFloat(precio);
    }
  });
  return valor;
};

var calculo_total = function (){


  var subtotal = $('#invoice_subtotal').val();
  var discount = $('#invoice_discount').val();

  if (isNaN(subtotal) || subtotal =="")
  {
    subtotal = 0;
  }

  if (isNaN(discount) || discount =="")
  {
    subtotal = 0;
  }


  total = parseFloat(subtotal) - ((parseFloat(subtotal) * parseFloat(discount ))/100);
  return total;

};

var last_field = function(){

  var precio;
  $(document).find('.price_subtotal').each(function(){
    precio = $(this).val();
  });

  return precio;
};

$(document).ready(function(){
  $('#count_row').append(1);
  $(".add_fields").on('click',function(event){

    num_children =  $(document).find('.count_row').size(); 
    $('.count_row > div').first().append( $( "<div class='count_row'>" ) );
    $('.count_row').last().append(num_children);
  });


  $(document).on('click','.remove_fields_orders', function(event){
    $(this).closest('span.line2').find('input[type=hidden]').val('1');
    var price_remove = $(this).closest('span.line2').find('input.price_subtotal').val();
    var price_total = $('#invoice_price_total').val();

    if (isNaN(price_total) || price_total == ""){price_total = 0;}
    if (isNaN(price_remove) || price_remove == ""){price_remove = 0;}
    if (price_total > 0)
    {
      var valor = parseFloat(price_total) - parseFloat(price_remove);
      valor = valor.toFixed(2);
    }
    price_total = $('#invoice_price_total').val(valor);
    $(this).closest('span.line2').remove()
    event.preventDefault();

    num_children =  $(document).find('.count_row').size(); 
    i = 1; 
      
    $.each($('.count_row'), function(index, value){
    $(this).text(i);
    i = i + 1;
    });

  });

  $('div.line1').on('keydown', '[data-autocomplete-for]', function(event){
    if (event.which == 13 ){
      event.preventDefault();
    }
    var input = $(this);
    input.autocomplete({
      source: function(request, response) {
        var sup = $('#_supplier_id').val();
        $.ajax({
          url: input.data('autocomplete-url'),
          dataType: 'json', data: { q: request.term, supplier_id: sup },
          success: function(data) {
            response(
              $.map(data, function(item) {
                return {label:item.label, item: item};
              })
            );
          },
        });
      },
      minLength: 2,
      autoFocus: true,
      select: function(event, ui) {
        input.val(ui.item.label);
        var field = this.id;
        var id = field.split("_");
        var field_article_id = '#invoice_orders_attributes_' + id[3] + '_article_id';
        var field_unit_price = '#invoice_orders_attributes_' + id[3] + '_price_unit';
        var field_unit_price_original = '#invoice_orders_attributes_' + id[3] + '_price_original';
        var quantity_stock = '#invoice_orders_attributes_' + id[3] + '_quantity_stock';
        var quantity = '#invoice_orders_attributes_' + id[3] + '_quantity';
        var price_subtotal = '#invoice_orders_attributes_' + id[3] + '_price_total';
        var allow_negative = '#invoice_orders_attributes_' + id[3] + '_allow_negative';

        if (ui.item.item.quantity < 1 )
          //              && ui.item.item.allow_negative == false )
        { 
          $(quantity).val(0);
          $(quantity).css("color", "red");
          $quantity = 0 ;
          $(this).css("color","red");
        } 

        $(field_article_id).val(ui.item.item.id);
        $(field_unit_price).val(ui.item.item.price_total);
        $(field_unit_price_original).val(ui.item.item.price_total);
        $(allow_negative).val(ui.item.item.allow_negative);
        $(quantity_stock).val(ui.item.item.quantity);
        $(price_subtotal).val(calculo_subtotal(ui.item.item.price_total, $(quantity).val() ).toFixed(2) );
        $('#invoice_subtotal').val(calculo_invoice_subtotal().toFixed(2));
        $('#invoice_price_total').val(calculo_total().toFixed(2));

      }    
    }).removeAttr('data-autocomplete-field');
  });


  $(document).on('blur', '.quantity, .package, .price_unit', function(event){

    var field = this.id;
    var id = field.split("_");
    var quantity = $('#invoice_orders_attributes_'+ id[3]+ '_quantity').val();
    var quantity_stock = $('#invoice_orders_attributes_'+ id[3]+ '_quantity_stock').val();
    var price_subtotal = '#invoice_orders_attributes_' + id[3] + '_price_total';
    var price_original = $('#invoice_orders_attributes_' + id[3] + '_price_original').val();
    var price = $('#invoice_orders_attributes_' + id[3] + '_price_unit').val();
    var package_qty   = $('#invoice_orders_attributes_' + id[3] + '_package').val();
    var allow_negative   = $('#invoice_orders_attributes_' + id[3] + '_allow_negative').val();


    if (package_qty == "" || parseFloat(package_qty) == 0)
    {
      package_qty = 1 ;
      $('#invoice_orders_attributes_' + id[3] + '_package').val(1);
    }

    var price_u = parseFloat(price) / parseFloat(package_qty);

    // $('#invoice_orders_attributes_' + id[3] + '_price_unit').val(price_u);
    if(allow_negative == 'true' || allow_negative == "")
    {
      $(price_subtotal).val(calculo_subtotal(price_u, quantity).toFixed(2) );
      $('#invoice_subtotal').val(calculo_invoice_subtotal().toFixed(2));
      $('#invoice_price_total').val(calculo_total().toFixed(2));
    }else{
      if (quantity_stock > 0  )
      {
        if (parseFloat(quantity) > parseFloat(quantity_stock))
        {
          $('#invoice_orders_attributes_'+ id[3]+ '_quantity').val(quantity_stock);
          quantity = quantity_stock;
        } 
        $(price_subtotal).val(calculo_subtotal(price_u, quantity).toFixed(2) );
        $('#invoice_subtotal').val(calculo_invoice_subtotal().toFixed(2));
        $('#invoice_price_total').val(calculo_total().toFixed(2));
      }else
      {
        $('#invoice_orders_attributes_'+ id[3]+ '_quantity').val(0);
      }
    }
  });

  $(document).on('blur','.price_unit_add', function(event){

    value = last_field();

    if (value != "" ){
      $(".add_fields").click();
    }
  });


  $(document).on('blur', '#invoice_discount', function(event){
    $('#invoice_price_total').val(calculo_total().toFixed(2));
  });

});
