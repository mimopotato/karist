class String
  # "_ -> x" = y
  # "_from x" = y
  def mutate(mutations)
    case self.split(" ")
    in ["_", "->", from]
      return mutations.dig_str(from, mutations)
    in ["_from", from]
      return mutations.dig_str(from, mutations)
    else
      return self
    end
  end
end