# Example Terminal Backend

This is a simple [Sinatra](http://www.sinatrarb.com/) webapp that you can use to run the [Stripe Terminal](https://stripe.com/docs/terminal) example apps. To get started, you can choose from the following options:

1. [Run it on a free Heroku account](#running-on-heroku)
2. [Run it locally on your machine](#running-locally-on-your-machine)
3. [Run it locally via Docker CLI](#running-locally-with-docker)

ℹ️  You also need to obtain your Stripe **secret, test mode** API Key, available in the [Dashboard](https://dashboard.stripe.com/account/apikeys). Note that you must use your secret key, not your publishable key, to set up the backend. For more information on the differences between **secret** and publishable keys, see [API Keys](https://stripe.com/docs/keys). For more information on **test mode**, see [Test and live modes](https://stripe.com/docs/keys#test-live-modes).

## Running the app

### Running on Heroku

1. Set up a free [Heroku account](https://signup.heroku.com).
2. Click the button below to deploy the example backend. You'll be prompted to enter a name for the Heroku application as well as your Stripe API key.
3. Go to the [next steps](#next-steps) in this README for how to use this app

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/stripe/example-terminal-backend)

### Running locally on your machine

If you prefer running the backend locally, ensure you have the required [Ruby runtime](https://www.ruby-lang.org/en/documentation/installation/) version installed as per the [latest Gemfile in this repo](Gemfile).

You'll also need the correct [Bundler](https://bundler.io/) version, outlined in the [Gemfile.lock](Gemfile.lock) under the `BUNDLED_WITH` directive.

Clone down this repo to your computer, and then follow the steps below:

1. Create a file named `.env` within the newly cloned repo directory and add the following line:
```
STRIPE_TEST_SECRET_KEY={YOUR_API_KEY}
```
2. In your terminal, run `bundle install`
3. Run `ruby web.rb`
4. The example backend should now be running at `http://localhost:4567`
5. Go to the [next steps](#next-steps) in this README for how to use this app

### Running locally with Docker

We have a pre-built Docker image you can run locally if you're into the convenience of containers.

 Install [Docker Desktop](https://www.docker.com/products/docker-desktop) if you don't already have it. Then follow the steps below:

1. In your terminal, run `docker run -e STRIPE_TEST_SECRET_KEY={YOUR_API_KEY} -p 4567:4567 stripe/example-terminal-backend` (replace `{YOUR_API_KEY}` with your own test key)
2. The example backend should now be running at `http://localhost:4567`
3. Go to the [next steps](#next-steps) in this README for how to use this app

---

## Next steps

Next, navigate to one of our example apps. Follow the instructions in the README to set up and run the app. You'll provide the URL of the example backend you just deployed.

| SDK | Example App |
|  :---  |  :---  |
| iOS | https://github.com/stripe/stripe-terminal-ios |
| JavaScript | https://github.com/stripe/stripe-terminal-js-demo |
| Android | https://github.com/stripe/stripe-terminal-android |

⚠️ **Note that this backend is intended for example purposes only**. Because endpoints are not authenticated, you should not use this backend in production.

