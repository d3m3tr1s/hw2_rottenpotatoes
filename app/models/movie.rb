class Movie < ActiveRecord::Base
	def self.ratings
		select(:rating).collect{|m| m.rating}.uniq	
	end
end
