# ghosu@blog

My blog: Hugo, a homemade terminal theme (Catppuccin Mocha + JetBrains Mono), hosted free on GitHub Pages.
Live at **https://ghosulabs.github.io**. GitHub builds the site, so I can post from the laptop or from any browser.

## First time only
~~~bash
bash ~/Documents/"The Nexus"/Blog/bin/setup
~~~
Installs Hugo, adds the commands, creates the `Ghosulabs/ghosulabs.github.io` repo, turns on Pages and publishes. Then open a new kitty window.

## Commands
| Command | Does |
|---|---|
| `newpost "Title"` | New post in `content/posts/`, opens in micro (`-o` = Obsidian, `-n` = don't open) |
| `preview` | Site at http://localhost:1313 with drafts, updates as I save. Ctrl+C stops it |
| `publish` | Pulls web edits, test-builds, commits and pushes, waits until it's live |
| `publish "message"` | Same, with my own commit message |
| `sync` | Pulls posts written on the web into the vault |

`sync` is an alias in `~/.bashrc`, because `sync` is also a system command. Scripts still get the system one.

## Writing in Obsidian
1. Right-click `Blog/content/posts` → **New note**, name it (the name becomes the title)
2. Command palette → **Templates: Insert template** → **Blog post**
3. Write. Harper underlines grammar and spelling.
4. `publish` in kitty

Post properties:
- **title**: heading on the page, also makes the URL (`/posts/my-title/`)
- **date**: newest first on the site
- **author**: Ghosu (the site falls back to Ghosu if this is empty)
- **description**: one line under the title in the post list
- **tags**: e.g. `[i3, linux]`
- **draft**: `true` hides the post from the live site (`preview` still shows it)

Images go in `content/posts/images/`. Both `![](images/pic.png)` and `![[pic.png]]` work.
Wiki links like `[[Some note]]` show as plain text, since vault notes aren't on the site.

## Writing on the web
- **Pages CMS**: https://app.pagescms.org → sign in with GitHub → pick `ghosulabs.github.io`. Posts, About page and image uploads. Config: `.pages.yml`
- **github.com**: open `content/posts/` in the repo → **Add file** → **Create new file**, paste the properties block from the template at the top

Either way the site rebuilds by itself. Run `sync` back on the laptop before editing there.

## Where things live
| What | File |
|---|---|
| Site settings (title, bio, author) | `hugo.toml` |
| Posts + images | `content/posts/`, `content/posts/images/` |
| About page | `content/about.md` |
| Theme: layout | `themes/ghosu-term/layouts/` |
| Theme: colours, fonts | `themes/ghosu-term/assets/css/term.css` |
| GitHub build | `.github/workflows/hugo.yml` |
| Pages CMS | `.pages.yml` |
| Commands | `bin/` (linked into `~/.local/bin`) |
| Obsidian template | `Templates/Blog post.md` (vault root) |

## Troubleshooting
- **publish says the site didn't build** → read the error, usually a typo in the properties block (missing `"`)
- **"clash" from publish or sync** → the same post was changed on the web and here. `git status` shows which
- **Build failed on GitHub** → `gh run view --log-failed` or the repo's Actions tab
- **Post doesn't show** → `draft: true`? Date in the future is fine; that's allowed
