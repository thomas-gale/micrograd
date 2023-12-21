from python import Python
from memory.unsafe import Pointer
from collections.vector import DynamicVector


fn use_set() raises -> PythonObject:
    let set = Python.import_module("set")
    return set


trait Numeric(Copyable, Stringable):
    fn __add__(self, other: Self) -> Self:
        ...

    fn __mul__(self, other: Self) -> Self:
        ...


struct Value[T: Numeric](Stringable):
    var data: T
    var prev: PythonObject

    fn __init__(inout self, data: T) raises:
        self.data = data
        self.prev = use_set().set()
        # self.prev = Pointer[PythonObject].alloc(1)
        # self.prev = DynamicVector[Self]()

    fn __init__(inout self, data: T, prev: PythonObject) raises:
        self.data = data
        # self.prev = Pointer[PythonObject].alloc(1)
        self.prev = use_set().set()
        # self.prev = Pointer[DynamicVector[Self]].alloc(1)
        # self.prev = prev

    fn __copyinit__(inout self, existing: Self):
        self.data = existing.data
        # TODO: Check
        # self.prev = Pointer[PythonObject].alloc(1)
        self.prev = None
        try:
            self.prev = use_set().set()
        except:
            pass
        # self.prev = Pointer[DynamicVector[Self]].alloc(1)
        # self.prev = existing.prev

    fn __moveinit__(inout self, owned existing: Self):
        self.data = existing.data
        # TODO: Check
        self.prev = None
        try:
            self.prev = use_set().set()
        except:
            pass
        # self.prev = Pointer[DynamicVector[Self]].alloc(1)
        # self.prev = existing.prev

    fn __del__(owned self):
        # self.prev.clear()
        pass

    fn __add__(self, other: Self) raises -> Self:
        # var prev = DynamicVector[Self]()
        # prev.push_back(self)
        # prev.push_back(other)
        return Value(self.data + other.data)
        # return Value(self.data + other.data, prev)

    fn __mul__(self, other: Self) raises -> Self:
        # var prev = DynamicVector[Self]()
        # prev.push_back(self)
        # prev.push_back(other)
        return Value(self.data * other.data)
        # return Value(self.data * other.data, prev)

    fn __str__(self) -> String:
        return str(self.data)


@value
struct NumericFloat32(Numeric):
    var data: Float32

    fn __add__(self, other: Self) -> Self:
        return NumericFloat32(self.data + other.data)

    fn __mul__(self, other: Self) -> Self:
        return NumericFloat32(self.data * other.data)

    fn __str__(self) -> String:
        return str(self.data)


fn main() raises:
    let a = Value(NumericFloat32(2.0))
    let b = Value(NumericFloat32(-3.0))
    let c = Value(NumericFloat32(10.0))
    let d = a * b + c
    print(d)
