class RenameSiteUrlInSiteHostname < ActiveRecord::Migration
  def change
    rename_column :sites, :url, :hostname
  end
end
