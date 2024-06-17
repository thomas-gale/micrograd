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
    var op: String

    fn __init__(inout self: Self, owned data: T):
        self.data = data^
        self.prev = Set[Self]()
        self.op = ""

    fn __init__(
        inout self: Self, owned data: T, owned prev: Set[Self], owned op: String
    ):
        self.data = data^
        self.prev = prev^
        self.op = op^

    fn __copyinit__(inout self: Self, existing: Self):
        self.data = existing.data
        self.prev = Set[Self](existing.prev)
        self.op = existing.op
        pass

    fn __moveinit__(inout self: Self, owned existing: Self):
        self.data = existing.data^
        self.prev = existing.prev^
        self.op = existing.op^
        pass

    fn __hash__(self: Self) -> Int:
        return hash(self.data)

    fn __eq__(self: Self, other: Self) -> Bool:
        return self.data == other.data

    fn __ne__(self: Self, other: Self) -> Bool:
        return self.data != other.data

    fn __add__(self, other: Self) -> Self:
        return Self(self.data + other.data, Set[Self](self, other), "+")

    fn __mul__(self, other: Self) -> Self:
        return Self(self.data * other.data, Set[Self](self, other), "*")

    fn __str__(self: Self) -> String:
        return self.pretty_print(0)

    fn pretty_print(self: Self, indent: Int) -> String:
        if len(self.prev) == 0:
            return str(self.data)

        var prev = String()
        prev += "\n" + String(" ") * indent + "| " + self.op
        for element in self.prev:
            prev += (
                "\n"
                + String(" ") * indent
                + "| "
                + element[].pretty_print(indent + 1)
            )
        return str(self.data) + prev


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
