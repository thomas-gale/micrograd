from python import Python
from testing import assert_true, assert_equal, assert_almost_equal
from time import now

from micrograd import Value, NumericFloat32


fn test_add_mul() raises:
    # Micograd Mojo
    var m_start = now()
    var a = Value(NumericFloat32(2.0))
    var b = Value(NumericFloat32(-3.0))
    var c = Value(NumericFloat32(10.0))
    var d = a * b + c
    d.backward()
    print("Micograd time:", now() - m_start, "ns")
    # print(d)

    # Analytical check
    assert_equal(a.grad.get_data_copy(), NumericFloat32(-3.0))
    assert_equal(b.grad.get_data_copy(), NumericFloat32(2.0))
    assert_equal(c.grad.get_data_copy(), NumericFloat32(1.0))

    # Pytorch check
    var torch = Python.import_module("torch")
    var t_start = now()
    var ta: PythonObject = torch.Tensor([2]).double()
    ta.requires_grad = True
    var tb: PythonObject = torch.Tensor([-3]).double()
    var tc: PythonObject = torch.Tensor([10]).double()
    var td: PythonObject = ta * tb + tc
    td.backward()
    print("Pytorch time:", now() - t_start, "ns")
    assert_equal(
        d.data.get_data_copy(),
        NumericFloat32(atof(td.data.item())),
        msg="Forward pass disagrees with Pytorch",
    )
    assert_equal(
        a.grad.get_data_copy(),
        NumericFloat32(atof(ta.grad.item())),
        msg="Backward pass disagrees with Pytorch",
    )


fn test_add_mul_pow() raises:
    var a = Value(NumericFloat32(2.0))
    var b = Value(NumericFloat32(-3.0))
    var c = Value(NumericFloat32(10.0))
    var d = a * b + c
    var e = d**2
    e.backward()

    # Pytorch check
    var torch = Python.import_module("torch")
    var ta: PythonObject = torch.Tensor([2]).double()
    ta.requires_grad = True
    var tb: PythonObject = torch.Tensor([-3]).double()
    var tc: PythonObject = torch.Tensor([10]).double()
    var td: PythonObject = ta * tb + tc
    var te: PythonObject = td**2
    te.backward()
    assert_equal(
        e.data.get_data_copy(),
        NumericFloat32(atof(te.data.item())),
        msg="Forward pass disagrees with Pytorch",
    )
    assert_equal(
        a.grad.get_data_copy(),
        NumericFloat32(atof(ta.grad.item())),
        msg="Backward pass disagrees with Pytorch",
    )


fn test_sanity_check() raises:
    # Micograd
    var x = Value(NumericFloat32(-4.0))
    var z = (Value(NumericFloat32(2.0)) * x) + Value(NumericFloat32(2.0)) + x
    var q = z.relu() + (z * x)
    var h = (z * z).relu()
    var y = h + q + (q * x)
    y.backward()
    var xmg = x
    var ymg = y

    print(ymg.data.get_data_copy())
    print(xmg.grad.get_data_copy())

    # Pytorch
    var torch = Python.import_module("torch")
    var tx: PythonObject = torch.Tensor([-4.0]).double()
    tx.requires_grad = True
    var tz: PythonObject = (torch.Tensor([2]).double() * tx) + torch.Tensor(
        [2]
    ).double() + tx
    var tq: PythonObject = tz.relu() + (tz * tx)
    var th = (tz * tz).relu()
    var ty = th + tq + (tq * tx)
    ty.backward()
    var xpt = tx
    var ypt = ty

    print(ypt.data.item())
    print(xpt.grad.item())

    # forward pass went well
    assert_true(
        ymg.data.get_data_copy() == NumericFloat32(atof(ypt.data.item()))
    )
    # backward pass went well
    assert_true(
        xmg.grad.get_data_copy() == NumericFloat32(atof(xpt.grad.item()))
    )


fn all_test_value() raises:
    test_add_mul()
    test_add_mul_pow()
    # test_sanity_check()
