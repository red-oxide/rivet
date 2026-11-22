# rivet

The [Zola](https://www.getzola.org) theme shared by
[chris.palmerlife.online](https://chris.palmerlife.online) and
[red-oxide.org](https://red-oxide.org): a terminal-flavored layout in the
[base24-themes](https://github.com/red-oxide/base24-themes) palettes.

## Using it

Add it as a submodule and name it in `zola.toml`:

```sh
git submodule add https://github.com/red-oxide/rivet.git themes/rivet
```

```toml
theme = "rivet"
compile_sass = true
```

Cloudflare Pages checks out submodules on its own. In GitHub Actions, use
`actions/checkout` with `submodules: true`.

### Colors

rivet ships every [base24-themes](https://github.com/red-oxide/base24-themes)
scheme, dark and light: `sass/_palette.scss` holds a block of `--base00` …
`--base17` custom properties per scheme, and `<html data-theme="…">` picks one.
Each site sets its default with `theme` and `mode` (see Settings), and a picker
in the header lets visitors choose another family and switch between light and
dark. Their choice is saved in `localStorage`, per site. Without JavaScript,
visitors see the site's default.

The palette and the picker's list (`templates/theme-options.html`) are generated
from the `base24-themes` flake input; `nix flake check` fails if they are stale.
After `nix flake update base24-themes`:

```sh
nix run .#generate-palette   # writes sass/_palette.scss and templates/theme-options.html
```

Sites pick up new schemes when they move their submodule to the new commit. For
site-only rules, add `sass/site.scss` and set `extra.rivet.site_css = true`.

### Settings

Everything else lives under `[extra.rivet]`; all of it is optional.

```toml
[extra.rivet]
style = "dugout"                                   # or "terminal"; see Styles
theme = "birdland"                                 # default family: birdland, blue-crab, eastern-shore, harbor, red-oxide, spangled
mode = "dark"                                      # or "light", or "auto" to follow the visitor's system
theme_picker = true                                # theme picker and light/dark toggle in the header
logo = "logo.svg"                                  # shown before the title
nav = [{ name = "about", path = "about/" }, { name = "blog", path = "blog/" }]
footer_links = [{ name = "MIT / CC BY 4.0", path = "license/" }]
not_found_links = [{ name = "blog", path = "@/blog/_index.md" }] # default: nav
og_image = { path = "avatar-512.jpg", width = 512, height = 512 }
feed_image = "avatar-512.jpg"                      # Atom feed <icon> and <logo>; square PNG/JPEG
hero_image = { src = "avatar-256.webp", src_2x = "avatar-512.webp", size = 128, shape = "round" } # or "square"
recent = { section = "blog/_index.md", count = 5, heading = "Recent posts" }
site_css = false
```

### Styles

`style` picks the marks around the same layout and palette:

- `dugout` (default): home plate before the title, bases before nav links and
  tags, a baseball before `h2`, and stitching along the header, footer, cards
  and avatar.
- `terminal`: shell prompts — `~/`, `./`, `$`, `#`/`##`/`###` and `[…]`.

The page's `<body>` carries `rivet-<style>`, so `site.css` can target either.

Sites also provide `favicon.ico`, `favicon.svg` and `apple-touch-icon.png` in
`static/`.

### Templates

| Template | For |
| ------------------------------------- | --------------------------------------------------- |
| `index.html` | home: hero from the root section, recent pages |
| `page.html` | plain pages |
| `section.html` | section with its pages listed |
| `blog-post.html` | dated posts with reading time and tags |
| `project.html` | pages that append remote Markdown (`remote_md`) |
| `components.html` | the `remote_md` component (see the file for args) |
| `atom.xml` | Zola's feed, plus `feed_image` as `<icon>`/`<logo>` |
| `taxonomy_*.html` | tag lists |
| `nav.html`, `footer.html`, `404.html` | built from `[extra.rivet]` |
| `theme-picker.html` | the header's theme picker and light/dark toggle |

A site overrides any of them by putting a file with the same name in its own
`templates/`. `base.html` has an empty `head` block for extra tags.

## License

[MIT](LICENSE)
