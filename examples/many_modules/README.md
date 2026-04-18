# ZLS import resolution bug

## Summary

ZLS fails to resolve `@cImport` and `@import` when a project has multiple modules.

The code compiles fine, but ZLS breaks things like:

* go to definition
* resolving `@cInclude("c.h")` or `@import("cbindings")`

---

## Repro

1. Open the project in an editor with ZLS
2. Go to `src/common.zig`
3. Try "go to definition" on `c.h` or on `@import("cbindings")`

It fails to resolve.

Now:

4. Uncomment this if condition in `build.zig`:

```zig
    ...
    // if (false) //
    {
    ...
```

5. Restart ZLS

Now:

* both `c.h` and `cbindings` imports can be resolved
* go-to-definition starts working

---

## Expected behavior

ZLS should resolve imports the same way the compiler does.

This project builds correctly, so the setup is valid.

---

## Actual behavior

* ZLS fails to resolve `@cInclude("c.h")` and `@import("cbindings")`
* only happens when multiple modules reference the same file
* restarting ZLS does not fix it

---

## Root cause

After some debugging, i found that `DocumentStore.getAssociatedBuildFile` returns only the first root_source_file that references a file (like `common.zig`).
here's the relavant code:
- [the call to collectIncludeDirs](https://github.com/zigtools/zls/blob/295cedd8ddd040c77e6666ddab6ef6da8c0beffa/src/features/goto.zig#L264)
- [the call to getAssociatedBuildFile](https://github.com/zigtools/zls/blob/295cedd8ddd040c77e6666ddab6ef6da8c0beffa/src/DocumentStore.zig#L1723)
- [build file resolution](https://github.com/zigtools/zls/blob/295cedd8ddd040c77e6666ddab6ef6da8c0beffa/src/DocumentStore.zig#L290-L301)

But in this setup:

* `common.zig` is used by multiple modules
* each module may have different include paths

ZLS picks one and ignores the others.

So:

* include paths from the “wrong” module are used
* `c.h` can’t be found anymore

Note that compilation works because `common.zig` import in `root.zig` is never used

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

