class Array
  # [a, b, c] = [a.mutate, b.mutate, c.mutate]
  def mutate(mutations)
    self.map {|z| z.mutate(mutations)}
  end
end