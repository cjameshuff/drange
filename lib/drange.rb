
# Taken from Vector class
# TODO: make more general
class Array
    # Like map, but maps pairs of entries from two array-like objects to a single array of results.
    # FIXME: This is not an operation on a single array, so it makes les sense for it to be
    # implemented as an instance method. This also limits it to operation with actual arrays,
    # when implementing it as a standalone function would allow it to work with any array-like
    # objects.
    def map2(rhs) # :yield: e1, e2
        if(size != rhs.size)
            raise "Dimensions don't match" 
        end
        if(block_given?)
            Array.new(size) do |i|
                yield(self[i], rhs[i])
            end
        else
            return to_enum(:map2, rhs)
        end
    end # def map2()
end # class Array

def map2(lhs, rhs) # :yield: e1, e2
    if(lhs.size != rhs.size)
        raise "Dimensions don't match" 
    end
    if(block_given?)
        Array.new(lhs.size) do |i|
            yield(lhs[i], rhs[i])
        end
    else
        return lhs.to_enum(:map2, rhs)
    end
end # def map2()


class Range
    def *(rhs)
        case rhs
        when Range
            DRange.new([self, rhs])
        when DRange
            DRange.new([self] + rhs.axes)
        else
            raise "Type mismatch"
        end
    end
end # class DRange


class DRange
    attr_reader :axes
    
    def initialize(axes)
        @axes = axes
    end
    
    # Get new DRange with subset of dimensions
    def dims(d)
        DRange.new(d.map{|i| @axes[i]})
    end
    
    def *(rhs)
        # FIXME: need to dup ranges?
        case rhs
        when Range
            DRange.new(@axes + [rhs])
        when DRange
            DRange.new(@axes + rhs.axes)
        else
            raise "Type mismatch"
        end
    end
    
    def to_s()
        @axes.to_s
    end
    
    def ==(rhs)
        @axes == rhs.axes
    end
    
    # construct as exclusive, mix inclusive and exclusive
    # ===: is element of
    
    def ===(pt)
        map2(@axes, pt){|a, b| a === b}.include(false) == false
    end
    
    def begin()
        @axes.map{|a| a.begin}
    end
    
    def end()
        @axes.map{|a| a.end}
    end
    
    # cover?: true if object (array of coordinates) is in range
    
    # TODO: enumerator
    def each()
        ctr_init = first
        ctr_stop = last
        ctr = first
        ndims = @axes.length
        while(ctr[0] <= ctr_stop[0])
            yield(ctr)
            dimctr = ndims-1
            while((dimctr > 0) && ((ctr[dimctr] + 1) > ctr_stop[dimctr]))
                ctr[dimctr] = ctr_init[dimctr]
                dimctr -= 1
            end
            ctr[dimctr] += 1
        end
    end
    
    # eql?
    # exclude_end?
    
    def first()
        @axes.map{|a| a.first}
    end
    
    def last()
        @axes.map{|a| a.last}
    end
    
    def hash()
        @axes.hash
    end
    
    # member?
    # include?
    
    def inspect()
        @axes.map{|a| a.inspect}
    end
    
    def min()
        @axes.map{|a| a.min}
    end
    
    def max()
        @axes.map{|a| a.max}
    end
    
    # TODO: enumerator
    def step(steps = nil)
        if(steps == nil) # default to 1, same as each
            steps = Array.new(NUM_DIMS, 1)
        end
        
        ctr_init = first
        ctr_stop = last
        ctr = first
        ndims = @axes.length
        while(ctr[0] <= ctr_stop[0])
            yield(ctr)
            dimctr = ndims-1
            while((dimctr > 0) && ((ctr[dimctr] + 1) > ctr_stop[dimctr]))
                ctr[dimctr] = ctr_init[dimctr]
                dimctr -= 1
            end
            ctr[dimctr] += steps[dimctr]
        end
    end
end # class DRange
