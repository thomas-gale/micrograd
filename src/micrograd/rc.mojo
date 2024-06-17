from memory.unsafe_pointer import (
    UnsafePointer,
    initialize_pointee_copy,
    initialize_pointee_move,
    destroy_pointee,
)

# trait CopyableAndMoveable(Copyable, Movable):
#     ...

struct RC[T: Movable]:
    var ptr: UnsafePointer[T]
    var ref_count: UnsafePointer[Int]

    fn __init__(inout self, owned data: T):
        self.ptr = UnsafePointer[T].alloc(1)
        initialize_pointee_move(self.ptr, data^)
        self.ref_count = UnsafePointer[Int].alloc(1)
        initialize_pointee_move(self.ref_count, 1)

    fn __init__(inout self, ptr: UnsafePointer[T]):
        self.ptr = ptr
        self.ref_count = UnsafePointer[Int].alloc(1)
        initialize_pointee_move(self.ref_count, 1)

    fn __copyinit__(inout self, existing: Self):
        self.ptr = existing.ptr
        self.ref_count = existing.ref_count
        self.ref_count[] += 1

    fn __moveinit__(inout self, owned existing: Self):
        self.ptr = existing.ptr
        self.ref_count = existing.ref_count

    fn __del__(owned self):
        self.ref_count[] -= 1
        if self.ref_count[] <= 0:
            destroy_pointee(self.ptr)
            destroy_pointee(self.ref_count)
