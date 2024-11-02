# lib/resume_pdf_generator/generator.rb

require "prawn"

module ResumePdfGenerator
  class Generator
    def initialize(data)
      @data = data
    end

    def generate_pdf
      Prawn::Document.new do |pdf|
        # Header Section
        pdf.text @data[:name], size: 24, style: :bold
        pdf.move_down 5
        pdf.text "Phone: #{@data[:phone]}"
        pdf.text "Email: #{@data[:email]}"
        pdf.move_down 20

        # Education Section
        pdf.text "Education", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 5
        pdf.text @data[:education], size: 12
        pdf.move_down 15

        # Work Experience Section
        pdf.text "Work Experience", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 5
        @data[:work_experience].each do |job|
          pdf.text job[:title], size: 14, style: :bold
          pdf.text "#{job[:company]} - #{job[:date]}"
          pdf.move_down 5
          pdf.text job[:description], size: 12, indent_paragraphs: 10
          pdf.move_down 10
        end

        # Projects Section
        pdf.text "Projects", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 5
        @data[:projects].each do |project|
          pdf.text "#{project[:title]} - #{project[:description]}", size: 12
          pdf.move_down 5
        end

        # Technical Skills Section
        pdf.text "Technical Skills", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 5
        pdf.text @data[:skills], size: 12

        # Footer Section
        pdf.move_down 20
        pdf.text "Generated with Resume PDF Generator", size: 10, align: :center
      end.render
    end
  end
end
