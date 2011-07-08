require "test/unit"
require "drange"

class TestDRange < Test::Unit::TestCase
    def test_sanity()
        true
    end
    
    def test_map2()
        a = [1, 2, 3, 4, 5]
        b = [6, 7, 8, 9, 10]
        assert_equal(map2(a, b){|x, y| x + y}, [7, 9, 11, 13, 15])
        
        enum = map2(a, b)
        assert_equal(enum.next, [1, 6])
        assert_equal(enum.next, [2, 7])
        assert_equal(enum.next, [3, 8])
        assert_equal(enum.next, [4, 9])
        assert_equal(enum.next, [5, 10])
    end

    def test_product()
        dr1 = (1..3)*(4..6)
        assert_equal([(1..3), (4..6)], dr1.axes)
        assert_equal([(1..3), (4..6), (7..9)], (dr1*(7..9)).axes)
        assert_equal([(7..9), (1..3), (4..6)], ((7..9)*dr1).axes)
    end
    
    def test_to_s()
        assert_equal("[1..3, 4..6]", ((1..3)*(4..6)).to_s)
    end
    
    def test_eq()
        assert((1..3)*(4..6) == (1..3)*(4..6))
        assert(((1..3)*(4..6)).eql?((1..3)*(4..6)))
        assert((1..3)*(4..6) != (1..3)*(4..7))
    end
    
    def test_include()
        dr = (1..3)*(4..6)
        assert(dr === [1, 5])
        assert(dr.include?([1, 5]))
        assert(dr.member?([1, 5]))
    end
    
    def test_begin_end_first_last()
        dr = (1..3)*(4..6)
        assert_equal([1, 4], dr.begin)
        assert_equal([1, 4], dr.first)
        assert_equal([3, 6], dr.end)
        assert_equal([3, 6], dr.last)
    end
    
    # cover?
    # eql?, exclude_end?,
    
    def test_minmax()
        dr = (1..3)*(4..6)*(7..9)
        assert_equal([1, 4, 7], dr.min)
        assert_equal([3, 6, 9], dr.max)
    end
    
    # each, step
end # class TestDRange

