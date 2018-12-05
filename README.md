# Example Terminal Backend

This is a simple [Sinatra](http://www.sinatrarb.com/) webapp that you can use to run the [Stripe Terminal](https://stripe.com/docs/terminal) example apps.

| Platform | Example App |
|  :---  |  :---  |
| iOS | https://github.com/stripe/stripe-terminal-ios |
| JavaScript | https://github.com/stripe/stripe-terminal-js |
| Android | Coming Soon |

**Note that backend is intended for example purposes only**. You'll likely want to use something more serious for your app in production.

To deploy this for free on Heroku, click this button:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

_Note: you may need to connect your Heroku account to GitHub for this to work._

Then, set the "Backend URL" in our example apps to the URL of your Heroku app.

### Running locally
If you prefer running the backend locally:

1. Create a file named `.env` and add the following line
```
STRIPE_TEST_SECRET_KEY={YOUR_API_KEY}
```
2. Run `bundle install`
3. Run `ruby web.rb`

4. The example backend should now be running at `http://localhost:4567`
