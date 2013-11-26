module Jsonview
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      response = @app.call(env)
      accept = env['HTTP_ACCEPT'] || ''

      if accept =~ /html/ && !(accept =~ /json/)
        status, headers, body = response
        content_type = headers['Content-Type'] || ''

        if content_type =~ /json/
          json = body.to_enum(:each).to_a.join
          html = html_document(JSON.parse(json))
          headers['Content-Type'] = "text/html;charset=utf-8"
          headers['Content-Length'] = html.bytesize.to_s
          response = [status, headers, [html]]
        end
      end

      response
    end

    def html_document(value)
      <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <style>
              null { color: red }
              string { color: green }
              number, boolean { color: blue }
              unknown { color: gray }
              hash, array { display: block; margin-left: 2em }
              key { font-weight: bold }
            </style>
          </head>
          <body>
            #{represent(value).join}
          </body>
        </html>
      HTML
    end

    def represent(value)
      case value
      when nil
        "<null>null</null>"
      when Numeric
        "<number>#{value}</number>"
      when TrueClass, FalseClass
        "<boolean>#{value}</boolean>"
      when Array
        [
          "[<array>\n",
          value.each_with_index.map do |v, i|
            [
              (",<br/>\n" if i > 0),
              represent(v),
            ]
          end,
          "\n</array>]",
        ]
      when Hash
        [
          "{<hash>\n",
          value.each_with_index.map do |(k, v), i|
            [
              (",<br/>\n" if i > 0),
              "<key>&quot;",
              encode(k.to_s),
              "&quot;</key>: ",
              represent(v),
            ]
          end,
          "\n</hash>}",
        ]
      when URI.regexp(%w[http https])
        [
          "&quot;<a href=\"",
          encode(value),
          "\">",
          encode(value),
          "</a>&quot;",
        ]
      when String
        [
          "<string>&quot;",
          encode(value),
          "&quot;</string>",
        ]
      else
        [
          "<unknown>&quot;",
          encode(value.inspect),
          "&quot;</unknown>",
        ]
      end
    end

    def encode(string)
      string.gsub /[<>&"]/, '<' => '&lt;', '>' => '&gt;', '&' => '&amp;', '"' => '\&quot;'
    end
  end
end
