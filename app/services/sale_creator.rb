class SaleCreator
  attr_reader :sale, :error

  def initialize(params, user:)
    @params = params
    @user   = user
  end

  def call
    ActiveRecord::Base.transaction do
      @sale = Sale.new(@params.merge(user: @user))
      @sale.save!
      @sale.complete!
    end
    true
  rescue ActiveRecord::RecordInvalid, AASM::InvalidTransition => e
    @error = e.message
    false
  end

  def success?
    @error.nil?
  end
end
