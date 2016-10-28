class Content < ApplicationRecord
  belongs_to :post, touch: true, optional: true
end
