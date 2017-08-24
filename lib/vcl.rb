require 'typhoeus'
require 'thor'
require 'diffy'
require 'json'
require 'uri'
require 'launchy'
require 'erb'
require 'yaml'

require 'vcl/version'
require 'vcl/fetcher'
require 'vcl/utils'
require 'vcl/cli'

include ERB::Util

# Main module for the vcl_cli gem
module VCL
  COOKIE_JAR = ENV['HOME'] + '/.vcl_cookie_jar'
  TOKEN_FILE = ENV['HOME'] + '/.vcl_token'
  CREDENTIALS = ENV['HOME'] + '.fastly/credentials'
  FASTLY_API = 'https://api.fastly.com'.freeze
  FASTLY_APP = 'https://manage.fastly.com'.freeze
  TANGO_PATH = '/configure/services/'.freeze

  if File.exist?(VCL::CREDENTIALS)
    YAML.load(File.read(VCL::CREDENTIALS))
  else
    Cookies = File.exist?(COOKIE_JAR) ? JSON.parse(File.read(COOKIE_JAR)) : {}
    Token = File.exist?(VCL::TOKEN_FILE) ? File.read(VCL::TOKEN_FILE) : false
  end
end
