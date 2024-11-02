# frozen_string_literal: true
require_relative "resume_pdf_generator/version"
require "prawn"

module ResumePdfGenerator
  class Generator
    def initialize(data)
      @data = data
    end

    def generate_pdf
      icon_path = File.expand_path("icons", __dir__)
      puts "Phone icon exists: #{File.exist?("#{icon_path}/phone.png")}"
      puts "Email icon exists: #{File.exist?("#{icon_path}/email.png")}"
      puts "GitHub icon exists: #{File.exist?("#{icon_path}/github.png")}"
      Prawn::Document.new do |pdf|
        # Header Section
        pdf.text @data[:name], size: 24, style: :bold, align: :center
        pdf.move_down 5
        start_x = pdf.bounds.left + 50
        icon_width = 10
        text_gap = 5  # Gap between icon and text
        section_gap = 120  # Gap between each contact section
    
        # Phone Icon and Text
        pdf.image "#{icon_path}/phone.png", at: [start_x, pdf.cursor], width: icon_width
        pdf.draw_text @data[:phone] || "N/A", at: [start_x + icon_width + text_gap, pdf.cursor - 10]
    
        # Email Icon and Text (Positioned further to the right)
        pdf.image "#{icon_path}/email.png", at: [start_x + section_gap, pdf.cursor], width: icon_width
        pdf.formatted_text_box(
          [{ text: @data[:email] || "N/A", link: "mailto:#{@data[:email]}", color: "0000FF", styles: [:underline] }],
          at: [start_x + section_gap + icon_width + text_gap, pdf.cursor - 0]
        )
        # pdf.draw_text @data[:email] || "N/A", at: [start_x + section_gap + icon_width + text_gap, pdf.cursor - 10]
    
        # GitHub Icon and Text (Positioned further to the right)
        pdf.image "#{icon_path}/github.png", at: [start_x + (2 * section_gap) + 50, pdf.cursor], width: icon_width
        pdf.formatted_text_box(
          [{ text: @data[:github] || "N/A", link: "mailto:#{@data[:github]}", color: "0000FF", styles: [:underline] }],
          at: [start_x + (2 * section_gap) +50 + icon_width + text_gap, pdf.cursor - 0]
        )
        # pdf.draw_text @data[:github] || "N/A", at: [start_x + (2 * section_gap) +50 + icon_width + text_gap, pdf.cursor - 10]
    
        pdf.move_down 20
        # Education Section
        pdf.text "Education", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 12

        line_y = pdf.cursor

        # Draw each segment with specific spacing
        pdf.draw_text @data[:education], at: [start_x - 50, line_y], size: 12
        # pdf.draw_text institution, at: [start_x - 50  + 180, line_y], size: 12  # Adjust the x-coordinate as needed
        pdf.draw_text @data[:graduation_date], at: [start_x - 20 + 460, line_y], size: 12
        pdf.move_down 15

        # Work Experience Section
        pdf.text "Work Experience", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 12
        @data[:work_experience].each do |job|
          pdf.draw_text "#{job[:title]} - #{job[:company]}", at: [start_x - 50, pdf.cursor],style: :bold, size: 12
          pdf.draw_text job[:date], at: [start_x + 380, pdf.cursor], size: 12
          # pdf.text job[:title], size: 14, style: :bold
          # pdf.text "#{job[:company]} - #{job[:date]}"
          pdf.move_down 10
          job[:description].each do |item|
            pdf.text_box "•", at: [start_x - 20, pdf.cursor],indent_paragraphs: 20
            pdf.text_box "#{item}", at: [start_x , pdf.cursor],indent_paragraphs: 20
            pdf.move_down 30
          end
          pdf.move_down 10
        end

        # Projects Section
        pdf.text "Projects", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 5

        @data[:projects].each do |project|
          pdf.formatted_text [
            { text: "#{project[:title]}", link: project[:url], styles: [:bold], color: "0000FF", size: 12 },
            { text: " - #{project[:description]}", size: 12 }
          ]
          pdf.move_down 5 # Adds spacing between projects
        end

        # Technical Skills Section
        pdf.text "Technical Skills", size: 18, style: :bold
        pdf.stroke_horizontal_rule
        pdf.move_down 5
        pdf.text @data[:skills], size: 12
        # Footer Section
        # pdf.text "Generated with Resume PDF Generator", size: 10, align: :center
      end.render
    end
  end
end
