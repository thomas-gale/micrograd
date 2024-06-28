from testing import assert_true, assert_equal, assert_almost_equal

from micrograd import GradFloat32


fn test_gt() raises:
    var a = GradFloat32(-2.0)
    var b = GradFloat32(0.0)

    assert_true(a < b, msg="GradFloat32 less than operator not working")
    assert_true(b > a, msg="GradFloat32 greater than operator not working")


fn test_grad_float32_from_float32() raises:
    var float: Float32 = 2

    var gradable = GradFloat32.from_float32(float)
    assert_almost_equal(
        gradable.data, 2, msg="GradFloat32 data not initialized correctly"
    )


fn all_test_gradable() raises:
    test_gt()
    test_grad_float32_from_float32()
