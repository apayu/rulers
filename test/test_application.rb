require_relative "test_helper"

class TestApp < Rulers::Application
  def get_controller_and_action(env)
    [TestController, "index"]
  end
end

class TestsController < Rulers::Controller
  def index
    'apa'
  end
end

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
   TestApp.new
  end

  def test_request
    get "tests/index"
    assert last_response.ok?
    body = last_response.body
    assert body['apa']
  end

  def test_bad_request
    get "tests/show"
    assert last_response.ok?
    body = last_response.body
    assert body['500']
  end
end
