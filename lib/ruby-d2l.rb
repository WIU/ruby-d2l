require 'ruby-d2l/auth'

require 'ruby-d2l/config'
require 'ruby-d2l/version'

require 'ruby-d2l/grades'
require 'ruby-d2l/org_unit'
require 'ruby-d2l/tools'
require 'ruby-d2l/user'

# RubyD2L
module RubyD2L
  extend Config

  # Yields this module to a given +block+. Please refer to the
  # <tt>RubyD2L::Config</tt> module for configuration options.
  def self.configure
    yield self if block_given?
  end

  # Savon.configure do |config|
  #   config.log = false
  # end
  # HTTPI.log = false
end
