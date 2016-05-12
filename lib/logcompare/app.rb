
module Logcompare


  require 'optparse'

  class App
    def initialize
      @option = { ignore: [] }
      @files = []
      @analyses = []
    end

    def go(argv)
      begin
        parse_options( argv )
        @files.each do |filename|
          @analyses  << FileAnalyzer.analyze( filename, @option )
        end
      rescue Interrupt
        "Ctrl-C pressed. Exit left pursued by a bear."
      end
    end



  private
    def parse_options( args )
      parser = OptionParser.new do |opt|
        opt.banner = "Usage: logcompare [options] file1 file2 file3 ..."

        opt.separator ""
        opt.separator "Specific options:"

        opt.on '--help', 'Print usage information' do 
          puts opt
          exit
        end

        opt.on '--ignore REGEX', 'ignore parts of lines which math the given regular expression' do |opt|
          begin
            @option[:ignore] << Regexp.new(opt)
          rescue StandardError => e
            puts e.message
            exit 1
          end
        end

        opt.on '--nodefaults', 'Do not ignore default patterns' do |opt|
          @option[:noignore] = true
        end


      end

      unless @option[:noignore] 
        # Ignore anything that looks like a number
        @option[:ignore] << "\d+"
      end

      # Add in more ignore strings according to optiosn


      parser.parse!(args)
      @files = args

      if @files.count < 2
        puts "You must specify 2 or more files on the command line"
        exit 1
      end

    end




  end



end

