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
        <html>
          <head>
            <style>
              null { color: red }
              string { color: green }
              number { color: blue }
              hash, array { display: block; margin-left: 20px }
              key { font-weight: bold }
            </style>
          </head>
          <body>
            #{represent(value)}
          </body>
        </html>
      HTML
    end

    def represent(value)
      case value
      when nil
        "<null>NULL</null>"
      when String
        "<string>\"#{encode(value)}\"</string>"
      when Fixnum
        "<number>#{value.to_s}</number>"
      when TrueClass, FalseClass
        "<boolean>#{value.to_s}</boolean>"
      when Array
        "[\n#{value.map{|v| "<array>#{represent(v)}</array>\n" }.join}]\n"
      when Hash
        "{\n#{value.to_a.map{|(k, v)| "<hash><key>#{encode(k.to_s)}</key>: #{represent(v)}</hash>\n" }.join}}\n"
      else
        raise "Didn't expect a #{value.class}"
      end
    end

    def encode(string)
      string.gsub /[<>&"]/, '<' => '&lt;', '>' => '&gt;', '&' => '&amp;', '"' => '&quot;'
    end
  end
end
