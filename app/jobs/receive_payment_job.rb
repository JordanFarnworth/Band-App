class ReceivePaymentJob < ActiveJob::Base
  queue_as :payment

  def perform(payment, params)
    @payment = payment
    @entity = @payment.entity
    begin
      customer = Braintree::Customer.find @entity.braintree_customer_id
    rescue Braintree::NotFoundError
      # Customer does not exist in Braintree.  Create it now
      Braintree::Customer.create id: @entity.braintree_customer_id,
        email: @entity.email
    end
    result = Braintree::Transaction.sale order_id: @payment.uuid,
      payment_method_nonce: params['payment_method_nonce'],
      amount: @payment.amount,
      customer_id: @entity.braintree_customer_id,
      options: { submit_for_settlement: true }
    @payment.braintree_transaction_id = result.transaction.id
    case result.transaction.processor_response_code.to_i
      when 1000..1999
        @payment.mark_as_processed!
      when 2000..2999
        @payment.mark_as_failed!
      else
        raise 'Payment gateway seems to be offline.  Reprocess later.'
    end
  end
end
