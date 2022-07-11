require 'allure-rspec'
require 'faker'
require 'json'
require 'pry'
require 'rspec'

require './lib/api/authorise'
require './lib/api/booking'
require './lib/payloads/authorise_payload'
require './lib/payloads/booking_payload'

require_all './steps'

AllureRspec.configure do |config|
  config.results_directory = 'report/allure-results'
  config.clean_results_directory = true
  config.link_tms_pattern = 'https://example.org/tms/{}'
  config.link_issue_pattern = 'https://example.org/issue/{}'
  config.logging_level = Logger::INFO
end

RSpec.configure do |config|
  config.formatter = AllureRspecFormatter

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after do |example|
    Allure.step name: example.metadata[:full_description]
    Allure.add_attachment(
      name: 'After hook attachment',
      source: 'Attachment',
      type: Allure::ContentType::TXT,
      test_case: true
    )
  end
end
