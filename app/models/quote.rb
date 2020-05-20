class Quote < ApplicationRecord
  belongs_to :stock

  validates :time_stamp, presence: true, uniqueness: { scope: :stock }
end
