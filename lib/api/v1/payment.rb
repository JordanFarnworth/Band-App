module Api::V1::Payment
  include Api::V1::Json

  def payment_json(payment, includes = [])
    attributes = %w(entity_id gateway uuid amount state braintree_transaction_id created_at updated_at)

    api_json(payment, only: attributes)
  end

  def payments_json(payments, includes = [])
    payments.map { |p| payment_json(p, includes) }
  end
end
