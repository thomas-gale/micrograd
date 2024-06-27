from testing import assert_true, assert_equal, assert_almost_equal

from micrograd.numeric import Numeric
from micrograd.numeric_float import NumericFloat32


fn test_gt() raises:
    var a = NumericFloat32(-2.0)
    var b = NumericFloat32(0.0)

    assert_true(a < b, msg="NumericFloat32 less than operator not working")
    assert_true(b > a, msg="NumericFloat32 greater than operator not working")


fn test_numeric_from_float32() raises:
    var scalar: Float32 = 2

    var numeric = NumericFloat32.from_float32(scalar)
    assert_almost_equal(
        numeric.data, 2, msg="Numeric data not initialized correctly"
    )


fn all_test_numeric() raises:
    test_gt()
    test_numeric_from_float32()
