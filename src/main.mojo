from python import Python
from python.object import PythonObject

from micrograd.value import Value


fn main() raises:
    var a = Value[Int](2)
    var b = Value[Int](4)
    var c = a + b
    print(c)

    var tk = Python.import_module("tkinter")
    var window = tk.Tk()
    window.mainloop()

    # var np = Python.import_module("numpy")
    # var plt = Python.import_module("matplotlib.pyplot")
    # var colors = Python.import_module("matplotlib.colors")

    # var plts = plt.subplots()             # Create a figure containing a single Axes.
    # plts[1].plot([1, 2, 3, 4], [1, 4, 2, 3])  # Plot some data on the Axes.
    # plts[0].show()       

    # fn f(x: Float32) -> Float32:
    #     return 3 * x**2 - 4 * x + 5

    # var xs = np.arange(-5.0, 5.0, 0.25)
    # var ys = np.array((), np.float32)

    # for x in xs:
    #     ys = np.append(ys, f(x.to_float64().cast[DType.float32]()))

    # plt.plot(xs, ys)
    # plt.plot()
    # plt.show()

    # var h = 0.001
    # var x = 3.0
    # print((f(x + h) - f(x)) / h)
