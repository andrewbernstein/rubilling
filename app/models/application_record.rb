class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def to_s
    "<#{self.class_name} ID: #{self.id}>"
  end
end
