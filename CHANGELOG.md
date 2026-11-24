<!--
SPDX-FileCopyrightText: 2026 Chris Palmer <chris@red-oxide.org>
SPDX-License-Identifier: MIT
-->

# Changelog

All notable changes to rivet are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Templates and styles extracted from chris.palmerlife.online and made
  site-agnostic: navigation, footer, hero, recent posts, logo and Open Graph
  image come from `[extra.rivet]`.
- `extra.rivet.feed_image`, written as the Atom feed's `<icon>` and `<logo>`
  through an override of Zola's `atom.xml`.
- `extra.rivet.style`, with a new `dugout` style as the default: home plate
  before the title, bases before nav links, tags and `h3`, a stitched baseball
  before `h2`, and stitching along the header, footer, cards and avatar. The
  previous look stays available as `terminal`.
- Every [base24-themes](https://github.com/red-oxide/base24-themes) scheme,
  dark and light, generated into `sass/_palette.scss`. `extra.rivet.theme`
  picks one (default `birdland`); an unknown name fails the build and lists
  the valid ones.
- `nix run .#generate-palette` to regenerate the palette, and flake checks that
  fail when the generated files are stale.
- REUSE compliance: SPDX headers, `REUSE.toml`, `LICENSES/` and a `reuse lint`
  flake check.

### Changed

- References point at the red-oxide GitHub org.
- CI uses the shared workflows in red-oxide/github-workflows.

### Fixed

- `[!IMPORTANT]` and `[!WARNING]` alerts lost their border and label color.
- Pages now declare their color scheme, so browser auto-dark modes no longer
  repaint them.
- In the `dugout` style, post titles in the blog and project lists showed the
  baseball's seams without the ball.
- Stylesheets are cache-busted, so a browser no longer keeps showing an old look
  after a deploy.

[unreleased]: https://github.com/red-oxide/rivet/commits/master
