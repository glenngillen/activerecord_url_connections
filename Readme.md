# ActiveRecord URL Connections

This gem adds support to ActiveRecord for connecting to a database by
specifying a URL rather than a hash of parameters. Many ruby adapters
have opted for this format (DataMapper, Sequel, MongoDB, etc.) in
addition to numerous alternatives in other languages. So why should AR
be missing out on all the fun?

The other notable benefit is that you can continue to use
`config/database.yml` in development, while setting an ENV variable
of `DATABASE_URL` on your production server to specify the connection
settings. No more risk of committing sensitive database credentials into
version control, or having to worry about Capistrano moving the relevant
production file into place on deploy.

## Usage

The URL takes the form of:

    <adapter>://<user>:<password>@<hostname>:<port>/<database>?<options>

Where options is a query string of key value pairs. For example:

    mysql://app:s3crets@127.0.0.1:5123/nyancat_production?encoding=utf8

Only `adapter`, `hostname`, and `database` are required. Everything else
is optional, so to connect using local user permissions in postgres just do:

    postgres://localhost/nyancat_production

## Installation

Either in your `Gemfile`:

    gem "activerecord_url_connections"

Or install it directly onto your system with rubygems:

    gem install activerecord_url_connections

Then require in your app:

    require "activerecord_url_connections"

## License

ActiveRecord URL Connections is MIT Licensed

Copyright (C) 2011 by Glenn Gillen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[![Analytics](https://ga-beacon.appspot.com/UA-46840117-1/activerecord_url_connections/readme?pixel)](https://github.com/igrigorik/ga-beacon)
