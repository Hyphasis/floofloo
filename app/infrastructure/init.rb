# frozen_string_literal: true

folders = %w[floofloo]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
