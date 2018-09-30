class PaymentsController < ApplicationController
  def create
      token = params[:stripeToken]
      @product = Product.find(params[:product_id])
      @user = current_user

      # This will charge the user's card:
      begin
        charge = Stripe::Charge.create(
          :amount => (@product.price * 100).to_i,
          :currency => "usd",
          :source => token,
          :description => params[:stripeEmail],
          :receipt_email => params[:stripeEmail]
        )
        if charge.paid
          Order.create(product_id: @product.id,
        total: @product.price.to_i)

        end

      rescue Stripe::CardError => e
        # When the card has been declined
        body = e.json_body
        err = body[:error]
        flash[:error] = "Unfortunately, there was an error processing your payment: #{err[:message]}"
      end
     end


end
