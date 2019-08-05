module Enumerable
  def top(*args, &block)
    if block || !respond_to?(:scoping)
      limit, options, _ = args
      if limit.is_a?(Hash) && args.size == 1
        options = limit
        limit = nil
      end
      options ||= {}
      min = options[:min]

      # could be more performant
      arr = map(&block).group_by { |v| v }.map { |k, v| [k, v.size] }.sort_by { |k, v| [-v, k] }
      arr = arr[0...limit] if limit
      arr = arr.select { |k, v| v >= min } if min
      Hash[arr]
    else
      scoping { @klass.send(:top, *args, &block) }
    end
  end
end