class ProcessPayment < Mutations::Command
  required do
    model :payment, class: CommonModels::CatalogPayment
  end

  def execute
    add_payment_to_processed_list
    process_payment
  end

  def add_payment_to_processed_list
    CommonModels::ProcessedPayment.create!(catalog_payment_id: payment.id)
  end

  def process_payment
    if payment.is_bank_slip?
      register_bank_slip
    else
      process_credit_card_payment
    end
  end

  def register_bank_slip
    ProcessBankSlip.run!(payment: payment)
  end

  def process_credit_card_payment
    ProcessCreditCardPayment.run!(payment: payment)
  end
end
