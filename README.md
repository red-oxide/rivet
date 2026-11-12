# rivet

The [Zola](https://www.getzola.org) theme shared by
[chris.palmerlife.online](https://chris.palmerlife.online) and
[red-oxide.org](https://red-oxide.org): a terminal-flavored layout in the
Birdland [base24](https://github.com/red-oxide/base24-themes) palette.

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

Every rivet site shares one palette: `sass/_palette.scss`, the `--base00` …
`--base17` custom properties, generated from a
[base24-themes](https://github.com/red-oxide/base24-themes) scheme (Birdland). To
recolor every site, change `scheme` in `nix/palette.nix`, then:

```sh
nix run .#generate-palette   # writes sass/_palette.scss
```

Sites pick up the change when they move their submodule to the new commit. For
site-only rules, add `sass/site.scss` and set `extra.rivet.site_css = true`.

### Settings

Everything else lives under `[extra.rivet]`; all of it is optional.

```toml
[extra.rivet]
logo = "logo.svg"                                  # shown before the title
nav = [{ name = "about", path = "about/" }, { name = "blog", path = "blog/" }]
footer_links = [{ name = "MIT / CC BY 4.0", path = "license/" }]
not_found_links = [{ name = "blog", path = "@/blog/_index.md" }] # default: nav
og_image = { path = "avatar-512.jpg", width = 512, height = 512 }
hero_image = { src = "avatar-256.webp", src_2x = "avatar-512.webp", size = 128, shape = "round" } # or "square"
recent = { section = "blog/_index.md", count = 5, heading = "Recent posts" }
site_css = false
```

Sites also provide `favicon.ico`, `favicon.svg` and `apple-touch-icon.png` in
`static/`.

### Templates

| Template | For |
| ------------------------------------- | ------------------------------------------------- |
| `index.html` | home: hero from the root section, recent pages |
| `page.html` | plain pages |
| `section.html` | section with its pages listed |
| `blog-post.html` | dated posts with reading time and tags |
| `project.html` | pages that append remote Markdown (`remote_md`) |
| `components.html` | the `remote_md` component (see the file for args) |
| `taxonomy_*.html` | tag lists |
| `nav.html`, `footer.html`, `404.html` | built from `[extra.rivet]` |

A site overrides any of them by putting a file with the same name in its own
`templates/`. `base.html` has an empty `head` block for extra tags.

## License

[MIT](LICENSE)
