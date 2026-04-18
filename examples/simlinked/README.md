# ZLS import resolution bug

## Summary

ZLS fails to resolve module imports when the project is accessed through symlinks.

The code compiles fine, but ZLS breaks things like:

* go to definition
* resolving `@import("vulkan")`

---

## Repro

1. Open the project via the `examples/symlinked` path in an editor with ZLS
2. Go to `src/main.zig`
3. Try "go to definition" on:

```zig
const vk = @import("vulkan");
```

Now compare:

6. Open the same project via the `examples/simlink`
7. Repeat "go to definition"

---

## Expected behavior

ZLS should resolve imports the same way regardless of whether the project is opened via:

* a real path
* a symlinked path

Since the project builds correctly, both setups are valid and should behave identically.

---

## Actual behavior

* Import resolution/goto definition fails when opened via a `examples/simlink`
* Opening the same project via the `examples/simlinked` works fine

---

## Root cause

After some debugging, i found that in `DocumentStore.isAssociatedWith`

ZLS does not normalize or resolve symlinks when associating files with their `root_source_file`.

So when the project is opened through a symlink:

* the file paths seen by ZLS differ from the canonical paths used in the build graph
* association between files and modules fails
* the correct module context is not found

---

## Minimal Helix config

```toml
# .helix/languages.toml
[language-server.zls]
command = "/path/to/zls/zig-out/bin/zls"
config.zls.zig_exe_path = "/path/to/zig/bin/zig"
```

---

## Versions

* Zig: 0.16.0
* ZLS: 0.16.0 / master

