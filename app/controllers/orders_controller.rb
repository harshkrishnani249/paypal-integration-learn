class OrdersController < ApplicationController
    skip_before_action :verify_authencity_token, raise: false

    before_action :paypal_init, :except => [:index]

    def index; end

    def create_order
        binding.pry
        price = '100.00'
        request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
        request.request_body({
            :intent => 'CAPTURE',
            :purchase_units => [
              {
                :amount => {
                  :currency_code => 'USD',
                  :value => price
                }
              }
            ]
          })
          

          begin
            binding.pry
            response = @client.execute request
            order = Order.new
            order.price = price.to_i
            order.token = response.result.id
            if order.save
              return render :json => {:token => response.result.id}, :status => :ok
            end
          rescue PayPalHttp::HttpError => ioe
            # HANDLE THE ERROR
          end

    end

    def capture_order

        request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new params[:order_id]

        begin 
            reponse = @client.execute request
            order = Order.find_by :token => params[order_id]
            order.paid = response.result.status == 'COMPLETED'

            if order.save
              return render :json => {:status => response.result.status}, :status => :ok
            end

            rescue PayPalHttp::HttpError => ioe
              # HANDLE THE ERROR
            end

    end


    private

    def paypal_init
        client_id = "AaXtxMK2tjPqY7bYlBvMZpR7Z6USFvtxd6azdh7Dx_LycYPvnts7gNXfil0nL3mymw99IE0y6DIPYqHY"
        client_secret = "EF2AvdEt9JLrUvD86ul6laV3Io9tzpA7hFRdT44b9y6QHZSLm-BHPBRX84ajZAdP_WlXdA69yf_AUj7d"


        environment = PayPal::SandboxEnvironment.new client_id, client_secret
        @client = PayPal::PayPalHttpClient.new environment
    end

end
