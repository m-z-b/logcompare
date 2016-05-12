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
    end

    def parse( filename )
      begin
        print "Analyzing #{filename}... "
        STDOUT.flush
        start = Time.now

        f = File.open(filename,  encoding: 'iso-8859-1')
        if filename.end_with?( '.gz')
          Zlib::GzipReader.new(f).each_line do |line|
            parse_line(line)
          end
        else
          f.each_line do |line|
            parse_line(line)
          end
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

	end


end