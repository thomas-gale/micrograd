## 🔥Micrograd 🔥
Attempting to follow Andrej Karpathy's wonderful [tutorial](https://youtu.be/VMj-3S1tku0?si=EpDtCDZ-rv9ClTwC) and implement [micrograd](https://github.com/karpathy/micrograd) in [mojo](https://docs.modular.com/mojo/).

### Notes
- The `Value` uses reference semantics.
- The `Value`'s internal `data`, `grad` and `_prev` use a custom and very basic `RC` (reference counting pointer) - this will be migrated to references (and lifetimes) once they are ready in the core language.
- Using `traits` to make `Value` a `generic` struct (we introduce a `trait` called `Gradable` which is basically a type constraint on what is needed on an 'autogradable' type which can be wrapped by our `Value`).
- `Gradable` implementations:
	- [x] `GradFloat32`
	- [ ] `GradTensorFloat32`
- The topological sort in `_backward` is using an iterative implementation ([nested functions don't currently support recursion](https://docs.modular.com/mojo/roadmap#nested-functions-cannot-be-recursive))
- Primitive test suite (`make test`) (including tests that mimic those of [micrograd](https://github.com/karpathy/micrograd/blob/master/test/test_engine.py))

### Dev setup
- Follow guide https://docs.modular.com/mojo/manual/get-started
- Opionally use the `devcontaier`
- `make install`
- `make test`
- `make run`
- `make ...` (see `MakeFile`)
