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
        pass


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

    # Now use numpy as if writing in Python
    let array = np.array([1, 2, 3])
    print(array)


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

    use_array()
