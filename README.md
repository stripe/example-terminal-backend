# Example Terminal Backend

This is a simple [Sinatra](http://www.sinatrarb.com/) webapp that you can use to run the [Stripe Terminal](https://stripe.com/docs/terminal) example apps.

1. Set up a free [Heroku account](https://signup.heroku.com). 

2. Connect your Heroku account to GitHub on your Heroku [Account](https://dashboard.heroku.com/account/applications) page.

3. Obtain your Stripe test secret [API Key](https://stripe.com/docs/keys#api-keys), available in the [Dashboard](https://dashboard.stripe.com/account/apikeys).

4. Click the button below to deploy the example backend. You'll be prompted to enter a name for the Heroku application as well as your Stripe API key.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Next, navigate to one of our example apps. Follow the instructions to set up and run the app using the URL of your Heroku app you just deployed.

| SDK | Example App |
|  :---  |  :---  |
| iOS | https://github.com/stripe/stripe-terminal-ios |
| JavaScript | https://github.com/stripe/stripe-terminal-js |
| Android | https://github.com/stripe/stripe-terminal-ios |

**Note that this backend is intended for example purposes only**. You'll likely want to use something more serious for your app in production.

### Running locally
If you prefer running the backend locally:

1. Create a file named `.env` and add the following line
```
STRIPE_TEST_SECRET_KEY={YOUR_API_KEY}
```
2. Run `bundle install`
3. Run `ruby web.rb`

4. The example backend should now be running at `http://localhost:4567`
