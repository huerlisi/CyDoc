class ItemPrice < ActiveRecord::Base
  attr_accessible :code, :valid_from, :valid_to, :amount

  # Tagging
  acts_as_taggable
  attr_accessible :tag_list

  # Validity
  scope :valid_at, lambda{ |value|
    where("(valid_from IS NULL OR valid_from <= :date) AND (valid_to IS NULL OR valid_to > :date)", :date => value)
  }
  scope :valid, lambda{ valid_at(Date.today) }

  def self.current(code, date = nil)
    date ||= Date.today
    valid_at(date).find_by_code(code)
  end

  # Condition definitions
  def self.condition(name, *options)
    define_method(name) do
      return unless tag = tag_list.select{ |t| t.starts_with?("#{name}:") }.first

      tag.split(':')[1]
    end

    define_method("#{name}=") do |value|
      new_tags = tag_list.reject{ |t| t.starts_with?("#{name}:") }

      new_tags << "#{name}:#{value}" if value.present?

      self.tag_list = new_tags
    end

    attr_accessible name
  end
end
