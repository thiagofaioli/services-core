class AuthorizeCreditCardPayment < Mutations::Command
  required do
    float :amount
    string :card_hash
  end

  def execute
    @transaction ||= PagarMe::Transaction.new(
      amount: amount,
      card_hash: card_hash,
      capture: false
    ).create
  end
end
