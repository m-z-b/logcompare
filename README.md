# Logcompare

Command line gem to compare a set of log files which are presumed to cover similar periods and look for anomalies

## Installation

Currently the gem is not on [rubygems](http://rubygems.org/)


If you have the [specific_install](https://rubygems.org/gems/specific_install/versions/0.3.1) gem installed, you can install it directly from a git repository:

    $ gem specific_install -l https://path-to-git-repo


## Usage

    
    $ logcompare --help
    $ logcompare logfile1 logfile2 logfile3 ...

Most of the logfiles should represent "normal" operations. The log files will be analyzed and any "interesting" lines which differ significantly from other log files will be printed out. 

Compressed log files (with names ending in '.gz') do not need to be decompressed prior to analysis.

## Interestingness

Interestingness is determined by analysis of the lexical tokens in the file. What constitutes a token, how it should be normalized, and what tokens should be ignored are controlled by additional options to the program. 

## Development

It's a Ruby gem with no special requirements. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m-z-b/logcompare.

