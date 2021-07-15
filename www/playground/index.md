YAML Development Playgrounds
============================

Welcome to the playground area.
Here you'll find live demos of activity related to ongoing YAML language
development.

## Playgrounds

* [YAML Parsers](parser)

  Compare YAML parsers in several programming languages.
  The non-JavaScript parsers require you to run a local Docker sandbox
  container.
  See below for details.

* [JavaScript](javascript)

  This playground compares the JavaScript loaders.

* [Playground Development](devel)

  This is a playground that we use mostly for developing the playground
  functionality itself.

## Setting up a Local Sandbox

YAML frameworks are implemented in many programming languages.
We want to be able to let you try all of them.
This means we need a backend server to run the code.

This, of course, has lots of security and hosting concerns.

The way we get around all that is to have you host the backend yourself!
Docker makes this trivial to do, and also assures that the only evil you can do
is to your own machine. :)

The playground will inform you when you need to run Docker, but we'll cover it
here.

Assuming you have [Docker installed](https://docs.docker.com/get-docker/), just
run this command from a terminal:
```
docker run --rm -p 31337:31337 \
  yamlio/playground-sandbox:0.0.3 https
```

This will start a local YAML Playground backend server, and your playgrounds
will be able to work with them.

NOTE: Port 1337 is for http calls, and port 31337 is for https calls.
These defaults will likely be made configurable in the future.

### Required Browser Tweaks

Calling a localhost server from a web page breaks some browser security rules,
but it's pretty simple to work around them for this.

You'll need to open this URL one time:

* https://spec.yaml.io:31337/

and authorize the untrusted SSL certificate for it.

The other thing you need to do is allow JavaScript to "allow invalid
certificates for resources loaded from localhost".
So far, we only have figured out how to do this on the Google Chrome browser.

* Google Chrome
  * Type `chrome://flags` into the browser URL location
  * Search for `#allow-insecure-localhost` in the "Search flags" box
  * Enable the "Allow invalid certificates for resources loaded from localhost"
    flag
  * Click the "Relaunch" button

That's everything.
You should be all set to use all the playground things that need to
run untrusted input on a server!

We'll keep looking for ways to make this simpler.
If you have ideas, let us know!
