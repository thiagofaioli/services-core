module CommonModels
  class ProcessedPayment < ActiveRecord::Base
    self.table_name = 'payment_service.processed_payments'

    belongs_to :catalog_payment
  end
end
