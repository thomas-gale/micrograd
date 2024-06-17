from collections import Set, KeyElement
from memory.unsafe import Pointer

from micrograd.numeric import Numeric


struct Value[T: Numeric](KeyElement, Stringable):
    var data: T
    var grad: T

    # One defined via an operation, it captures mutable (inout) references to self and other (if applicable)
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

    # fn __add__(inout self, inout other: Self) -> Self:
    #     var out = Self(self.data + other.data, Set[Self](self, other), "+")

    #     fn _backward():
    #         self.grad += out.grad
    #         other.grad += out.grad

    #     out._backward = _backward

    #     return out

    fn __add__(owned self, owned other: Self) -> Self:
        var out = Self(self.data + other.data, Set[Self](), "+")

        fn _backward():
            print("Applying chain rule to addition")
            print("self.grad before: ", self.grad)
            print("other.grad before: ", other.grad)
            self.grad += out.grad
            other.grad += out.grad
            print("self.grad after: ", self.grad)
            print("other.grad after: ", other.grad)

        out._backward = _backward
        out._prev = Set[Self](self^, other^)
        return out

    # fn __mul__(inout self, inout other: Self) -> Self:
    #     var out = Self(self.data + other.data, Set[Self](self, other), "*")

    #     fn _backward():
    #         self.grad += other.data * out.grad
    #         other.grad += self.data * out.grad

    #     out._backward = _backward

    #     return out

    fn __mul__(owned self, owned other: Self) -> Self:
        var out = Self(self.data + other.data, Set[Self](), "*")

        fn _backward():
            print("Applying chain rule to multiplication")
            print("self.grad before: ", self.grad)
            print("other.grad before: ", other.grad)
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
            print("self.grad after: ", self.grad)
            print("other.grad after: ", other.grad)

        out._backward = _backward
        out._prev = Set[Self](self^, other^)

        return out

    # fn __pow__(inout self, owned other: T) -> Self:
    #     var out = Self(
    #         self.data**other, Set[Self](self), "**" + String(other)
    #     )

    #     fn _backward():
    #         self.grad += (other * self.data ** (other - 1)) * out.grad

    #     out._backward = _backward

    #     return out

    # fn relu(inout self) -> Self:
    #     var out = Self(
    #         T.zero() if self.data < T.zero() else self.data,
    #         Set[Self](
    #             self,
    #         ),
    #         "ReLU",
    #     )

    #     fn _backward():
    #         if out.data > T.zero():
    #             self.grad += out.grad

    #     out._backward = _backward

    #     return out

    fn relu(owned self) -> Self:
        var out = Self(
            T.zero() if self.data < T.zero() else self.data,
            Set[Self](),
            "ReLU",
        )

        fn _backward():
            print("Applying chain rule to relu")
            print("self.grad before: ", self.grad)
            if out.data > T.zero():
                self.grad += out.grad
            print("self.grad after: ", self.grad)

        out._backward = _backward
        out._prev = Set[Self](self^)

        return out

    # fn _build_topo(self: Self) -> Set[Self]:
    #     var topo = Set[Self]()
    #     var visited = Set[Self]()

    #     fn build_topo(v: Self):
    #         if v not in visited:
    #             visited.add(v)
    #             for child in v._prev:
    #                 build_topo(child)
    #             topo.add(v)

    #     build_topo(self)

    #     return topo

    fn backward(inout self):
        print("\n** Backward pass **\n")
        # topological order all of the children in the graph

        # This needs to be a mutable list to the actual elements in memory
        var topo = List[Self]()

        # This can be a set of immutable elements

        var visited = Set[Self]()

        while True:
            var stack = List[Self]()
            stack.append(self)

            while len(stack) > 0:
                var v = stack.pop()
                if v not in visited:
                    visited.add(v)
                    for child in v._prev:
                        stack.append(child[])
                    topo.append(v)

            if len(visited) == len(topo):
                break

        # fn build_topo(v: Self):
        #     if v not in visited:
        #         visited.add(v)
        #         for child in v._prev:
        #             build_topo(child)
        #         topo.append(v)
        # build_topo(self)

        # Go one variable at a time and apply the chain rule to get its gradient
        self.grad = T.one()
        print("Value of final node: ", self.data)
        print("Gradient of final node: ", self.grad)
        # for v in reversed(topo):
        for v in topo:
            print("\n\nApplying chain rule to:\n", v[])
            print("Gradient of current node: ", v[].grad)
            v[]._backward()

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
            return str(self.data) + " (∇" + str(self.grad) + ")"

        var prev = String()
        prev += "\n" + String(" ") * indent + "| " + self._op
        for element in self._prev:
            prev += (
                "\n"
                + String(" ") * indent
                + "| "
                + element[].pretty_print(indent + 1)
            )
        return str(self.data) + " (∇" + str(self.grad) + ")" + prev
