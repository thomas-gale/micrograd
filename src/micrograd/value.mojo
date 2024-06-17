from collections import Set, KeyElement
from memory.unsafe import Pointer

from micrograd.numeric import Numeric


struct Value[T: Numeric](KeyElement, Stringable):
    var data: T
    var grad: T

    var _backward: fn () escaping -> None
    var _prev: Set[Self]
    var _op: String

    fn __init__(inout self: Self, owned data: T):
        self.data = data^
        self.grad = T.zero()

        fn _backward():
            pass

        self._backward = _backward
        self._prev = Set[Self]()
        self._op = ""

    fn __init__(
        inout self: Self,
        owned data: T,
        owned prev: Set[Self],
        owned op: String,
    ):
        self.data = data^
        self.grad = T.zero()

        fn _backward():
            pass

        self._backward = _backward
        self._prev = prev^
        self._op = op^

    fn __copyinit__(inout self: Self, existing: Self):
        self.data = existing.data
        self.grad = existing.grad

        self._backward = existing._backward
        self._prev = Set[Self](existing._prev)
        self._op = existing._op
        pass

    fn __moveinit__(inout self: Self, owned existing: Self):
        self.data = existing.data^
        self.grad = existing.grad^

        self._backward = existing._backward
        self._prev = existing._prev^
        self._op = existing._op^
        pass

    fn __add__(inout self, inout other: Self) -> Self:
        var out = Self(self.data + other.data, Set[Self](self, other), "+")

        fn _backward():
            self.grad += out.grad
            other.grad += out.grad

        out._backward = _backward

        return out

    fn __mul__(inout self, inout other: Self) -> Self:
        var out = Self(self.data + other.data, Set[Self](self, other), "*")

        fn _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad

        out._backward = _backward

        return out

    # fn __pow__(inout self, owned other: T) -> Self:
    #     var out = Self(
    #         self.data**other, Set[Self](self), "**" + String(other)
    #     )

    #     fn _backward():
    #         self.grad += (other * self.data ** (other - 1)) * out.grad

    #     out._backward = _backward

    #     return out

    fn relu(inout self) -> Self:
        var out = Self(
            T.zero() if self.data < T.zero() else self.data,
            Set[Self](
                self,
            ),
            "ReLU",
        )

        fn _backward():
            if out.data > T.zero():
                self.grad += out.grad

        out._backward = _backward

        return out

    # fn backward(self):
    #     # topological order all of the children in the graph
    #     var topo = []
    #     var visited = Set[Self]()

    #     fn build_topo(v: Self):
    #         if v not in visited:
    #             visited.add(v)
    #             for child in v._prev:
    #                 build_topo(child)
    #             topo.append(v)

    #     build_topo(self)

    #     # go one variable at a time and apply the chain rule to get its gradient
    #     self.grad = T.one()
    #     for v in reversed(topo):
    #         v._backward()

    fn __hash__(self: Self) -> Int:
        return hash(self.data)

    fn __eq__(self: Self, other: Self) -> Bool:
        return self.data == other.data

    fn __ne__(self: Self, other: Self) -> Bool:
        return self.data != other.data

    fn __str__(self: Self) -> String:
        return self.pretty_print(0)

    fn pretty_print(self: Self, indent: Int) -> String:
        if len(self._prev) == 0:
            return str(self.data)

        var prev = String()
        prev += "\n" + String(" ") * indent + "| " + self._op
        for element in self._prev:
            prev += (
                "\n"
                + String(" ") * indent
                + "| "
                + element[].pretty_print(indent + 1)
            )
        return str(self.data) + prev
