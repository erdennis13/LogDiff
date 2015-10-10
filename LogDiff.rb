@warnings = Hash.new()
@build_done = false

def process_string str
	if match = /^.*(\]\s*){1}(.+)/.match(str)
		str = match.captures[1]
	end

	if match = /^(?:.+?\/){6}(.+)/.match(str)
		str = match.captures[0]
	end

	if match = /.*(warning :\s*){1}/.match(str)
		return match.captures[0]
	else
		return str
	end
end


File.readlines(ARGV[0]).each do |line|
	comp = line.to_s
	comp = process_string(comp)

	if comp.include? "Build succeeded."
		@build_done = true
	elsif comp.include? "Warning(s)"
		@build_done = false
	end

	if @build_done
		if comp.downcase.include? "warning"
			unless @warnings.has_key? comp
				@warnings[comp] = 1
			else
				@warnings[comp] += 1
			end
		end
	end
end

@build_done = false

File.readlines(ARGV[1]).each do |line|
	comp = line.to_s
	comp = process_string(comp)

	if comp.include? "Build succeeded."
		@build_done = true
	elsif comp.include? "Warning(s)"
		@build_done = false
	end

	if @build_done
		if comp.downcase.include? "warning"
			unless @warnings.has_key? comp
				@warnings[comp] = -1
			else
				@warnings[comp] -= 1
			end
		end
	end
end

@count = 0
@warnings.each do |key, value|
	unless value == 0
		if value < 0
			file = "Second Log"
			other = "First Log"
		else
			file = "First Log"
			other = "Second Log"
		end
		puts "#{file} contains: #{key}"
		puts "#{other} does not"
		puts
		@count += 1
	end
end
puts "#{@count} warning differences"

