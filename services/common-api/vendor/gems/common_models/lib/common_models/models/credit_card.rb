module CommonModels
  class CreditCard < ActiveRecord::Base
    self.table_name = 'payment_service.credit_cards'

    store_accessor :data, :card_hash
  end
end
