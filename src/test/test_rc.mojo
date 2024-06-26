from memory.unsafe_pointer import UnsafePointer, initialize_pointee_copy
from testing import assert_true, assert_equal, assert_almost_equal

from micrograd import RC


fn test_rc_init_data() raises:
    var rc = RC(1.5)
    assert_almost_equal(
        rc.get_data_copy(), 1.5, msg="RC data not initialized correctly"
    )
    assert_equal(
        rc.get_ref_count(), 1, msg="RC ref_count not initialized correctly"
    )


fn test_rc_init_ptr() raises:
    var ptr = UnsafePointer[Int].alloc(1)
    initialize_pointee_copy(ptr, 42)
    var rc = RC(ptr)
    assert_equal(
        rc.get_data_copy(), 42, msg="RC data not initialized correctly"
    )
    assert_equal(
        rc.get_ref_count(), 1, msg="RC ref_count not initialized correctly"
    )


fn test_rc_multiple_refs() raises:
    var rc = RC(42.42)
    var rc2 = rc  # Point at the same data

    assert_equal(rc.ptr, rc2.ptr, msg="RC data ptrs not the same")
    assert_almost_equal(
        rc.get_data_copy(), 42.42, msg="RC data not initialized correctly"
    )
    assert_equal(
        rc.get_ref_count(), 2, msg="RC ref_count not initialized correctly"
    )
    # Mojo will have cleaned up rc here.
    assert_equal(
        rc2.get_ref_count(), 1, msg="RC ref_count not initialized correctly"
    )


fn move_into_test(owned rc: RC[Float32]) raises:
    assert_almost_equal(
        rc.get_data_copy(), 42.42, msg="RC data not initialized correctly"
    )
    assert_equal(
        rc.get_ref_count(), 1, msg="RC ref_count not initialized correctly"
    )


fn test_rc_move() raises:
    var rc = RC[Float32](42.42)
    move_into_test(rc^)


fn all_test_rc() raises:
    test_rc_init_data()
    test_rc_init_ptr()
    test_rc_multiple_refs()
    test_rc_move()
