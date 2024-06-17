from python import Python
from python.object import PythonObject

from micrograd import Value, NumericFloat32


fn main() raises:
    var a = Value(NumericFloat32(3.53))
    var b = Value(NumericFloat32(4.12))
    # var c = Value(NumericFloat32(3.53)) + (Value(NumericFloat32(4.12)))
    var c  = a + b
    var d = Value(NumericFloat32(5.03))
    var e = c * d
    print(e)

    # import tkinter as tk
    # var tk = Python.import_module("tkinter")
    # var Image = Python.import_module("PIL.Image")
    # var ImageTk = Python.import_module("PIL.ImageTk")

    # # Function to update the image
    # var pil_image: PythonObject
    # var tk_image: PythonObject
    # var canvas: PythonObject

    # def update_image():

    # var update_image_obj = PythonObject(update_image)

    # Create the main window
    # var root = tk.Tk()
    # root.title("Minimal Tkinter Window with PIL Image")

    # # Create a canvas
    # canvas = tk.Canvas(root, width=200, height=200)
    # canvas.pack()

    # # Create a PIL image
    # pil_image = Image.new("RGB", (200, 200), color="white")

    # # Convert the PIL image to a format that Tkinter can display
    # tk_image = ImageTk.PhotoImage(pil_image)

    # # Add the image to the canvas
    # canvas.create_image(0, 0, anchor=tk.NW, image=tk_image)

    # # Update the image after a delay
    # # root.after(1000, PythonObject(update_image)  # Update the image after 1 second

    # # global pil_image, tk_image, canvas
    # # Modify the PIL image (example: set the pixel at (10, 10) to red)
    # pil_image.putpixel((10, 10), (255, 0, 0))

    # # Update the Tkinter image
    # tk_image = ImageTk.PhotoImage(pil_image)
    # canvas.create_image(0, 0, anchor=tk.NW, image=tk_image)
    # canvas.update()

    # # Run the Tkinter main loop
    # root.mainloop()

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
