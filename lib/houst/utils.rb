module Houst
  module Utils
    def format(hash)
      hash.map { |k, v| "#{k}\t\t#{v}\n" }.join
    end
  end
end
