class Hash
  def mutate(mutations)
    _merge(mutations)

    sum_result = _sum(mutations)
    return sum_result[0] if sum_result[1]
    
    concat = _concat(mutations)
    if concat.is_a?(String)
      return concat
    end

    self.each {|a, z| self[a] = z.mutate(mutations)}
  end

  # { _sum: [x, y, z]} = x + (y + z)
  def _sum(mutations)
    if self.key?(:_sum)
      return [self[:_sum].map{|el| el.mutate(mutations)}.sum, true]
    end

    self
  end

  # { _merge: x, **} = {**, x}
  def _merge(mutations)
    if self.key?(:_merge)
      self.merge!(mutations.dig_str(self[:_merge], mutations))
      self.delete(:_merge)
    end
  
    self
  end

  # {_concat: {items: [a, b], sep: sep}} = a`sep`b
  def _concat(mutations)
    if self.key?(:_concat)
      case self[:_concat]
      in {items: items, sep: sep}
        return items.mutate(mutations).join(sep)
      end
    end
  end

  def dig_str(str, mutations)
    self.dig(*str.split(".").map{|k| k.to_sym}).mutate(mutations)
  end

  # monkey-patch from Rails code to implement
  # #deep_symbolize_keys.
  # https://github.com/rails/rails/blob/19eebf6d33dd15a0172e3ed2481bec57a89a2404/activesupport/lib/active_support/core_ext/hash/keys.rb#L65
  def deep_symbolize_keys
    deep_transform_keys { |key| key.to_sym rescue key }
  end

  def deep_transform_keys(&block)
    _deep_transform_keys_in_object(self, &block)
  end

  def _deep_transform_keys_in_object(object, &block)
    case object
    when Hash
      object.each_with_object(self.class.new) do |(key, value), result|
        result[yield(key)] = _deep_transform_keys_in_object(value, &block)
      end
    when Array
      object.map { |e| _deep_transform_keys_in_object(e, &block) }
    else
      object
    end
  end

end