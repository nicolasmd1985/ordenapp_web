class Status < ApplicationRecord
	has_many :orders
	has_many :tools
	has_many :things
	has_many :users
	has_many :subsidiaries
	has_many :corporations
	has_many :substatuses
end
