class AddBackgroundToSpreeTaxons < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_taxons, :background_file_name, :string
    add_column :spree_taxons, :background_content_type, :string
    add_column :spree_taxons, :background_file_size, :integer
    add_column :spree_taxons, :background_updated_at, :timestamp
  end
end
