require 'sinatra'
require 'stripe'
require 'dotenv'
require 'json'
require 'sinatra/cross_origin'

# Browsers require that external servers enable CORS when the server is at a different origin than the website.
# https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
# This enables the requires CORS headers to allow the browser to make the requests from the JS Example App.
configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

options "*" do
  response.headers["Allow"] = "GET, POST, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

Dotenv.load
Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
Stripe.api_version = '2019-03-14'

def log_info(message)
  puts "\n" + message + "\n\n"
  return message
end

get '/' do
  status 200
  send_file 'index.html'
end

# This endpoint registers a Verifone P400 reader to your Stripe account.
# https://stripe.com/docs/terminal/readers/connecting/verifone-p400#register-reader
post '/register_reader' do
  begin
    reader = Stripe::Terminal::Reader.create(
      :registration_code => params[:registration_code],
      :label => params[:label]
    )
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error registering reader! #{e.message}")
  end

  log_info("Reader registered: #{reader.id}")

  status 200
  return reader.to_json
end

# This endpoint creates a ConnectionToken, which gives the SDK permission
# to use a reader with your Stripe account.
# https://stripe.com/docs/terminal/sdk/js#connection-token
# https://stripe.com/docs/terminal/sdk/ios#connection-token
# https://stripe.com/docs/terminal/sdk/android#connection-token
post '/connection_token' do
  begin
    token = Stripe::Terminal::ConnectionToken.create
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error creating ConnectionToken! #{e.message}")
  end

  content_type :json
  status 200
  token.to_json
end

# This endpoint creates a PaymentIntent.
# https://stripe.com/docs/terminal/payments#create
post '/create_payment_intent' do
  begin
    payment_intent = Stripe::PaymentIntent.create(
      :payment_method_types => ['card_present'],
      :capture_method => 'manual',
      :amount => params[:amount],
      :currency => params[:currency] || 'usd',
      :description => params[:description] || 'Example PaymentIntent',
    )
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error creating PaymentIntent! #{e.message}")
  end

  log_info("PaymentIntent successfully created: #{payment_intent.id}")
  status 200
  return {:intent => payment_intent.id, :secret => payment_intent.client_secret}.to_json
end

# This endpoint captures a PaymentIntent.
# https://stripe.com/docs/terminal/payments#capture
post '/capture_payment_intent' do
  begin
    id = params["payment_intent_id"]
    payment_intent = Stripe::PaymentIntent.capture(id)
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error capturing PaymentIntent! #{e.message}")
  end

  log_info("PaymentIntent successfully captured: #{id}")
  # Optionally reconcile the PaymentIntent with your internal order system.
  status 200
  return {:intent => payment_intent.id, :secret => payment_intent.client_secret}.to_json
end

# Looks up or creates a Customer on your stripe account
# with email "example@test.com".
def lookupOrCreateExampleCustomer
  customerEmail = "example@test.com"
  begin
    customerList = Stripe::Customer.list(email: customerEmail, limit: 1).data
    if (customerList.length == 1)
      return customerList[0]
    else
      return Stripe::Customer.create(email: customerEmail)
    end
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error creating or retreiving customer! #{e.message}")
  end
end

# This endpoint attaches a PaymentMethod to a Customer.
# https://stripe.com/docs/terminal/payments/saving-cards#read-reusable-card
post '/attach_payment_method_to_customer' do
  begin
    customer = lookupOrCreateExampleCustomer

    payment_method = Stripe::PaymentMethod.attach(
      params[:payment_method_id],
      {
        customer: customer.id,
        expand: ["customer"],
    })
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error attaching PaymentMethod to Customer! #{e.message}")
  end

  log_info("Attached PaymentMethod to Customer: #{customer.id}")

  status 200
  return payment_method.to_json
end
