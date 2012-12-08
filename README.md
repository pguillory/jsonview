# Jsonview

Jsonview is a Rack middleware to help with inspecting JSON API responses in a browser. When the browser asks for HTML and *not* JSON and the server returns JSON anyway, this middleware will convert the response into a pretty-printed HTML representation. API calls made from Javascript or a server will not have Accept:text/html headers and should be unaffected.

Inspired by http://jsonview.com/

## Installation

Add this line to your application's Gemfile:

    gem 'jsonview'

In Rails apps, it will add the middleware automatically. In other environments, you'll have to add it manually:

    use Jsonview::Middleware
