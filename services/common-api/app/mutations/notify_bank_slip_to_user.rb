class NotifyBankSlipToUser < Mutations::Command
  required do
    model :payment, class: CommonModels::CatalogPayment
  end

  def execute
    ActiveRecord::Base.connection.execute <<-SQL
      SELECT
        *
      FROM
        notification_service.notify('slip_subscription_payment', \'#{notification_data.to_json}\'::json)
    SQL
  end

  def notification_data
    {
      relations: {
        catalog_payment_id: payment.id,
        subscription_id: payment.subscription_id,
        project_id: payment.project_id,
        reward_id: payment.reward_id,
        user_id: payment.user_id
      }
    }
  end
end
