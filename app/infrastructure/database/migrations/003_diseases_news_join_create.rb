# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:diseases_news) do
      primary_key [:disease_id, :news_id]
      foreign_key :disease_id, :diseases
      foreign_key :news_id, :news

      index [:disease_id, :news_id]
    end
  end
end