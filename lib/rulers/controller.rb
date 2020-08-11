require 'erubi'
require 'rulers/file_model'

module Rulers
  class Controller
    include Rulers::Model

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def render(view_name)
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eval(Erubi::Engine.new(template).src)
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ""
      Rulers.to_underscore klass
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end
  end
end
