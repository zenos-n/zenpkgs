# Search metadata

The archive and [ZenPkgs Search](https://github.com/zenos-n/zenpkgs-search)
provide package versions, outputs/default output, binaries, desktop applications,
homepage, licenses, maintainers, platforms, security flags and revision-specific
definition links. Option records include type descriptions, documented defaults,
examples, read-only status and declarations. Containers remain searchable in
addition to their child options. False and null are not treated as missing data.

`scripts/gen-archive.nix` stays a data-only schema exporter. The separate
`scripts/search-package-manifest.nix` evaluates each provider behind `tryEval`
and `deepSeq`, then `scripts/enrich-search.py` scans existing outputs or binary
cache listings. Neither command builds package outputs. The DSL compiler bundle
can still be built as part of evaluating the flake.

The enrichment pass resolves symlinked bin directories, scans all outputs and
excludes hidden wrapper implementation executables. Desktop files supply icons;
AppStream supplies component identities, screenshots and captions. The binary
cache reader is the independently maintained NixOS Search scanner at commit
`2167f7df098eb0c10c82dbe71eeb52f8d8d1b393`. CI checks it out separately; no source
or artwork is vendored in ZenPkgs. See its
[implementation](https://github.com/NixOS/nixos-search/blob/2167f7df098eb0c10c82dbe71eeb52f8d8d1b393/flake-info/scripts/desktop-entries-index.py)
and [MIT attribution](https://github.com/NixOS/nixos-search/blob/2167f7df098eb0c10c82dbe71eeb52f8d8d1b393/COPYING).

Generated content-addressed icons and screenshot thumbnails/full-size previews
are published under `artwork/` on the data-only `json` branch. Original screenshot
URLs are retained for attribution. Screenshot download failures retain the
upstream URL; the UI hides an image that fails to load. Existing archive artwork
is retained so released catalogs keep working. Cached inventories can only be
reused when the complete list of Nix output store paths matches exactly.

Flathub's public [AppStream catalog](https://dl.flathub.org/repo/appstream/x86_64/appstream.xml.gz)
also provides reference graphics, matched only by exact component ID (the
canonical package ID or a shipped metainfo/desktop filename). The UI labels
their Flathub source and release version; those images can describe a different
release. Binary inventories and all package facts still come exclusively from
the actual Nix outputs/evaluation. This improves graphics coverage for uncached
builds. Shipped graphics retain priority. Available desktop/metainfo files are
still read from the actual NAR even when reference artwork exists, so graphics
enrichment never replaces exact launcher metadata. Reading such files can
require downloading a large application archive during indexing.

Search data publication has its own search-export checks and runs independently
of compiled-source publication and unrelated package build checks.

`scripts/search-popularity.py` reads instantiated derivations without building
outputs. It reports direct build-input counts, direct dependent counts within
the exposed ZenPkgs catalog, and links to dependencies present in that catalog.
Derivation aliases do not multiply counts. These are not counts across all
Nixpkgs; the UI explicitly labels the population. Nix 2.34's versioned JSON and
the older derivation JSON encoding are both accepted.

Repology repository counts use its `nix_unstable` native `srcname`, matched to
the recorded registry import path, never a guessed software/project name.
The crawler follows the matching/rate-limit semantics in the MIT
[NixOS Search implementation](https://github.com/NixOS/nixos-search/blob/2167f7df098eb0c10c82dbe71eeb52f8d8d1b393/flake-info/src/commands/repology.rs),
counts distinct repositories, waits at least one second between pages, honors
bounded retry delays and caches a completed map for 24 hours. The fetch date is
retained. External failure leaves unknown counts absent.

## Coverage and limits

The package inventory is system-specific (`metadata.packageEnrichment.system`).
`binaryStatus` distinguishes `complete`, `partial`, and `unavailable`; an absent
`programs` field means unknown, while an empty list with complete coverage means
no executables. `artworkStatus` distinguishes `indexed`, `no-entries`, and
`unavailable`. A cache miss, failed provider or file read cannot silently become
"this application has no icon". AppStream screenshots cannot be supplied for an
application that ships none. Files that only exist inside a remote NAR require
downloading that NAR during indexing, not when someone searches.

Unsafe or configuration-dependent defaults remain explicitly unavailable;
upstream mirrors retain `defaultText`, examples and declarations as documentation
without importing upstream runtime defaults. Placeholder defaults and recursive
type schemas keep their existing safety bounds. `traversal` and the archive's
`limits` expose truncated schemas. The archive is an overview of the exposed ZSTR
surface, not a claim that every NixOS/Home Manager option was fully traversed.

This matches the detail categories in NixOS Search and adds ZenOS dependency,
category, scope and coverage metadata. It does not promise information which the
package does not provide or which cannot safely be evaluated.

## Verification

```sh
python3 tests/search/test-enrichment.py
nix build --no-link .#checks.x86_64-linux.search-index
```

The search frontend additionally checks unsafe URL rejection, literal examples,
false/null values, command-name search and option containers, and exercises
details/screenshots in its Chromium and Firefox browser suite.

Indexing cost was measured with four fixed real cache NARs (1.48 MB total),
three cold local-cache runs each, Python 3.13.15 and the scanner revision above.
A global download lock took 1.147/1.110/2.030 seconds; locks per NAR took
0.353/0.351/0.350 seconds (median 1.147 → 0.351). Kept per-NAR locking: distinct
archives can run concurrently while one archive's parsed cache has one writer.
This measures the cache reader, not an end-to-end website speedup.
