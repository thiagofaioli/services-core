class AuthorizeTransaction < Mutations::Command
  required do
    float :amount

    string :card_hash
  end

  def execute
    authorize_transaction
  end

  def transaction
    @transaction ||= PagarMe::Transaction.new(
      amount: amount,
      card_hash: card_hash,
      capture: false
    )
  end

  def authorize_transaction
    @response = transaction.create
  end
end
