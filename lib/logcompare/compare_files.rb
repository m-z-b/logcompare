module Logcompare


    class CompareFiles


      def initialize( option)
        @option = option
        @average = Hash.new
      end


      def compare( analyses )

        @sum = Hash.new{ |h,k| h[k] = 0 }

        analyses.each do |analysis|
          analysis.token_frequencies.each do |tok,f|
            @sum[tok] += f
          end
        end

        analyses.each do |analysis|
          analysis.find_uniques( @sum )
        end

        # If a token only occurs in one file, the frequency in that file will be the same as the sum
        analyses.each do |analysis|
          analysis.report_uniques if (@option[:uniques] && !analysis.uniques.empty?)
          analysis.report_interesting
        end

      end





      def report_unqiues( name, uniques )
        puts
        puts "Only in #{name}"
        puts "-" * 40
        uniques.sort.each do |line,token,frequency| 
          printf( "%8d: %s (%d)\n", line, token, frequency )
        end
        puts
      end


    end



end