require 'seeing_is_believing/has_exception'

class SeeingIsBelieving
  class Result
    include HasException

    Line = Class.new(Array) { include HasException }

    attr_reader :min_line_number, :max_line_number

    def initialize
      @min_line_number = @max_line_number = 1
      @results = Hash.new
    end

    def record_result(line_number, value)
      contains_line_number line_number
      results(line_number) << value.inspect
      value
    end

    def record_exception(line_number, exception)
      self.exception = exception
      contains_line_number line_number
      results(line_number).exception = exception
    end

    def [](line_number)
      results(line_number)
    end

    # probably not really useful, just exists to satisfy the tests, which specified too simple of an interface
    def to_a
      (min_line_number..max_line_number).map do |line_number|
        [line_number, [*self[line_number], *Array(self[line_number].exception)]]
      end
    end

    def contains_line_number(line_number)
      @min_line_number = line_number if line_number < @min_line_number
      @max_line_number = line_number if line_number > @max_line_number
    end

    private

    def results(line_number)
      @results[line_number] ||= Line.new
    end
  end
end
