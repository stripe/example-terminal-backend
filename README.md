# Example Terminal Backend

This is a simple [Sinatra](http://www.sinatrarb.com/) webapp that you can use to run the [Stripe Terminal](https://stripe.com/docs/terminal) example apps. To get started:

1. Set up a free [Heroku account](https://signup.heroku.com). 

2. Obtain your Stripe **secret, test mode** API Key, available in the [Dashboard](https://dashboard.stripe.com/account/apikeys). Note that you must use your secret key, not your publishable key, to set up the backend. For more information on the differences between **secret** and publishable keys, see [API Keys](https://stripe.com/docs/keys). For more information on **test mode**, see [Test and live modes](https://stripe.com/docs/keys#test-live-modes).

3. Click the button below to deploy the example backend. You'll be prompted to enter a name for the Heroku application as well as your Stripe API key. 

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Next, navigate to one of our example apps. Follow the instructions in the README to set up and run the app. You'll provide the URL of the example backend you just deployed.

| SDK | Example App |
|  :---  |  :---  |
| iOS | https://github.com/stripe/stripe-terminal-ios |
| JavaScript | https://github.com/stripe/stripe-terminal-js-demo |
| Android | https://github.com/stripe/stripe-terminal-android |

**Note that this backend is intended for example purposes only**. Because endpoints are not authenticated, you should not use this backend in production.

### Running locally
If you prefer running the backend locally:

1. Create a file named `.env` and add the following line
```
STRIPE_TEST_SECRET_KEY={YOUR_API_KEY}
```
2. Run `bundle install`
3. Run `ruby web.rb`

4. The example backend should now be running at `http://localhost:4567`
