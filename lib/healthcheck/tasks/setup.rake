# frozen_string_literal: true

require 'fileutils'

DESTINATION = 'config/initializers/healthcheck.rb'
SOURCE = 'configs'
OLD_ROUTES = 'config/routes.rb'
NEW_ROUTES = 'config/routes.rb.new'
ROUTES_SETUP = '  Healthcheck.routes(self)'
ROUTES_INIT = 'Rails.application.routes.draw do'

namespace :healthcheck do
  desc 'Install the files and settings to the gem Healthcheck works'
  task :install do
    FileUtils.mkdir_p(File.dirname(DESTINATION))
    FileUtils.cp(SOURCE, DESTINATION)
    return unless File.exist?(OLD_ROUTES)

    File.open(NEW_ROUTES, 'w') do |new_routes|
      File.foreach(OLD_ROUTES) do |line|
        new_routes.puts(line)
        if line.strip == ROUTES_INIT
          new_routes.puts(ROUTES_SETUP)
          new_routes.puts ''
        end
      end
    end

    File.delete(OLD_ROUTES)
    File.rename(NEW_ROUTES, OLD_ROUTES)
  end
end
