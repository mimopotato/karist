class String
  # "_ -> x" = y
  # "_from x" = y
  def mutate(mutations)
    case self.split("$")
    in ["", from]
      return mutations.dig_str(from, mutations)
    else
    end

    return self
  end
end