from collections import Set, KeyElement
from memory.unsafe_pointer import (
    UnsafePointer,
    initialize_pointee_copy,
    initialize_pointee_move,
)

from micrograd import RC
from micrograd import Gradable, GradFloat32

from micrograd.copy_move_list import CopyMoveList


struct Value[T: Gradable](KeyElement, Stringable):
    """
    Value is a reference counted object that holds a node in the computation graph.
    Value using reference semantics for equality (e.g pointer equality not data equality).
    Normal copy operations will only copy (and increment counts) of the reference counted pointer data in the node.
    TODO: add a clone() which can create deep copies of the graph rooted at this node.
    """

    var data: RC[T]
    var grad: RC[T]

    # One defined via an operation, it captures mutable (inout) references to self and other (if applicable)
    var _backward: fn () escaping -> None
    var _prev: RC[CopyMoveList[Self]]
    var _op: String

    fn __init__(inout self: Self, owned data: T):
        self.data = RC(data^)
        self.grad = RC(T.zero())

        fn _backward() escaping -> None:
            pass

        self._backward = _backward
        self._prev = RC(CopyMoveList[Self]())
        self._op = ""

    fn __init__(
        inout self: Self,
        owned data: T,
        owned prev: CopyMoveList[Self],
        owned op: String,
    ):
        self.data = RC(data^)
        self.grad = RC(T.zero())

        fn _backward():
            pass

        self._backward = _backward
        self._prev = RC(prev^)
        self._op = op^

    fn __copyinit__(inout self: Self, existing: Self):
        self.data = existing.data
        self.grad = existing.grad

        self._backward = existing._backward
        self._prev = existing._prev
        self._op = existing._op
        pass

    fn __moveinit__(inout self: Self, owned existing: Self):
        self.data = existing.data^
        self.grad = existing.grad^

        self._backward = existing._backward^
        self._prev = existing._prev^
        self._op = existing._op^
        pass

    fn __add__(owned self, owned other: Self) -> Self:
        """
        We use owned so that when rvalue references are passed in, we can automatically move the data out of the Value object.
        """
        var out = Self(
            self.data.ptr[] + other.data.ptr[],
            CopyMoveList[Self](data=List(self, other)),
            "+",
        )

        fn _backward():
            self.grad.ptr[] += out.grad.ptr[]
            other.grad.ptr[] += out.grad.ptr[]

        out._backward = _backward
        return out

    fn __mul__(owned self, owned other: Self) -> Self:
        var out = Self(
            self.data.ptr[] * other.data.ptr[],
            CopyMoveList[Self](data=List(self, other)),
            "*",
        )

        fn _backward():
            self.grad.ptr[] += other.data.ptr[] * out.grad.ptr[]
            other.grad.ptr[] += self.data.ptr[] * out.grad.ptr[]

        out._backward = _backward
        return out

    fn __pow__(owned self, owned exp: Float32) -> Self:
        var out = Self(
            self.data.ptr[] ** exp, CopyMoveList[Self](self), "**" + String(exp)
        )

        fn _backward():
            self.grad.ptr[] += (
                T.from_float32(exp) * (self.data.ptr[] ** (exp - 1))
            ) * out.grad.ptr[]

        out._backward = _backward
        return out

    fn relu(owned self) -> Self:
        var out = Self(
            T.zero() if self.data.ptr[] < T.zero() else self.data.ptr[],
            CopyMoveList[Self](self),
            "ReLU",
        )

        fn _backward():
            if out.data.ptr[] > T.zero():
                self.grad.ptr[] += out.grad.ptr[]

        out._backward = _backward
        return out

    fn backward(owned self):
        # Topological order all of the children in the graph - iterative implementation of topological sort, simulating a call stack
        var topo = List[Self]()
        var visited = Set[Self]()
        var stack = List[Self]()

        # Two lists rather than a tuple to avoid the need for a collection element type for the tuple
        var current_call_stack = List[Self]()  # A stack to manage the recursive call states
        var processed_call_stack = List[Bool]()  # A stack to manage the recursive call states

        stack.append(self)
        current_call_stack.append(self)
        processed_call_stack.append(False)
        while not len(current_call_stack) == 0:
            var current = current_call_stack.pop()
            var processed = processed_call_stack.pop()
            if processed:
                topo.append(current)
            else:
                if current not in visited:
                    visited.add(current)
                    current_call_stack.append(current)
                    processed_call_stack.append(True)
                    for child in reversed(current._prev.ptr[].data):  # Reverse to maintain order
                        if child[] not in visited:
                            stack.append(child[])
                            current_call_stack.append(child[])
                            processed_call_stack.append(False)


        # Go one variable at a time and apply the chain rule to get its gradient
        self.grad.ptr[] = T.one()
        for v in reversed(topo):
            # print("\nApplying chain rule to:\n", v[])  # Debugging
            v[]._backward()

    fn __hash__(self: Self) -> Int:
        return hash(self.data.ptr[])

    fn __eq__(self: Self, other: Self) -> Bool:
        """
        Value using reference semantics for equality (e.g pointer equality not data equality).
        """
        return (
            self.data.ptr == other.data.ptr and self.grad.ptr == other.grad.ptr
        )

    fn __ne__(self: Self, other: Self) -> Bool:
        """
        Value using reference semantics for equality (e.g pointer equality not data equality).
        """
        return (
            self.data.ptr != other.data.ptr and self.grad.ptr != other.grad.ptr
        )

    fn __neg__(owned self: Self) -> Self: 
        return self * Self(T.from_float32(-1))

    fn __radd__(owned self: Self, owned other: Self) -> Self:
        return self + other

    fn __sub__(owned self: Self, owned other: Self) -> Self:
        return self + (-other)

    fn __rsub__(owned self: Self, owned other: Self) -> Self:
        return other + (-self)

    fn __rmul__(owned self: Self, owned other: Self) -> Self: 
        return self * other

    fn __truediv__(owned self: Self, owned other: Self) -> Self: 
        return self * other**-1

    fn __rtruediv__(owned self: Self, owned other: Self) -> Self: 
        return other * self**-1

    fn __str__(self: Self) -> String:
        return self.pretty_print(0)

    fn pretty_print(self: Self, indent: Int) -> String:
        var val = str(self.data.ptr[])
                + " ("
                + str(self.data.ptr)
                + ")"
                + " (∇"
                + str(self.grad.ptr[])
                + ")"
                + " ("
                + str(self.grad.ptr)
                + ")"

        if len(self._prev.ptr[].data) == 0:
            return val

        var prev = String()
        prev += "\n" + String(" ") * indent + "| " + self._op
        for element in self._prev.ptr[].data:
            prev += (
                "\n"
                + String(" ") * indent
                + "| "
                + element[].pretty_print(indent + 1)
            )
        return val + prev
