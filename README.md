# [Micrograd](https://youtu.be/VMj-3S1tku0?si=EpDtCDZ-rv9ClTwC) [Mojo](https://docs.modular.com/mojo/)

Attempting to follow Andrej's wonderful tutorial and implement in mojo lang (v.2023-08-24)

## Dev setup
- Register to get private mojo download command: https://developer.modular.com/download
- Reopen repo in vscode devcontainers (will create ubuntu 22 environment)
- `sudo apt install python3.10-venv`
- `curl https://get.modular.com | sh - && \
modular auth ************************************`
- `modular install mojo`
- ```export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"
```



```mojo

```

    error: [0;1;31m[1mExpression [86]:40:23: [0m[1minvalid call to 'push_back': method argument #0 cannot bind generic !mlirtype to memory-only type 'Value[T]'
    [0m        prev.push_back(self)
    [0;1;32m        ~~~~~~~~~~~~~~^~~~~~
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mfunction declared here
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    error: [0;1;31m[1mExpression [86]:41:23: [0m[1minvalid call to 'push_back': method argument #0 cannot bind generic !mlirtype to memory-only type 'Value[T]'
    [0m        prev.push_back(other)
    [0;1;32m        ~~~~~~~~~~~~~~^~~~~~~
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mfunction declared here
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    error: [0;1;31m[1mExpression [86]:42:32: [0m[1m'T' does not implement the '__add__' method
    [0m        return Value(self.data + other.data, [self, other])
    [0;1;32m                     ~~~~~~~~~ ^
    [0m[0m
    error: [0;1;31m[1mExpression [86]:46:23: [0m[1minvalid call to 'push_back': method argument #0 cannot bind generic !mlirtype to memory-only type 'Value[T]'
    [0m        prev.push_back(self)
    [0;1;32m        ~~~~~~~~~~~~~~^~~~~~
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mfunction declared here
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    error: [0;1;31m[1mExpression [86]:47:23: [0m[1minvalid call to 'push_back': method argument #0 cannot bind generic !mlirtype to memory-only type 'Value[T]'
    [0m        prev.push_back(other)
    [0;1;32m        ~~~~~~~~~~~~~~^~~~~~~
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mfunction declared here
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    error: [0;1;31m[1mExpression [86]:48:32: [0m[1m'T' does not implement the '__mul__' method
    [0m        return Value(self.data * other.data, [self, other])
    [0;1;32m                     ~~~~~~~~~ ^
    [0m[0m
    error: [0;1;31m[1mExpression [86]:51:14: [0m[1mno matching function in call to 'print': 
    [0m        print(self.data)
    [0;1;32m        ~~~~~^~~~~~~~~~~
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: callee expects 0 arguments, but 1 was specified
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: argument #0 cannot be converted from 'T' to 'DType'
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: argument #0 cannot be converted from 'T' to 'String'
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: argument #0 cannot be converted from 'T' to 'StringRef'
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: argument #0 cannot be converted from 'T' to 'StringLiteral'
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: argument #0 cannot be converted from 'T' to 'Bool'
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: argument #0 cannot be converted from 'T' to 'FloatLiteral'
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: argument #0 cannot be converted from 'T' to 'Int'
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: callee expects 2 input parameters but 0 were provided
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [0]:1:1: [0m[1mcandidate not viable: callee expects 2 input parameters but 0 were provided (4 more notes omitted.)
    [0mfrom memory.unsafe import Pointer
    [0;1;32m^
    [0m[0m
    expression failed to parse (no further compiler diagnostics)


```mojo
let a = Value(2.0, [])
let b = Value(-3.0, [])
let c = Value(10.0, [])
let d = a*b + c
d.dump()
```

    error: [0;1;31m[1mExpression [36]:16:1: [0m[1mno viable expansions found
    [0mfn __lldb_expr__36(inout __mojo_repl_arg: __mojo_repl_context__):
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [36]:18:28: [0m[1m  call expansion failed - no concrete specializations
    [0m    __mojo_repl_expr_impl__(__mojo_repl_arg, __get_address_as_lvalue(__mojo_repl_arg.`___lldb_expr_failed`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`c`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`b`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`a`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`x`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`h`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`ys`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`xs`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`plt`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`np`.load().address), __get_address_as_lvalue(__mojo_repl_arg.`colors`.load().address))
    [0;1;32m                           ^
    [0m[0m
    [0;1;30m[1mExpression [36]:22:1: [0m[1m    no viable expansions found
    [0mdef __mojo_repl_expr_impl__(inout __mojo_repl_arg: __mojo_repl_context__, inout `___lldb_expr_failed`: __mlir_type.`!kgen.declref<@"$builtin"::@"$bool"::@Bool>`, inout `c`: __mlir_type.`!kgen.declref<@"$Expression [22]"::@Value>`, inout `b`: __mlir_type.`!kgen.declref<@"$Expression [22]"::@Value>`, inout `a`: __mlir_type.`!kgen.declref<@"$Expression [22]"::@Value>`, inout `x`: __mlir_type.`!kgen.declref<@"$builtin"::@"$float_literal"::@FloatLiteral>`, inout `h`: __mlir_type.`!kgen.declref<@"$builtin"::@"$float_literal"::@FloatLiteral>`, inout `ys`: __mlir_type.`!kgen.declref<@"$python"::@"$object"::@PythonObject>`, inout `xs`: __mlir_type.`!kgen.declref<@"$python"::@"$object"::@PythonObject>`, inout `plt`: __mlir_type.`!kgen.declref<@"$python"::@"$object"::@PythonObject>`, inout `np`: __mlir_type.`!kgen.declref<@"$python"::@"$object"::@PythonObject>`, inout `colors`: __mlir_type.`!kgen.declref<@"$python"::@"$object"::@PythonObject>`) -> None:
    [0;1;32m^
    [0m[0m
    [0;1;30m[1mExpression [36]:34:26: [0m[1m      call expansion failed - no concrete specializations
    [0m  __mojo_repl_expr_body__()
    [0;1;32m                         ^
    [0m[0m
    [0;1;30m[1mExpression [36]:24:3: [0m[1m        no viable expansions found
    [0m  def __mojo_repl_expr_body__() -> None:
    [0;1;32m  ^
    [0m[0m
    [0;1;30m[1mExpression [36]:30:17: [0m[1m          call expansion failed - no concrete specializations
    [0m    let d = a*b + c
    [0;1;32m                ^
    [0m[0m
    [0;1;30m[1mExpression [35]:23:5: [0m[1m            no viable expansions found
    [0m    fn __add__(self, other: Self) -> Self:
    [0;1;32m    ^
    [0m[0m
    [0;1;30m[1mExpression [35]:24:46: [0m[1m              call expansion failed - no concrete specializations
    [0m        return Value(self.data + other.data, [self, other])
    [0;1;32m                                             ^
    [0m[0m
    expression failed to parse (no further compiler diagnostics)

### nn.mojo


```mojo

```

