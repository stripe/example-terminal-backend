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

def log_info(message)
  puts "\n" + message + "\n\n"
  return message
end

get '/' do
  status 200
  return log_info("Great, your backend is set up! Now you can configure the Stripe Terminal example apps to point here.")
end

# This endpoint is used by the example apps to retrieve a ConnectionToken
# from Stripe.
# iOS           https://stripe.com/docs/terminal/ios#connection-token
# JavaScript    https://stripe.com/docs/terminal/js#connection-token
# Android       Coming Soon
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

# This endpoint is used by the example apps to capture a PaymentIntent.
# iOS           https://stripe.com/docs/terminal/ios/payment#capture
# JavaScript    https://stripe.com/docs/terminal/js/payment#capture
# Android       Coming Soon
post '/capture_payment_intent' do
  begin
    id = params["payment_intent_id"]
    payment_intent = Stripe::PaymentIntent.retrieve(id)
    payment_intent.capture
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error capturing PaymentIntent! #{e.message}")
  end

  log_info("PaymentIntent successfully captured: #{id}")
  # Optionally reconcile the PaymentIntent with your internal order system.
  status 200
  return {:intent => payment_intent.id, :secret => payment_intent.client_secret}.to_json
end

# This endpoint is used by the JavaScript example app to create a PaymentIntent.
# The iOS and Android example apps create the PaymentIntent client-side
# using the SDK.
# https://stripe.com/docs/terminal/js/payment#create
post '/create_payment_intent' do
  begin
    payment_intent = Stripe::PaymentIntent.create(
      :allowed_source_types => ['card_present'],
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

# This endpoint is used by the JS example app to register a Verifone P400 reader
# to your Stripe account.
# https://stripe.com/docs/api/terminal/readers/create
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

# This endpoint is used to create a customer and save a card source to it.
# https://stripe.com/docs/terminal/js/workflows#save-source
post '/save_card_to_customer' do
  begin
    card_source = Stripe::Source.create(
      :type => "card",
      :card => {
        :card_present_source => params[:card_present_source_id],
      },
    )

    customer = lookupOrCreateExampleCustomer

    customer.source = card_source.id # obtained with Stripe.js
    customer.save
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error creating customer with reusable card source! #{e.message}")
  end

  log_info("Customer created with card source: #{customer.id}")

  status 200
  return customer.to_json
end

post '/save_payment_method_to_customer' do
  begin
    customer = lookupOrCreateExampleCustomer

    payment_method = Stripe::PaymentMethod.construct_from(id: params[:payment_method_id], object: "payment_method")
    payment_method = payment_method.attach(
      customer: customer.id
    )

    customer.refresh
  rescue Stripe::StripeError => e
    status 402
    return log_info("Error attaching PaymentMethod to Customer! #{e.message}")
  end

  log_info("Attached PaymentMethod to Customer: #{customer.id}")

  status 200
  return customer.to_json
end
