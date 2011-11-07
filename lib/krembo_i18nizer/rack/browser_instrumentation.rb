require 'rack'
require 'krembo_i18nizer/agent.rb'
module KremboI18nizer::Rack
  class BrowserInstrumentation


    def initialize(app, options = {})
      @app = app
    end

    # method required by Rack interface
    def call(env)

      result = @app.call(env)   # [status, headers, response]
      status , headers, response = @app.call(env)

      if (should_instrument?(status, headers))
        response_string = autoinstrument_source(response, headers)
        if (response_string)
          Rack::Response.new(response_string, status, headers).finish
        else
          [status,headers,response]
        end
      else
        [status,headers,response]
      end
    end

    def should_instrument?(status, headers)
      status == 200 && headers["Content-Type"] && headers["Content-Type"].include?("text/html")
    end

    def autoinstrument_source(response, headers)
      source = nil
      response.each {|fragment| (source) ? (source << fragment) : (source = fragment)}
      return nil unless source

      body_start = source.index("<body")
      body_close = source.rindex("</body>")

      if body_start && body_close
        footer = ::KremboI18nizer::Agent.instrumentation_js_footer
        header = ::KremboI18nizer::Agent.instrumentation_css_header
        if source.include?('X-UA-Compatible')
          # put at end of header if UA-Compatible meta tag found
          head_pos = source.index("</head>")
        elsif head_open = source.index("<head")
          # put at the beginning of the header
          head_pos = source.index(">", head_open) + 1
        else
          # put the header right above body start
          head_pos = body_start
        end

        source = source[0..(head_pos-1)] + header + source[head_pos..(body_close-1)] + footer + source[body_close..-1]

        headers['Content-Length'] = source.length.to_s if headers['Content-Length']
      end

      source
    end


  end
end
