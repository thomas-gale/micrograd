from python import Python
from testing import assert_true

from micrograd import Value, NumericFloat32
from test import rc_tests 

fn test_grad() raises:
    var a = Value(NumericFloat32(2.0))
    var b = Value(NumericFloat32(-3.0))
    var c = Value(NumericFloat32(10.0))
    var d = a * b + c
    # print(d)
    d.backward()
    assert_true(a.grad == NumericFloat32(-3.0))
    assert_true(b.grad == NumericFloat32(2.0))
    assert_true(c.grad == NumericFloat32(1.0))


fn test_sanity_check() raises:
    var x = Value(NumericFloat32(-4.0))
    var two_1 = Value(NumericFloat32(2.0))
    var two_2 = Value(NumericFloat32(2.0))
    var two_x1 = two_1 * x
    var two_x2 = two_2 + x
    var z = two_x1 + two_x2
    var z_relu = z.relu()
    var zx = z * x
    var q = z_relu + zx
    var zz = z * z
    var h = zz.relu()
    var hq = h + q
    var qx = q * x
    var y = hq + qx
    y.backward()
    var xmg = x
    var ymg = y

    print(ymg.data)
    print(xmg.grad)

    var torch = Python.import_module("torch")
    var tx: PythonObject = torch.Tensor([-4.0]).double()
    tx.requires_grad = True
    var tz: PythonObject = torch.Tensor([2]).double() * tx + torch.Tensor(
        [2]
    ).double() + tx
    var tq: PythonObject = tz.relu() + tz * tx

    var th = (tz * tz).relu()
    var ty = th + tq + tq * tx
    ty.backward()
    var xpt = tx
    var ypt = ty

    print(ypt.data.item())
    print(xpt.grad.item())

    # forward pass went well
    assert_true(ymg.data == NumericFloat32(atof(ypt.data.item())))
    # backward pass went well
    assert_true(xmg.grad == NumericFloat32(atof(xpt.grad.item())))


fn main() raises:
    rc_tests()
    test_grad()
    # test_sanity_check()
