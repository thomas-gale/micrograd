from testing import assert_true, assert_equal, assert_almost_equal

from micrograd import GradFloat32


fn test_gt_lt() raises:
    var a = GradFloat32(-2.0)
    var b = GradFloat32(0.0)

    assert_true(a < b, msg="GradFloat32 less than operator not working")
    assert_true(b > a, msg="GradFloat32 greater than operator not working")

fn test_eq() raises:
    var a = GradFloat32(-2.0)
    var b = GradFloat32(-2.0)

    assert_true(a == b, msg="GradFloat32 equal operator not working")

fn test_ne() raises:
    var a = GradFloat32(-2.0)
    var b = GradFloat32(0.0)

    assert_true(a != b, msg="GradFloat32 not equal operator not working")

fn test_grad_float32_from_float32() raises:
    var float: Float32 = 2

    var gradable = GradFloat32.from_float32(float)
    assert_almost_equal(
        gradable.data, 2, msg="GradFloat32 data not initialized correctly"
    )


fn all_test_gradable() raises:
    test_gt_lt()
    test_eq()
    test_ne()
    test_grad_float32_from_float32()
