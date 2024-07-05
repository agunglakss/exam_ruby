require 'digest'
require 'find'

# Function to count files with same content
def finding_content(directory)
  content_to_count = {}
  total_files = 0
  is_sorted = true 

  Find.find(directory) do |path|
    next if File.directory?(path)

    begin
      content = File.read(path)
    
      hash = Digest::SHA256.hexdigest(content)
      
      content_to_count[hash] ||= { content: content, count: 0 }
      content_to_count[hash][:count] += 1
      total_files = total_files + 1
    rescue => e
      puts "Error processing #{path}: #{e.message}"
    end
  end
  
  # sorting to get the bigger number
  while is_sorted 
    is_sorted = false

    (content_to_count.values.size - 1).times do |i|
      if content_to_count.values[i][:count] < content_to_count.values[i+1][:count]
        content_to_count.values[i][:content], content_to_count.values[i+1][:content] = content_to_count.values[i+1][:content], content_to_count.values[i][:content]
        content_to_count.values[i][:count], content_to_count.values[i+1][:count] = content_to_count.values[i+1][:count], content_to_count.values[i][:count]
        is_sorted = true 
      end
    end
     
  end

  puts "Total #{total_files} files has been scanning"
  puts "#{content_to_count.values[0][:content]}" + " " + "#{content_to_count.values[0][:count]}"

end

# Main script logic
if ARGV.empty?
  puts "Usage: ruby finding_content.rb <directory_path>"
  exit
end

# store path parameter into a variable 
directory_path = ARGV[0]

unless File.directory?(directory_path)
  puts "Error: #{directory_path} is not a valid directory."
  exit
end

# call the function
finding_content(directory_path)