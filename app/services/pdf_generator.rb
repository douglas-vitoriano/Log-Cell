class PdfGenerator
  def self.sale_receipt(sale)
    Prawn::Document.new(page_size: "A5") do |pdf|
      pdf.font_families.update(
        "Ubuntu" => { normal: Rails.root.join("vendor/fonts/Ubuntu-R.ttf") }
      )
      pdf.font "Ubuntu"

      pdf.text "LOG CELL", size: 18, style: :bold, align: :center
      pdf.text "Av. Calil Mohamad Rahal, 56 — Mercado Lopes, Barueri/SP", size: 9, align: :center
      pdf.text "(11) 98952-8468 | @log_cell_acessorios", size: 9, align: :center
      pdf.move_down 10
      pdf.stroke_horizontal_rule

      pdf.move_down 8
      pdf.text "RECIBO DE VENDA #{sale.number}", size: 12, style: :bold
      pdf.text "Data: #{sale.sold_at.strftime('%d/%m/%Y')}", size: 10
      pdf.text "Cliente: #{sale.customer&.name || 'Balcão'}", size: 10
      pdf.text "Vendedor: #{sale.user.name}", size: 10
      pdf.move_down 8

      data = [ [ "Produto", "Qtd", "Unit.", "Total" ] ] +
        sale.sale_items.includes(:product).map do |item|
          [
            item.product.name,
            item.quantity,
            item.unit_price.format,
            item.subtotal.format
          ]
        end

      pdf.table(data, width: pdf.bounds.width, header: true,
        row_colors: [ "FFFFFF", "F5F5F5" ],
        cell_style: { size: 9, borders: [ :bottom ], border_color: "DDDDDD" }
      ) do
        row(0).background_color = "1A1A2E"
        row(0).text_color = "FFFFFF"
        row(0).font_style = :bold
      end

      pdf.move_down 8
      pdf.text "Desconto: #{sale.discount.format}", size: 10, align: :right if sale.discount_cents > 0
      pdf.text "TOTAL: #{Money.new(sale.net_total_cents, 'BRL').format}",
        size: 14, style: :bold, align: :right
      pdf.text "Pagamento: #{sale.payment_method.humanize}", size: 10, align: :right

      pdf.move_down 12
      pdf.text "Obrigado pela preferência! 🙏", size: 10, align: :center, style: :italic
    end.render
  end

  def self.product_label(product)
    Prawn::Document.new(page_size: [ 170, 90 ], margin: 4) do |pdf|
      pdf.text product.name, size: 8, style: :bold
      pdf.text product.code, size: 7
      pdf.text product.price.format, size: 14, style: :bold, align: :right

      if product.barcode.present?
        barcode_data = Base64.strict_decode64(product.barcode_image)
        pdf.image StringIO.new(barcode_data), at: [ 0, pdf.cursor - 4 ], width: 120, height: 35
      end
    end.render
  end
end
