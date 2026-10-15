## [Unreleased]

## [0.2.0] - 2026-10-15

- Add `Otoindiff::Disabled` refinement to opt a single class out of indifferent
  access (`using Otoindiff::Disabled`) while the rest of the code base keeps it.
- Fix i18n lookups always returning "Translation missing": hashes with a default proc
  (such as the i18n backend's translations store) now receive the caller's key instead
  of a converted one, so entries are no longer stored under the wrong key type.
- Fix `fetch` with a default value or block ignoring a key stored as the other type
  (`{ foo: 1 }.fetch('foo', 0)` now returns `1`).
- Fix `dig` returning `nil` when traversing into arrays or other non-Hash objects.
- Fix `false` values being returned as `nil` when accessed with the other key type.

## [0.1.0] - 2024-12-12

- Initial release
