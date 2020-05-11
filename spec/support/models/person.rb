# frozen_string_literal: true

class Person
  attr_accessor :age

  def brothers
    @brothers ||= 0
  end

  private

  def init_age
    @age ||= 1
  end
end
