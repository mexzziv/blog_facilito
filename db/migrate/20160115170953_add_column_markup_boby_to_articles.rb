class AddColumnMarkupBobyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :markup_body, :text
  end
end
