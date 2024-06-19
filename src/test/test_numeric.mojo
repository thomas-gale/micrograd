from testing import assert_true, assert_equal, assert_almost_equal

from micrograd.numeric import Numeric
from micrograd.numeric_float import NumericFloat32


fn test_numeric_from_scalar() raises:
    var scalar: Float32 = 2

    var numeric = NumericFloat32.from_scalar(scalar)
    assert_almost_equal(
        numeric.data, 2, msg="Numeric data not initialized correctly"
    )


fn all_test_numeric() raises:
    test_numeric_from_scalar()
