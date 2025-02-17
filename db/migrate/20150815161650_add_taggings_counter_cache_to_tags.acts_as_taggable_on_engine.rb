# This migration comes from acts_as_taggable_on_engine (originally 3)
class AddTaggingsCounterCacheToTags < ActiveRecord::Migration[7.0]
  def self.up
    add_column :tags, :taggings_count, :integer, default: 0

    ActsAsTaggableOn::Tag.reset_column_information
    ActsAsTaggableOn::Tag.find_each do |tag|
      ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings) rescue nil # undefined method `counter_cache_column' for nil:NilClass
    end
  end

  def self.down
    remove_column :tags, :taggings_count
  end
end
