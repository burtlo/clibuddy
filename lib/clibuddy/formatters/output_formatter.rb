require 'pastel'

module CLIBuddy
  module Formatters
    class OutputFormatter
      NEWLINE_ESCAPE = /\.n$/

      def self.format(msg, mapped_args)
        Array(msg).collect do |line|
          format_line(line, mapped_args)
        end.join("\n")
      end

      def self.format_line(line, mapped_args)
        pastel = Pastel.new
        mapped_args.each do |name, provided|
          next if provided.nil?
          line.gsub!(name, pastel.green(provided))
        end
        line.gsub!(NEWLINE_ESCAPE, "\n")
        # This works for simple inline coloring (and later formatting)
        # but wont' work for nested format tags.
        while line =~ /(.*)\.(red|green|blue|yellow|magenta|cyan|white)(.*)(\.x|$)(.*)$/

          # $1 - text prefix
          # $2 - color identifier
          # $3 - text to be colored
          # $4 - end marker or nil
          # $5 - remaining uncolored text or nil
          colored_text = pastel.send($2.to_sym, $3)
          line = "#{$1}#{colored_text}#{$5}"
        end
        line
      end
    end
  end
end
