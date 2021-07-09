# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!
module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include ApplicationHelper

    def logged_in?
      !session[:user_id].nil?
    end

    def create_session_for(user)
      session[:user_id] = user.id
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Pagy::Backend

    def create_session_for(user, password: "password", remember_me: "1")
      post sessions_create_path,
           params: { session: { email: user.email, password: password, remember_me: remember_me } }
    end
  end
end
