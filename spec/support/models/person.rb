# frozen_string_literal: true

class Person
  attr_accessor :age, :height

  def brothers
    @brothers ||= 0
  end

  private

  def init_height
    @height = 178
  end

  def init_age
    @age ||= 1
  end
end
