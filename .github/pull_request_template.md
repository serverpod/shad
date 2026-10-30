<!--
Thanks for filing a pull request!
-->

*Replace this paragraph with a description of what this PR is changing or adding, and why. Consider including before/after screenshots.*

*List which issues are fixed by this PR. You must list at least one issue. An issue is not required if the PR fixes something trivial like a typo.*

## Testing this PR

<!--
Update the `ref` below with your branch name, then users can test your changes by adding this to their `pubspec.yaml`:
-->
To try this branch, add the following to your `pubspec.yaml`:

```yaml
shad:
    git:
      url: https://github.com/serverpod/shad
      ref: your-branch-name-here
```

## Pre-launch Checklist

- [ ] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [ ] I read and followed the [Flutter Style Guide].
- [ ] I listed at least one issue that this PR fixes in the description above.
- [ ] I updated/added relevant documentation (doc comments with `///`).
- [ ] I added new tests to check the change I am making.
- [ ] I followed the [Data Driven Fixes] where supported.
- [ ] All existing and new tests are passing.
- [ ] Renamed or removed public API keeps a `@Deprecated` shim and has an entry in `lib/fix_data.yaml`.
- [ ] I updated the `CHANGELOG.md` file with a summary of changes made following the format already used.

If you need help, consider asking on [Discord].

<!-- Links -->
[Contributor Guide]: https://github.com/serverpod/shad/blob/main/CONTRIBUTING.md
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Discord]: https://serverpod.dev/discord
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md
