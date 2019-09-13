class ProcessCreditCardPayment < Mutations::Command
  required do
    model :payment, class: CommonModels::CatalogPayment
  end

  def execute
    authorize_credit_card_payment
  end

  def authorize_credit_card_payment
    AuthorizeCreditCardPayment.run!(amount: payment.amount, card_hash: payment.card_hash)
  end

  def analyze_credit_card_payment

  end

  def capture_credit_card_payment

  end
end
