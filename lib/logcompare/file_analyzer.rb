module Logcompare

  require 'zlib'

	class FileAnalyzer

    attr_reader :count

    def FileAnalyzer.analyze( filename, option )
      f = FileAnalyzer.new( filename, option )
      f.parse( filename )
      f
    end


    def initialize( filename, option )
      @filename = filename
      @option = option
      @count = 0
      @tokens = 0
      @freq = Hash.new{ |h,k| h[k] = 0 }  # How many occurrences
      @first = Hash.new                    # Last line seen 
      @uniques = []
    end

    def parse( filename )
      begin
        print "Analyzing #{filename}... "
        STDOUT.flush
        start = Time.now

        f = File.open(filename,  encoding: 'iso-8859-1')
        f = Zlib::GzipReader.new(f) if filename.end_with?('.gz')
        f.each_line do |line|
          parse_line(line)
        end
        f.close

        finish = Time.now
        printf("%d lines, %d tokens, %d unique in %0.2f secs.\n", @count, @tokens, @freq.count, finish - start )
        # @freq.sort.each do |tok,f|
        #   puts "#{tok} #{@freq[tok]}"
        # end
      rescue StandardError => e
        puts e
        exit 1
      end
    end


    def find_uniques( sum_freqs )
      @uniques = []
      @freq.each do |tok,f|
        if sum_freqs[tok] == f
          @uniques << tok 
        end
      end
      @uniques
    end

    def report_uniques
      entries = []
      @uniques.each do |tok|
        entries << [@first[tok], tok ]
      end
      entries.sort!
      # We now have the uniques in line order
      s = "Only in #{@filename}"
      puts s
      puts "-" * s.length
      entries.each do |line,tok|
        printf( "%6d: %s (%d)\n", line, tok, @freq[tok] )
      end
      puts
    end


    def report_interesting
      # A line is interesting if it is the first line containing a unique token
      interesting = []
      @uniques.each do |tok|
        interesting << @first[tok]
      end
      interesting = interesting.sort.uniq.reverse # To allow efficient test

      s = "Interesting lines in #{@filename} (#{interesting.count})"
      puts s
      puts "-" * s.length
      unless interesting.empty?
        f = File.open(@filename,  encoding: 'iso-8859-1')
        f = Zlib::GzipReader.new(f) if @filename.end_with?('.gz')
        count = 0
        f.each_line do |line|
          count += 1
          if interesting.empty?
            break
          elsif count == interesting.last
            printf( "%6d:%s", count, line )
            interesting.pop
          end
        end
        f.close
      else
        puts " There was nothing of interest in this file."
      end
      puts
    end




    def name
      @filename
    end

    def tokens
      @freq.keys
    end

    def token_frequencies
      @freq
    end

    def token_freq( token )
      @freq[token]
    end

    def token_count
      @tokens
    end

    # Return line number, or nil if never seen in this file
    def first( token )
      @first[token]
    end

    def uniques
      @uniques
    end


private
    def parse_line(line)
      @count += 1
      line.scan(@option[:token]).each do |w|  
        next if unwanted(w)
        w.gsub!(@option[:same], '_' ) 
        @freq[w] += 1
        @first[w] = @count unless @first.has_key?(w)
        @tokens += 1
      end
    end

    def unwanted(tok)
      @option[:ignore].each do |r|
        return true if r.match(tok)
      end
      #print tok
      #print ' '
      return false
    end



	end


end