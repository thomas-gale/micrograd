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


fn main():
    # try:
    #     print(greet("World"))
    #     print(greet("Grok"))
    #     print(greet("123"))
    #     print(greet(""))
    # except:
    #     print("Error!")

    # let mine = MyPair(2, 4)
    # mine.dump()

    let thing = SomeStruct()
    fun_with_traits(thing)
