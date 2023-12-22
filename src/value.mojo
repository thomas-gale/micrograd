from memory.unsafe import Pointer
from collections.vector import DynamicVector


# @register_passable("trivial")
# trait Numeric(Copyable, Stringable):
#     fn __add__(self, other: Self) -> Self:
#         ...

#     fn __mul__(self, other: Self) -> Self:
#         ...


struct List[T: AnyRegType](Copyable):
    var length: Int
    var data: Pointer[T]

    fn __init__(inout self, length: Int):
        self.length = length
        self.data = Pointer[T].alloc(length)

    fn __copyinit__(inout self, existing: Self):
        self.length = existing.length
        self.data = Pointer[T].alloc(self.length)
        for i in range(self.length):
            self.data[i] = existing.data[i]


alias ValueType = Float32


@register_passable("trivial")
struct Value(Stringable):
    var data: Pointer[ValueType]
    var prev: Pointer[List[Self]]

    fn __init__(data: ValueType) -> Self:
        let stored_data: Pointer[ValueType] = Pointer[ValueType].alloc(1)
        stored_data.store(data)
        return Self {
            data: stored_data,
            prev: Pointer[List[Self]].get_null(),
        }

    # fn __init__(inout self, data: Float32, prev: DynamicVector[Self]):
    #     self.data = data
    #     self.prev = prev
    # self.prev = Pointer[PythonObject].alloc(1)
    # self.prev = Pointer[DynamicVector[Self]].alloc(1)
    # self.prev = prev

    fn __add__(self, other: Self) -> Self:
        return Value(self.data.load() + other.data.load())

    fn __mul__(self, other: Self) -> Self:
        return Value(self.data.load() * other.data.load())

    fn __str__(self) -> String:
        let value = self.data.load()
        return "Value(data=" + value.__str__() + ", grad=TODO)"


# @value
# struct NumericFloat32(Numeric):
#     var data: Float32

#     fn __add__(self, other: Self) -> Self:
#         return NumericFloat32(self.data + other.data)

#     fn __mul__(self, other: Self) -> Self:
#         return NumericFloat32(self.data * other.data)

#     fn __str__(self) -> String:
#         return str(self.data)


fn main() raises:
    # let empty = List[Value[NumericFloat32]](0)
    # let a = Value(NumericFloat32(2.0))
    # let b = Value(NumericFloat32(-3.0))
    # let c = Value(NumericFloat32(10.0))
    let a = Value(2.0)
    let b = Value(-3.0)
    let c = Value(10.0)
    let d = a * b + c
    print(d)
