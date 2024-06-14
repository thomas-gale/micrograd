from collections import Set, KeyElement
from memory.unsafe import Pointer


trait Numeric(Copyable, Stringable, Hashable, Comparable):
    fn __add__(self, other: Self) -> Self:
        ...

    fn __mul__(self, other: Self) -> Self:
        ...


struct Value[T: Numeric](KeyElement, Stringable):
    var data: T
    var prev: Set[Self]

    fn __init__(inout self: Self, data: T):
        self.data = data
        self.prev = Set[Self]()

    fn __init__(inout self: Self, data: T, owned prev: Set[Self]):
        self.data = data
        self.prev = prev^

    fn __copyinit__(inout self: Self, existing: Self):
        self.data = existing.data
        self.prev = Set[Self](existing.prev)
        pass

    fn __moveinit__(inout self: Self, owned existing: Self):
        self.data = existing.data
        self.prev.__moveinit__(existing.prev^)
        pass

    fn __hash__(self: Self) -> Int:
        return hash(self.data)

    fn __eq__(self: Self, other: Self) -> Bool:
        return self.data == other.data

    fn __ne__(self: Self, other: Self) -> Bool:
        return self.data != other.data

    fn __add__(self, other: Self) -> Self:
        return Self(self.data + other.data, Set[Self](self, other))

    fn __mul__(self, other: Self) -> Self:
        return Self(self.data * other.data, Set[Self](self, other))

    fn __str__(self: Self) -> String:
        var prev = String()
        for element in self.prev:
            prev += "\n -> " + str(element[])
        if len(self.prev) > 0:
            return "Value: " + str(self.data) + "\nPrev:" + prev
        else:
            return "Value: " + str(self.data)


@value
struct NumericFloat32[Epsilon: Float32 = 1e-8](Numeric):
    var data: Float32

    fn __add__(self, other: Self) -> Self:
        return Self(self.data + other.data)

    fn __mul__(self, other: Self) -> Self:
        return Self(self.data * other.data)

    fn __eq__(self, other: Self) -> Bool:
        return self.data - other.data < Epsilon

    fn __ne__(self, other: Self) -> Bool:
        return self.data - other.data >= Epsilon

    fn __lt__(self, other: Self) -> Bool:
        return self.data < other.data + Epsilon

    fn __le__(self, other: Self) -> Bool:
        return self.data < other.data + Epsilon

    fn __gt__(self, other: Self) -> Bool:
        return self.data > other.data - Epsilon

    fn __ge__(self, other: Self) -> Bool:
        return self.data > other.data - Epsilon

    fn __str__(self) -> String:
        return str(self.data)

    fn __hash__(self) -> Int:
        return hash(self.data)
