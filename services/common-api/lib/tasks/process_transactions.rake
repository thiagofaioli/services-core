class ProcessTransactionsTask
  include Rake::DSL

  def initialize
    namespace :process_transactions do
      task :up do
        up
      end
    end
  end

  private

  def up
    loop do
      puts '### FETCHING PENDING TRANSACTION ###'

      pending_transactions.each do |transaction|
        Concurrent::Future.execute(executor: pool) do
          puts "### PROCESSING TRANSACTION #{transaction.id} ###"
          ProcessTransaction.run!(transaction: transaction)
        rescue => e
          puts e.message
        end
      end

      sleep 3
    end
  end

  def pending_transactions
    CommonModels::CatalogPayment.pending
  end

  def pool
    @pool ||= Concurrent::FixedThreadPool.new(40)
  end
end

ProcessTransactionsTask.new
