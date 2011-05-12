Subcommander is a wrapper around Ruby's OptionParser class that allows you to have sub-commands like we see in Git and other tools. To get help for your tool, just type in the tool name with no sub-command (or the word "help" as a sub-command).  To get help for a sub-command type:

    your-tool help sub-command

More description coming... this is basically a placeholder for now.

### Simple Example:

    require 'subcommander'
    include Subcommander
    
    subcommander.version = '1.0.0'
    subcommander.desc = "SimpleTool is ephemeral and only here to demonstrate Subcommander."
    
    subcommand :run, "Runs the simple tool" do |sc|
      sc.opt :just_kidding, '-k', '--just-kidding', "Don't really run the simple tool"
      sc.exec {
	      # This is where the subcommand has its implementation
	      if sc[:just_kidding]
	        puts "Not really running"
	      else
	        puts "Running!"
	      end
      }
    end
    
    subcommander.go!

---------------------------

# subcommander #

Properties you can set:

__version__ - The version of the tool you're making.  It's printed at the bottom of help.

__desc__ - A description of the tool you're using.  It's printed at the beginning of help.


---------------------------
# subcommand #

Properties you can set:

__arity__ - This says how many arguemnts are expected to be passed to this sub-command, excluding options and their arguemnts.

__help__ - Help that shows up when the user asks for help about the sub-command

__usage__ - The typical usage pattern like "simple-tool [options] args"

__opt__ - These are exactly the same as OptionParser opt.on() argument lists except the first argument is a token.  When the option is invoked, it will put any option arguemnts that were passed into the subcommand keyed by that token.  So subcommand[:yoursymbol] is where you'll find it when you're looking for it in your exec block.

__exec__ - The implementation for your sub-command should be in a block that's passed to this method.

