
require 'optparse'

module Subcommander
      
  class Subcommander
    attr_accessor :desc,
                  :args,
                  :version
    
    def initialize args
      @commands = {}
      @descriptions = {}
      @file_order = []
      unless args.empty?
        @args = args.clone()
        @sub_cmd = @args.shift()
      else
        @args = []
      end
      @desc = "This command needs a description"
    end
        
    def subcommand cmd_name, desc, &block
      name = cmd_name.to_s
      sub_cmd = Subcommand.new(@args.clone(), cmd_name, desc, &block)
      @commands[name] = sub_cmd
      @file_order << name
    end
    
    def go!
      if @sub_cmd && @sub_cmd == "help"
        print_help()
      end
      sub_cmd = @commands[@sub_cmd]
      unless sub_cmd # no subcommand
        print_usage()
      end
      sub_cmd.go!
    end
    
    def print_usage
      desc = @desc
      if @desc.kind_of?(Proc)
        desc = @desc.call().rstrip
      end
      puts "\n#{desc}\n\n"
      puts "  Subcommands:"
      @file_order.each do |cmd|
        puts "    #{slop(cmd)}  #{@commands[cmd].desc}" 
      end
      puts
      puts "v " + @version if @version
      exit
    end
    
    def print_help
      if @args.empty?
        print_usage
      else
        sub_cmd = @commands[@args[0]]
        if sub_cmd
          sub_cmd.print_help()
        end
        exit
      end
    end
    
    private
    def slop cmd_name
      max_len = @file_order.max { |a,b| a.length <=> b.length }.length
      cmd_name + ' ' * (max_len - cmd_name.length)
    end
  end
    
  def subcommander
    unless defined?(@@subcommander)
      @@subcommander = Subcommander.new(ARGV)
    end
    @@subcommander
  end
  
  def subcommand name, desc, &block
    @@subcommander.subcommand(name, desc, &block)
  end
  
  class Subcommand
    attr_accessor :arity,
                  :name,
                  :desc,
                  :help,
                  :usage,
                  :block
    
    def initialize args, cmd_name, desc, &block
      @args = args
      @name = cmd_name
      @desc = desc
      @opts = OptionParser.new
      @opts.banner = ""
      @arity = -1 # Don't care how many args
      @props = {}
      @sub_cmdr = nil
      block.call(self)
    end
    
    def [] key
      @props[key]
    end
    
    def banner= str
      @opts.banner = "  Usage: #{str}"
    end
        
    def opt *orig_args
      args = orig_args.clone()
      prop = args.shift()
      @opts.on *args do |arg|
        @props[prop] = arg
      end
    end
    
    def exec &block
      @block = block
    end
    
    def go!
      if @sub_cmdr
        @sub_cmdr.go!
        return
      end
      parse_args()
      num_remaining = @props[:remaining_args].length
      if @arity > -1 && num_remaining != @arity
        puts "We expected #{@arity} arguments and #{num_remaining} were provided."
        exit
      end
      @block.call if @block
    end
    
    def subcommand name, desc, &block
      unless @sub_cmdr
        @sub_cmdr = Subcommander.new(@args.clone())
        @sub_cmdr.desc = lambda { @help ? @help : @desc }
      end
      @sub_cmdr.subcommand(name, desc, &block)
    end
    
    def print_help
      if @help
        puts
        puts @help
      end
      if (@usage)
        @opts.banner = "  Usage: #{@usage}"
        puts
      end
      puts @opts.to_s
      puts
    end
    
    private
    def parse_args
      @props[:remaining_args] = @opts.parse(@args)
    end
  end
end

# vim: set expandtab tabstop=2 shiftwidth=2 autoindent smartindent:
