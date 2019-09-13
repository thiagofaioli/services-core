class ProcessPaymentsTask
  include Rake::DSL

  def initialize
    namespace :process_payments do
      task up: :environment do
        up
      end
    end
  end

  private

  def up
    loop do
      puts 'Fetching pending payments'

      threads = pending_payments.map do |payment|
        Concurrent::Future.execute(executor: pool) do
          puts "Processing payment #{payment.id}"
          ProcessPayment.run!(payment: payment)
          puts "Finished processingpayment #{payment.id}"
        rescue => e
          puts "Error on processing payment #{payment.id}: #{e.message}"
          notify_sentry(e)
        end
      end

      threads.map(&:value)
      sleep 3
    end
  end

  private def pending_payments
    CommonModels::CatalogPayment.pending
  end

  private def pool
    @pool ||= Concurrent::FixedThreadPool.new(40)
  end

  private def notify_sentry(exception)
    puts exeception
  end
end

ProcessPaymentsTask.new
