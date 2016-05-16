
module Logcompare

  require 'logcompare/file_analyzer'
  require 'optparse'

  class App
    def initialize
      @option = { ignore: [] }
      @option[:token] = /[[:alnum:]]+(?:[-.][[:alnum]]+)*/
      @option[:same] = /[0-9]/
      @files = []
      @analyses = []
    end

    def go(argv)
      begin
        parse_options( argv )
        print_info
        @files.each do |filename|
          @analyses  << FileAnalyzer.analyze( filename, @option )
        end
        CompareFiles.new(@option).compare( @analyses )
      rescue Interrupt
        "Ctrl-C pressed. Exit left pursued by a bear."
      end
    end

    def print_version
      puts "Mike's Logcompare V#{VERSION}"
    end

    def print_info
      print_version
      puts "Tokens: #{@option[:token]}"
      puts "Same: #{@option[:same]}"
      unless @option[:ignore].empty?
        @option[:ignore].each do |regexp|
          puts "Ignoring: #{regexp.to_s}"
        end
      end
    end


  private
    def parse_options( args )
      parser = OptionParser.new do |opt|
        opt.banner = "Usage: logcompare [options] file1 file2 file3 ..."

        opt.separator ""
        opt.separator "Specific options:"

        opt.on '--help', 'Print usage information and exit' do 
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

        opt.on '--ignorehex', 'ignore tokens consisting entirely or hex characters' do |opt|
          @option[:ignore] << /^[a-fA-F0-9]+$/
        end

        opt.on '--ignore0xhex', 'ignore tokens which look like 0x9898af3...' do |opt|
          @option[:ignore] << /^0[xX][a-fA-F0-9]+$/
        end

        opt.on '--ignorehex-', 'ignore tokens consisting entirely of hex characters and - ' do |opt|
          @option[:ignore] << /^[a-fA-F0-9\-]+$/
        end

        opt.on '--nodefaults', 'Do not ignore default patterns' do |opt|
          @option[:nodefault] = true
        end

        opt.on '--token REGEX', 'specify a regular expresssion for tokenizing input' do |opt|
          begin
            @option[:token] = Regexp.new(opt)
          rescue StandardError => e
            puts e.message
            exit 1
          end
        end

        opt.on '--same REGEX', 'treat all matches to REGEX as equivalent' do |opt|
          begin
            @option[:same] = Regexp.new(opt)
          rescue StandardError => e
            puts e.message
            exit 1
          end
        end

        opt.on '--uniques', 'show list of unique tokens in each file' do |opt|
          @option[:uniques] = true
        end

        opt.on '--version', 'Print version information and exit' do 
          print_version
          exit
        end



      end

      parser.parse!(args)

      unless @option[:nodefault] 
        # Ignore anything that looks like a number
        @option[:ignore] << Regexp.new("^\\d+$")
      end

      @files = args

      if @files.count < 2
        puts "You must specify 2 or more files on the command line"
        exit 1
      end

    end




  end



end

