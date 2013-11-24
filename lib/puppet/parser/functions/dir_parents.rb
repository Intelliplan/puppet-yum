module Puppet::Parser::Functions
  newfunction(:dir_parents, :type => :rvalue, :doc => <<-DOC) do |*args|

    Get the parents of a directory path.

    Examples:
      dir_parents('/a/b/c') = [ '/a', '/a/b' ]
      dir_parents('')       = []
      dir_parents('a')      = []

  DOC

    if args[0].is_a? Array
      args = args[0]
    end

    raise(Puppet::ParseError, "dir_parents/1: Wrong number of arguments " +
          "given (#{args.size} instead of 1.)") unless args.size == 1

    args[0].
      split('/').                      # get me all names
      reject { |s| s.empty? }[0...-1]. # keep only non-empty, off last item
      reduce(["", []]) { |acc, p|      # foldl
        last, all = acc
        curr = "#{last}/#{p}"
        [curr, (all << curr)] # return the current and the accumulator 
      }[1]                    # return the accumulator
  end
end
