def _impl(ctx):
    foo_file = ctx.actions.declare_file("foo.txt")
    outputs = [foo_file]

    args = ctx.actions.args()
    args.add(foo_file)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    ctx.actions.run(
        outputs = outputs,
        arguments = [args],
        mnemonic = "Example",
        execution_requirements = {
            "supports-multiplex-workers": "1",
            "supports-workers": "1",
            "supports-multiplex-sandboxing": "1",
            "supports-worker-cancellation": "1",
            "supports-path-mapping": "1",
        },
        progress_message = "Running example worker on %{label}",
        executable = ctx.executable.example_worker,
    )

    return [
        DefaultInfo(files = depset(outputs)),
    ]

example_rule = rule(
    implementation = _impl,
    doc = "This worker won't ever run, but it doesn't need to.",
    attrs = {
        "example_worker": attr.label(
            executable = True,
            cfg = "exec",
            allow_files = True,
            default = Label(":example_worker"),
        ),
    },
)
