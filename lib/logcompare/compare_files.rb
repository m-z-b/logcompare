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
        puts "* Finished first pass"

        analyses.each do |analysis|
          analysis.find_uniques( @sum )
        end
        puts

        # If a token only occurs in one file, the frequency in that file will be the same as the sum
        analyses.each do |analysis|
          analysis.report_uniques if (@option[:uniques] && !analysis.uniques.empty?)
          analysis.report_interesting
        end

      end


    end



end