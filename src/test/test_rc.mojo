from testing import assert_true, assert_equal, assert_almost_equal

from micrograd import RC


fn test_rc_init_data() raises:
    var rc = RC(1.5)
    assert_almost_equal(rc.ptr[], 1.5, msg="RC data not initialized correctly")
    assert_equal(rc.ref_count[], 1, msg="RC ref_count not initialized correctly")
    _ = rc # Explicit lifetime https://docs.modular.com/mojo/manual/lifecycle/death#explicit-lifetimesa 


fn rc_tests() raises:
    test_rc_init_data()
