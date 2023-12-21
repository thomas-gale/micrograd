from memory.unsafe import Pointer
from collections.vector import DynamicVector


trait Numeric(Copyable, Stringable):
    fn __add__(self, other: Self) -> Self:
        ...

    fn __mul__(self, other: Self) -> Self:
        ...


struct Value[T: Numeric](CollectionElement, Stringable):
    var data: T
    var prev: DynamicVector[Self]

    fn __init__(inout self, data: T):
        self.data = data
        self.prev = DynamicVector[Self]()

    fn __init__(inout self, data: T, prev: DynamicVector[Self]):
        self.data = data
        self.prev = prev 

    fn __copyinit__(inout self, existing: Self):
        self.data = existing.data
        self.prev = existing.prev

    fn __moveinit__(inout self, owned existing: Self):
        self.data = existing.data
        self.prev = existing.prev

    fn __del__(owned self):
        self.prev.clear()

    fn __add__(self, other: Self) -> Self:
        var prev = DynamicVector[Self]()
        prev.push_back(self)
        prev.push_back(other)
        return Value(self.data + other.data, prev)

    fn __mul__(self, other: Self) -> Self:
        var prev = DynamicVector[Self]()
        prev.push_back(self)
        prev.push_back(other)
        return Value(self.data * other.data, prev)

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


fn main():
    let a = Value(NumericFloat32(2.0))
    let b = Value(NumericFloat32(-3.0))
    let c = Value(NumericFloat32(10.0))
    let d = a * b + c
    print(d)
