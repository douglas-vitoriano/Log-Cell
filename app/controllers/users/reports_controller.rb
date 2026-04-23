module Admin
  class ReportsController < ApplicationController
    before_action :authenticate_user!

    def sales
      @from = params.fetch(:from, Date.current.beginning_of_month).to_date
      @to   = params.fetch(:to,   Date.current).to_date

      @sales      = Sale.by_period(@from, @to).includes(:customer, :user, :sale_items)
      @total_rev  = @sales.sum("total_cents - discount_cents").to_i
      @total_cnt  = @sales.count
      @by_payment = @sales.group(:payment_method).sum("total_cents - discount_cents")
      @by_day     = @sales.group_by_day(:sold_at).sum("total_cents - discount_cents")
    end

    def stock
      @critical  = Product.kept.where(stock_quantity: 0).includes(:category)
      @low       = Product.kept.where("stock_quantity > 0 AND stock_quantity < min_stock").includes(:category)
      @movements = Movement.includes(:product, :user).order(created_at: :desc).limit(50)
    end

    def cash_flow
      @from = params.fetch(:from, Date.current.beginning_of_month).to_date
      @to   = params.fetch(:to,   Date.current.end_of_month).to_date

      @receivable = AccountsReceivable.where(due_date: @from..@to).includes(:customer)
      @payable    = AccountsPayable.where(due_date: @from..@to).includes(:supplier)

      @total_in  = @receivable.where(aasm_state: "paid").sum("amount_cents").to_i
      @total_out = @payable.where(aasm_state: "paid").sum("amount_cents").to_i
      @balance   = @total_in - @total_out
    end

    def sale_pdf
      sale = Sale.find(params[:id])
      pdf  = PdfGenerator.sale_receipt(sale)
      send_data pdf, filename: "venda-#{sale.number}.pdf",
                     type: "application/pdf", disposition: "inline"
    end

    def product_label
      product = Product.find(params[:id])
      pdf     = PdfGenerator.product_label(product)
      send_data pdf, filename: "etiqueta-#{product.code}.pdf",
                     type: "application/pdf", disposition: "inline"
    end
  end
end
