class RegisterBankSlip < Mutations::Command
  required do
    string :amount
    hash :customer do
      required do
        string :name
        string :type
        string :document
        boolean :is_international
      end
    end
  end

  def execute
    PagarMe::Transaction.new(transaction_data).create
  end

  private def transaction_data
    {
      amount: amount,
      payment_method: 'boleto',
      customer: {
        name: customer[:name],
        type: customer[:type],
        documents: [
          { type: document_type, number: customer[:document] }
        ]
      }
    }
  end

  private def document_type
    if customer[:document].size == 11
      'cpf'
    else customer[:document].size == 14
      'cnpj'
    end
  end
end
