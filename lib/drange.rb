
class Range
    def *(rhs)
        case rhs
            when Range
                DRange.new([self, rhs])
            when DRange
                rhs*self
        end
    end
end # class DRange

# Taken from Vector class
# TODO: make more general
class Array
    def map2(v) # :yield: e1, e2
        if(size != v.size)
            raise "Dimensions don't match" 
        end
        if(block_given?)
            Array.new(size) do |i|
                yield(self[i], v[i])
            end
        else
            return to_enum(:collect2, v)
        end
    end # def collect2()
end # class Array

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
                @axes.push(rhs)
            when DRange
                @axes = @axes + rhs.axes
        end
        self
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
        @axes.map2(pt){|a, b| a === b}.include(false) == false
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
