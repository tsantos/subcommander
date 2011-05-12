#!/usr/bin/env ruby

require 'subcommander'
include Subcommander

subcommander.version = '1.0.0'
subcommander.desc = "  cleaver is for launching and maintaining clusters within AWS\n" +
                    "  It allows for creation of stacks and deletions of them."

subcommand :launch, "For launching a cluster given a cluster or machine type and a cluster_name" do |sc|
  sc.help = "Lots of blah blah blah and stuff."
  sc.usage = "test launch [options] cluster-name"
  sc.opt :ctype, '-c', '--cluster-type CLUSTER-TYPE', "The cluster_type to launch"
  sc.opt :mtype, '-m', '--machine-type MACHINE-TYPE', "The machine_type to launch"
  sc.arity = 1
  sc.exec {
    system "nyfe kiss my_ass #{sc[:ctype]}"
    puts "\nLaunched! #{sc[:ctype]}"
    puts
  }
end

subcommand :foo, "This is for more testing" do |sc|
  sc.exec {
    puts "\nFoo'd"
    puts
  }
end

subcommander.go!
