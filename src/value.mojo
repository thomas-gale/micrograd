from utils.vector import DynamicVector


struct Value[T: AnyType]:
    var data: T
    var _prev: DynamicVector[Self]

    fn __init__(inout self, data: T):
        self.data = data
        self._prev = DynamicVector[Self]()

    fn __init__(inout self, data: T, prev: DynamicVector[Self]):
        self.data = data
        self._prev = prev

    fn __copyinit__(inout self, existing: Self):
        self.data = existing.data
        self._prev = existing._prev

    fn __moveinit__(inout self, owned existing: Self):
        self.data = existing.data ^
        self._prev = existing._prev

    fn __add__(self, other: Self) -> Self:
        var prev = DynamicVector[Self]()
        prev.push_back(self)
        prev.push_back(other)
        return Value(self.data + other.data, [self, other])

    fn __mul__(self, other: Self) -> Self:
        var prev = DynamicVector[Self]()
        prev.push_back(self)
        prev.push_back(other)
        return Value(self.data * other.data, [self, other])

    fn dump(self):
        print(self.data)

fn main():
    let a = Value(2.0, [])
    let b = Value(-3.0, [])
    let c = Value(10.0, [])
    let d = a*b + c
    d.dump()