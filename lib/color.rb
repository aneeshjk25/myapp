class Color
	def initialize
		
	end
	def self.colorize(text, color_code)
	  "#{color_code}#{text}[0m"
	end

	def self.red(text)
		colorize(text, "[31m")
	end
	
	def self.green(text)
		colorize(text, "[32m")
	end	

	def self.yellow(text)
		colorize(text, "[33m")
	end	
	
end