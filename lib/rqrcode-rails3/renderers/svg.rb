module RQRCode
  module Renderers
    class SVG
      class << self
        # Render the SVG from the qrcode string provided from the RQRCode gem
        #   Options:
        #   offset - Padding around the QR Code (e.g. 10)
        #   unit   - How many pixels per module (Default: 11)
        #   fill   - Background color (e.g "ffffff" or :white)
        #   color  - Foreground color for the code (e.g. "000000" or :black)

        def render(qrcode, options={})
          offset  = options[:offset].to_i || 0
          color   = options[:color]       || "000"
          unit    = options[:unit]        || 11
          offset_left = options[:offset_left].to_i || 0
          offset_top = options[:offset_top].to_i || 0
          text_dimension = 0
          #text_dimension = 60 if options[:text] 
          # height and width dependent on offset and QR complexity
          dimension = (qrcode.module_count*unit) + offset_left + offset_top
          width = dimension  + text_dimension
          height = dimension + text_dimension
          xml_tag   = %{<?xml version="1.0" standalone="yes"?>}
          open_tag  = %{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events" width="#{width}" height="#{height}">}
          close_tag = "</svg>"

          result = []
          qrcode.modules.each_index do |c|
            tmp = []
            qrcode.modules.each_index do |r|
              y = c*unit + offset_top
              x = r*unit + offset_left

              next unless qrcode.is_dark(c, r)
              tmp << %{<rect width="#{unit}" height="#{unit}" x="#{x}" y="#{y}" style="fill:##{color}"/>}
            end 
            result << tmp.join
          end

          if options[:text]
            x = offset_left
            y = qrcode.module_count*unit + offset_top + 20
            # result.unshift %{<text x="#{x}" y="#{y}" font-family="Helvetica, Arial, sans-serif" font-size="15" fill="##{color}">一卡通编号：</text>}
            result.unshift %{<text x="#{x}" y="#{y}" font-family="Helvetica, Arial, sans-serif" font-size="18" fill="##{color}">#{options[:text]}</text>}
          end
          
          if options[:fill]
            result.unshift %{<rect width="#{dimension}" height="#{dimension}" x="0" y="0" style="fill:##{options[:fill]}"/>}
          end
          
          svg = [xml_tag, open_tag, result, close_tag].flatten.join("\n")
        end
      end
    end
  end
end
