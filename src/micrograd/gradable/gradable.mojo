from micrograd.traits import CopyableAndMovable


trait Gradable(CopyableAndMovable, Stringable, Hashable, Comparable):
    @staticmethod
    fn zero() -> Self:
        ...

    @staticmethod
    fn one() -> Self:
        ...

    @staticmethod
    fn epsilon() -> Float32:
        ...

    @staticmethod
    fn from_float32(float: Float32) -> Self:
        ...

    fn __add__(self, other: Self) -> Self:
        ...

    fn __iadd__(inout self: Self, other: Self):
        ...

    fn __sub__(self, other: Self) -> Self:
        ...

    fn __isub__(inout self: Self, other: Self):
        ...

    fn __mul__(self, other: Self) -> Self:
        ...

    fn __imul__(inout self: Self, other: Self):
        ...

    fn __pow__(self, other: Float32) -> Self:
        ...

