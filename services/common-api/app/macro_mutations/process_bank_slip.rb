class ProcessBankSlip < Mutations::Command
  required do
    model :payment, class: CommonModels::CatalogPayment
  end

  def execute
    raise 'Cannot issue bank slip to international contributor' if payment.is_international?
    register_bank_slip
    notify_user
    @transaction
  end

  def register_bank_slip
    @transaction = RegisterBankSlip.run!(
      amount: payment.amount,
      customer: {
        name: payment.customer['name'],
        type: payment.customer_type,
        document: payment.customer['document_number'],
        is_international: payment.is_international?
      }
    )
  end

  def notify_user
    NotifyBankSlipToUser.run!(payment: payment)
  end
end
