module KremboI18nizer
  module Agent
    def self.instrumentation_js_footer
      return '<script src="/assets/krembo_i18nizer/agent.js"></script>'.html_safe
    end

    def self.instrumentation_css_header
      return '<link href="/assets/krembo_i18nizer/agent.css" media="screen" rel="stylesheet" type="text/css" />'.html_safe
    end
  end
end
