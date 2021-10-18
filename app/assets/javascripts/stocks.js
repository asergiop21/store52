var calculo_subtotal_stock = function(price, quantity, iva){
  if (price == ""){price = 0}
  if (quantity == ""){quantity = 0}
  if (iva == ""){iva = 0}
  //var subtotal = ((parseFloat(price) * parseFloat(iva))/100) + parseFloat(price) * parseFloat(quantity) ;
  var subtotal_iva = ((parseFloat(price) * parseFloat(quantity)) *  parseFloat(iva))/100;
  var subtotal = (parseFloat(price) * parseFloat(quantity)) + subtotal_iva ;
  return subtotal;
}

var calculo_total_stock = function(){
  var precio_total = $('#stock_price_total').val();
  if (precio_total == 0 || precio_total == isNaN)
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

$(document).ready(function(){

  $(document).on('click','.remove_fields_stocks', function(event){
    $(this).closest('span.line2').remove()
      event.preventDefault();
  });

  $(document).on('keydown', '.line3_2', function(event){
    if (event.which == 13 ){
      //console.log(event.which);
      event.preventDefault();
    }
    var input = $(this);
    input.autocomplete({
      source: function(request, response) {

        var sup = $('#invoice_stock_supplier_idis').val();
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
        var field_article_id = '#invoice_stock_stocks_attributes_' + id[4] + '_article_id';
        var category_id = '#invoice_stock_stocks_attributes_' + id[4] + '_category_id';
        var option_category = ui.item.item.category_id;
        var price_cost = '#invoice_stock_stocks_attributes_' + id[4] + '_price_cost';
        var iva = '#invoice_stock_stocks_attributes_' + id[4] + '_iva';
        var barcode = '#invoice_stock_stocks_attributes_' + id[4] + '_barcode';
        $(category_id).val(option_category);
        $(field_article_id).val(ui.item.item.id);
        $(price_cost).val(ui.item.item.price_cost);
        $(iva).val(ui.item.item.iva);
        $(barcode).val(ui.item.item.barcode);

      }
    }).removeAttr('data-autocomplete-field');
  });

  $(document).on('blur', '.price_cost_stock, .quantity, .iva', function(){

    var field = this.id;
    var id = field.split("_");
    var field_quantity = '#invoice_stock_stocks_attributes_' + id[4] + '_quantity';
    var field_price_cost = '#invoice_stock_stocks_attributes_' + id[4] + '_price_cost';
    var field_price_subtotal = '#invoice_stock_stocks_attributes_' + id[4] + '_price_total';
    var field_iva = '#invoice_stock_stocks_attributes_' + id[4] + '_iva';
    var qty_labels = '#invoice_stock_stocks_attributes_' + id[4] + '_quantity_labels';

    $(qty_labels).val($(field_quantity).val());
    $(field_price_subtotal).val(calculo_subtotal_stock($(field_price_cost).val(), $(field_quantity).val(), $(field_iva).val()).toFixed(2) );
    $('#invoice_stock_price_total').val(calculo_total_stock().toFixed(2));

  });

  $(document).on('focus click', function(){

    $('.datepicker').datepicker();
  });
});
