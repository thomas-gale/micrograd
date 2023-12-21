def greet(name: String) -> String:
    return "Hello, " + name + "!"


struct MyPair:
    var first: Int
    var second: Int

    fn __init__(inout self, first: Int, second: Int):
        self.first = first
        self.second = second

    fn dump(self):
        print(self.first, self.second)


# Traits
trait SomeTrait:
    fn required_method(self, x: Int):
        ...


struct SomeStruct(SomeTrait):
    fn __init__(inout self):
        pass

    fn required_method(self, x: Int):
        print("hello traits", x)


fn fun_with_traits[T: SomeTrait](x: T):
    x.required_method(42)


# Compile-time Parameterized Functions
fn repeat[count: Int](msg: String):
    for i in range(count):
        print(msg)


# Using python
from python import Python


fn use_array() raises:
    # This is equivalent to Python's `import numpy as np`
    let np = Python.import_module("numpy")
    let ar = np.arange(15).reshape(3, 5)
    print(ar)
    print(ar.shape)


# Ownership and Borrowing
# All values passed into a Mojo def function are owned, by default.
# All values passed into a Mojo fn function are borrowed, by default.
fn add(inout x: Int, borrowed y: Int):
    x += y


def mutate(inout y: Int) -> None:
    y += 1


fn take_text(owned text: String):
    text += "!"
    print(text)


fn main() raises:
    # print(greet("World"))
    # print(greet("Grok"))
    # print(greet("123"))
    # print(greet(""))

    # let mine = MyPair(2, 4)
    # mine.dump()

    # let thing = SomeStruct()
    # fun_with_traits(thing)

    # repeat[3]("Hello")

    # use_array()

    # var a = 1
    # let b = 2
    # add(a, b)
    # print(a)  # Prints 3

    # var x = 1
    # mutate(x)
    # print(x)

    # let message: String = "Hello"
    # take_text(message ^)
