require 'optparse'

module Houst
  class CLI

    def initialize(core, out)
      @core = core
      @out = out
    end

    def run
      action, *params = ARGV
      output = @core.send(action, *params)
      @out.write output
    end

  end
end
