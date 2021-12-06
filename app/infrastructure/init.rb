# frozen_string_literal: true

folders = %w[news donation]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
