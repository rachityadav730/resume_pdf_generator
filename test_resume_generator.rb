# test_resume_generator.rb

# require 'lib/resume_pdf_generator.rb'
require_relative "lib/resume_pdf_generator"
require 'json'

# Read data from JSON file
data = JSON.parse(File.read("resume_data.json"), symbolize_names: true)

# Generate the PDF
generator = ResumePdfGenerator::Generator.new(data)
File.open("resume_output.pdf", "wb") { |file| file.write(generator.generate_pdf) }

puts "PDF generated as 'resume_output.pdf'"
