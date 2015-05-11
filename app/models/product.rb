class Product < ActiveRecord::Base

  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :sku, presence: true
  validates :type, presence: true
  validates :slug, presence: true, uniqueness: true

  def self.active
    where active: true
  end

  def self.promoted
    where promoted: true
  end

  def self.ordered
    order "name ASC"
  end

  def self.newest_first
    order "created_at DESC"
  end

  def meta_keywords
    topics.meta_keywords
  end

  def subscription?
    false
  end

  def image_url
  end

  def product_type_symbol
    type.underscore.to_sym
  end

  def to_param
    slug
  end

  def title
    "#{name}: a #{offering_type.humanize.downcase} by Jumpstart"
  end

  def offering_type
    type.underscore
  end

  def to_aside_partial
    "#{self.class.name.underscore.pluralize}/aside"
  end

end
