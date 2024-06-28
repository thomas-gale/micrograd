## 🔥Micrograd 🔥
Attempting to follow Andrej Karpathy's wonderful [tutorial](https://youtu.be/VMj-3S1tku0?si=EpDtCDZ-rv9ClTwC) and implement [micrograd](https://github.com/karpathy/micrograd) in [mojo](https://docs.modular.com/mojo/).
I attempt to closely follow the structure of the original code with a few minor deviations/details:
- Recursive topoligical sort in `_backward` as iterative.
- Mojo details: Internal `data`, `grad` and `_prev` use a custom and very basic `RC` (reference counting pointer)
- Mojo details: Attempting to use `traits` to make `Value` as `generic` as possible (we introduce a `trait` called `Gradable` which is basically a type constraint on what is needed on an 'autogradable' type which can be wrapped by our `Value`)

### Dev setup
- Follow guide https://docs.modular.com/mojo/manual/get-started
- Opionally use the `devcontaier`
- `make install`
- `make test`
- `make run`
- `make ...` (see `MakeFile`)
