from python import Python
from testing import assert_true, assert_equal, assert_almost_equal
from time import now

from micrograd import Value, GradFloat32


fn test_add_mul() raises:
    # Micograd Mojo
    var a = Value(GradFloat32(2.0))
    var b = Value(GradFloat32(-3.0))
    var c = Value(GradFloat32(10.0))
    var d = a * b + c
    d.backward()

    # Analytical check
    assert_equal(a.grad.get_data_copy(), GradFloat32(-3.0))
    assert_equal(b.grad.get_data_copy(), GradFloat32(2.0))
    assert_equal(c.grad.get_data_copy(), GradFloat32(1.0))

    # Pytorch check
    var torch = Python.import_module("torch")
    var ta: PythonObject = torch.Tensor([2]).double()
    ta.requires_grad = True
    var tb: PythonObject = torch.Tensor([-3]).double()
    var tc: PythonObject = torch.Tensor([10]).double()
    var td: PythonObject = ta * tb + tc
    td.backward()
    assert_equal(
        d.data.get_data_copy(),
        GradFloat32(atof(td.data.item())),
        msg="Forward pass disagrees with Pytorch",
    )
    assert_equal(
        a.grad.get_data_copy(),
        GradFloat32(atof(ta.grad.item())),
        msg="Backward pass disagrees with Pytorch",
    )


fn test_add_mul_brackets() raises:
    var x = Value(GradFloat32(2.0))
    var h = Value(GradFloat32(3.0))
    var q = Value(GradFloat32(5.0))
    var y = h + q + (q * x)
    y.backward()

    var torch = Python.import_module("torch")
    var tx: PythonObject = torch.Tensor([2.0]).double()
    tx.requires_grad = True
    var th = torch.Tensor([3.0]).double()
    var tq = torch.Tensor([5.0]).double()
    tq.requires_grad = True
    var ty = th + tq + (tq * tx)
    ty.backward()

    assert_equal(
        y.data.get_data_copy(),
        GradFloat32(atof(ty.data.item())),
        msg="Forward pass disagrees with Pytorch",
    )
    assert_equal(
        x.grad.get_data_copy(),
        GradFloat32(atof(tx.grad.item())),
        msg="Backward pass to x disagrees with Pytorch",
    )
    assert_equal(
        q.grad.get_data_copy(),
        GradFloat32(atof(tq.grad.item())),
        msg="Backward pass to q disagrees with Pytorch",
    )


fn test_add_mul_pow() raises:
    var a = Value(GradFloat32(2.0))
    var b = Value(GradFloat32(-3.0))
    var c = Value(GradFloat32(10.0))
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
        GradFloat32(atof(te.data.item())),
        msg="Forward pass disagrees with Pytorch",
    )
    assert_equal(
        a.grad.get_data_copy(),
        GradFloat32(atof(ta.grad.item())),
        msg="Backward pass disagrees with Pytorch",
    )


fn test_add_mul_relu() raises:
    var a = Value(GradFloat32(2.0))
    var b = Value(GradFloat32(6.0))
    var c = Value(GradFloat32(10.0))
    var d = a * b + c
    var e = d.relu() * d.relu()

    e.backward()

    # Pytorch check
    var torch = Python.import_module("torch")
    var ta: PythonObject = torch.Tensor([2]).double()
    ta.requires_grad = True
    var tb: PythonObject = torch.Tensor([6]).double()
    var tc: PythonObject = torch.Tensor([10]).double()
    var td: PythonObject = ta * tb + tc
    var te: PythonObject = td.relu() * td.relu()
    te.backward()
    assert_equal(
        e.data.get_data_copy(),
        GradFloat32(atof(te.data.item())),
        msg="Forward pass to e disagrees with Pytorch",
    )
    assert_equal(
        a.grad.get_data_copy(),
        GradFloat32(atof(ta.grad.item())),
        msg="Backward pass to x disagrees with Pytorch",
    )


fn test_sanity_check() raises:
    print("Runnning test sanity check with profiling...")
    # Micograd
    var m_start = now()
    var x = Value(GradFloat32(-4.0))
    var z = (Value(GradFloat32(2.0)) * x) + Value(GradFloat32(2.0)) + x
    var q = z.relu() + (z * x)
    var h = (z * z).relu()
    var y = h + q + (q * x)
    y.backward()
    print("Micograd time:", now() - m_start, "ns")

    var t_start = now()
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
    print("Pytorch time:", now() - t_start, "ns")

    assert_equal(
        y.data.get_data_copy(),
        GradFloat32(atof(ty.data.item())),
        msg="Forward pass to y disagrees with Pytorch",
    )
    assert_equal(
        x.grad.get_data_copy(),
        GradFloat32(atof(tx.grad.item())),
        msg="Backward pass to x disagrees with Pytorch",
    )


fn all_test_value() raises:
    test_add_mul()
    test_add_mul_brackets()
    test_add_mul_pow()
    test_add_mul_relu()
    test_sanity_check()
