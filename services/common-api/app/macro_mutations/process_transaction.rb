class ProcessTransaction < Mutations::Command
  required do
    model :transaction, class: CommonModels::CatalogPayment
  end

  def execute
    add_transaction_to_processed_list
    authorize_transaction
  end

  def add_transaction_to_processed_list
    CommonModels::ProcessedPayment.create!(catalog_payment_id: transaction.id)
  end

  def authorize_transaction
    Rails.logger.error transaction.card_hash
    Rails.logger.error transaction.amount
    AuthorizeTransaction.run!(amount: transaction.amount, card_hash: transaction.card_hash)
  end
end
