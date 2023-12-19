from math import mul
from python import Python
from python.object import PythonObject


fn main():
    let np = Python.import_module("numpy")
    let plt = Python.import_module("matplotlib.pyplot")
    let colors = Python.import_module("matplotlib.colors")

    fn f(x: Float32) -> Float32:
        return 3 * x**2 - 4 * x + 5

    let xs = np.arange(-5.0, 5.0, 0.25)
    var ys = np.array((), np.float32)

    for x in xs:
        ys = np.append(ys, f(x.to_float64().cast[DType.float32]()))

    plt.plot(xs, ys)
    plt.show()

    let h = 0.001
    let x = 3.0
    print((f(x + h) - f(x)) / h)
