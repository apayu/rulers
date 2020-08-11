require "rulers/version"
require "rulers/array"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"

module Rulers
  class Error < StandardError; end

  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      begin
        klass, act = get_controller_and_action(env)
        controller = klass.new(env)
        text = controller.send(act)
        if controller.get_response
          st, hd, rs = controller.get_response.to_a
          [st, hd, rs]
        else
          controller.render_response(act.to_sym)
          st, hd, rs = controller.get_response.to_a
          [st, hd, rs]
        end
      rescue
        [500, {'Content-Type' => 'text/html'}, ['This is 500 page!!!!!!!!!!']]
      end
    end
  end

end
