class InvoiceStockPdf < Prawn::Document
  require 'prawn'
  require 'barby'
  require 'barby/barcode/code_39'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/prawn_outputter'

  def initialize(group_label)
    super(margin: 1, page_size: [100, 30])
    @group_label = group_label
    labels 
  end

  def labels
    x_aux = 5
    y_aux = 0
    x = 5
    y = 5 
    b = 1
    y_total = 0
    @group_label.each do |g|
      1.upto(g.quantity_labels) do |a|
        if !g.article.code_supplier.blank?
           b = b + 1
       #  if (y >= 750 )
       #     x_aux = 300
       #     y = 0  
       #   end

          barcode_text(g.article.code_supplier, g.article.name, x , y)
          x = x + 30 
          y = (y ) 
          y_total = y_total +  35


          if ( b > 3)
            start_new_page
            x = 5
            b = 1 
          end
        end
      end
    end
  end

  def barcode_text(code_supplier, name,x , y) 
    font_size(4)
    text = code_supplier + " - " + name
    text = text[1,15]
    draw_text text,  :at=> [x,y - 5]
    translate(x, y) do
      barcode = Barby::Code39.new(code_supplier, true)
      barcode.annotate_pdf(self, :height=> 20, :xdim=> 0.13)
    end
  end 
end
