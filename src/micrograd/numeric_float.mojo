from micrograd.numeric import Numeric


@value
struct NumericFloat32[Epsilon: Float32 = 1e-8](Numeric):
    """
    Note: Epsilon change is a strictly different type.
    """

    var data: Float32

    @staticmethod
    fn zero() -> Self:
        return Self(0.0)

    @staticmethod
    fn one() -> Self:
        return Self(1.0)

    fn __add__(self, other: Self) -> Self:
        return Self(self.data + other.data)

    fn __iadd__(inout self: Self, other: Self):
        self.data += other.data

    fn __sub__(self, other: Self) -> Self:
        return Self(self.data - other.data)

    fn __isub__(inout self: Self, other: Self):
        self.data -= other.data

    fn __mul__(self, other: Self) -> Self:
        return Self(self.data * other.data)

    fn __imul__(inout self: Self, other: Self):
        self.data *= other.data

    # fn __pow__(self, other: Self) -> Self:
    #     return Self(self.data**other)

    fn __abs__(self) -> Self:
        return Self(abs(self.data))

    fn __eq__(self, other: Self) -> Bool:
        return abs(self.data - other.data) < Epsilon

    fn __ne__(self, other: Self) -> Bool:
        return abs(self.data - other.data) >= Epsilon

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
