# Oric retro computer wiki — agent instructions

> **Created:** 2026-05-17 | **Detail level:** standard (default; per-source overrides via `<!-- detail:X -->` inbox tags)

---

## For AI agents working in this repo

Before answering **any question** about Oric retro computer, you MUST:

1. Read `wiki/index.md` to identify relevant pages.
2. Follow `[[wikilinks]]` to drill into relevant source pages.
3. For hardware, technical, or sound questions, also consult the **Defence Force forum digest** (see below).
4. Cite wiki page names in your answer.
5. If the answer is not in the wiki or digest, say so clearly, then fetch current information online instead of relying on training data alone.

This wiki is the authoritative local source for this domain. Start with the wiki, use it whenever it covers the question, and go online for gaps or newer information rather than filling them from training data alone.

---

## Defence Force forum digest

A structured knowledge base of forum threads from `forum.defence-force.org`, maintained as a separate project.

**Location:** `/Users/nenaddjordjevic/LLMProjects/oric-forum-digest/digests/`

Each subforum is a directory. List the directories to discover available subforums. Each directory has an **`index.md`** listing all topics with digest links. Individual digest files are named `<topic-id>-<slug>.md` and follow a consistent structure: _Question/goal_, _Outcome_, _Key facts_.

**When to consult the digest:**

- Hardware troubleshooting, repair, or component compatibility questions.
- Clone board questions (Metaphoric, OriClone-1, Oric Remix, Replic'Oric, etc.).
- Storage peripherals (Microdisc, Cumulus, LOCI, Erebus, Cumana, etc.).
- Video output, ULA replacement, or signal questions.
- AY sound chip programming or hardware audio questions.
- Sourcing or identifying period-correct components.

**How to use:**

1. Check the relevant subforum `index.md` to find matching topic(s).
2. Read the topic digest file(s) for facts and community consensus.
3. Cite the digest file path and topic ID in your answer (e.g., `hardware-hacks/1149-oric-atmos-from-scratch.md`).

> **Wiki management:** Use `/pin-llm-wiki` (`init`, `run`, `lint`, `queue`, `remove`) to ingest sources and manage this wiki. The skill runs in Claude Code, Cursor, and GitHub Copilot — full workflow instructions live in the skill files.

---

## Git — never auto-commit

**Do not** run `git commit` or `git push` after ingest, refresh, `run`, `lint`, `remove`, initial wiki scaffold, or any other file change in this repo—**unless the human explicitly asked you to commit or push in this conversation.**

When work is done, list what changed and stop; the human reviews diffs and runs `git commit` / `git push` when ready.

---

## Wiki structure

```
wiki/
  index.md          ← start here; lists every page, counts sources
  overview.md       ← rolling cross-source overview (cites [[source pages]])
  log.md            ← append-only record of every ingest/refresh
  sources/          ← one page per ingested source (<slug>.md)
  .archive/         ← soft-deleted sources (ignore unless needed)

raw/
  README.md
  [github/]         ← immutable GitHub repo captures
  [youtube/]        ← immutable YouTube video captures (transcript + metadata)
  [web/]            ← immutable web page/site captures
  assets/           ← downloaded media/binaries

inbox.md            ← agents may add to ## Pending via `queue`; all other edits are human-driven
.pin-llm-wiki.yml   ← config (detail level, source types, lint cadence, etc.)
```

**Load order for any question:** `wiki/index.md` → relevant source pages → raw files only for direct citation.

### GitHub fetch protocol

**Trigger:** inbox URL matches `github.com/<org>/<repo>`.
**Tool:** `gh` CLI.

Steps:

1. `gh repo view <org>/<repo> --json name,description,url,homepageUrl,stargazerCount,forkCount,pushedAt,primaryLanguage,licenseInfo,defaultBranchRef` — capture metadata and default branch name.
2. `gh release list --repo <org>/<repo> --limit 1` — capture latest release tag.
3. `gh api repos/<org>/<repo>/readme` — base64-decode and capture full README.
4. `gh api repos/<org>/<repo>/contents/` — top-level structure listing.
5. If `docs/` exists: list contents + fetch key files (guides, architecture, testing, overview).
6. If `examples/` exists: list structure only (do not fetch full example files unless `deep`).
7. Skim other top-level folders; annotate important ones (source/lib, plugin manifests, tests, agent instruction files `CLAUDE.md` / `AGENTS.md` / `GEMINI.md`); skip boilerplate (`.github/`, `node_modules/`, lock files).
8. Compile into a single file and save to `raw/github/<org>-<repo>.md`.
9. Use `defaultBranchRef.name` from step 1 as the branch. **Never assume `main`.** Override with `<!-- branch:X -->` inbox tag if present.
10. At `deep` detail with `<!-- clone -->` inbox tag: `git clone https://github.com/<org>/<repo>.git raw/github/<org>-<repo>/` (this path is gitignored; full clone tree for deep citation).

**Guard:** if the repo fetch would exceed 200k input tokens, halt and surface to the user before proceeding.

**Raw file format** (`raw/github/<org>-<repo>.md`):
```
# <org>/<repo>

## Metadata
- Stars: <N>
- Primary language: <lang>
- Default branch: <branch>
- Latest release: <tag> (<date>)
- License: <license>
- Homepage: <url>
- Fetched: <YYYY-MM-DD>
- Final URL: <url>

## Description
<description>

## README
<full readme content>

## Docs
<fetched doc files, one section each>

## Top-level structure
<annotated directory listing>
```

Notes:
- `## README` is the fetched README content itself, not a paraphrase, rewrite, or condensed summary.
- `## Docs` is required whenever docs or other key repo docs were fetched during the protocol. Include the fetched content you relied on, organized one section per file/listing.
- `## Top-level structure` should remain an annotated directory listing, but annotation must stay grounded in the fetched listing.

**README.md row format** (`raw/github/README.md`):
`| raw/github/<org>-<repo>.md | <org>/<repo> | <stars> | <default-branch> | <latest-release> | <YYYY-MM-DD> | |`

### YouTube fetch protocol

**Trigger:** inbox URL matches `youtube.com/watch?v=` or `youtu.be/`.
**Tool:** `yt-dlp`.

Steps:

1. `yt-dlp --dump-json <url>` — one call; captures description, chapters, title, channel, duration, upload date, video ID. No download.
2. Transcript: `yt-dlp --write-auto-sub --skip-download --sub-lang en-orig <url>`
   - Prefer `--sub-format srt` when available.
   - Fall back to `--sub-format vtt` if SRT unavailable.
   - Prefer `en-orig` (unprocessed captions) over `en` (auto-translated).
3. Parse subtitles:
   - **SRT format:** use standard cue text per block. Join consecutive cues that belong to the same sentence.
   - **VTT rolling-caption format:** each cue has 2 lines; the last line is live/partial. Strategy: take the **first clean line per cue** (strip `<c>` timing tags). Deduplicate consecutive identical lines. Group transcript text by chapter heading (from step 1 `--dump-json` chapters array).
4. Save to `raw/youtube/<video-id>-<slug>.md`.
5. **Fallback:** if no transcript track exists at all, flag the inbox line `<!-- fetch-failed:no-transcript -->` and skip (do not mark `[x]` or move to Completed).

**Guard:** if the video transcript would exceed 200k input tokens during ingest, surface to user before proceeding.

**Slug generation:** lowercase title, replace spaces/special chars with hyphens, truncate at 40 chars.

**Raw file format** (`raw/youtube/<video-id>-<slug>.md`):
```
# <title>

## Metadata
- Video ID: <id>
- Channel: <channel>
- Duration: <MM:SS or HH:MM:SS>
- Upload date: <YYYY-MM-DD>
- URL: <url>
- Fetched: <YYYY-MM-DD>

## Description
<full description text>

## Chapters
| # | Title | Timestamp |
|---|---|---|
<chapter rows>

## Transcript

### <Chapter 1 Title> (0:00)
<cleaned transcript text>

### <Chapter 2 Title> (MM:SS)
<cleaned transcript text>
...
```

**README.md row format** (`raw/youtube/README.md`):
`| raw/youtube/<video-id>-<slug>.md | <title> | <channel> | <duration> | <upload-date> | <YYYY-MM-DD> | |`

### Web fetch protocol

**Trigger:** inbox URL does not match github.com or youtube patterns.
**Tool:** `WebFetch` (primary). Fallbacks: Jina Reader (`r.jina.ai/<url>`) or headless browser only if WebFetch returns a content-free skeleton.

**Verbatim-capture rule (critical for product discovery):** WebFetch passes the page through a small summarizer model. Even with explicit "do not summarize" instructions, it may still paraphrase prose and silently drop "redundant" entries from product menus, nav lists, and structured catalogs — the exact signals product discovery (Step 5) depends on. The directive helps but is not a guarantee. Two rules follow:

1. **For HTML pages (landing page, docs index, individual docs pages):** every WebFetch prompt **must** include: *"Return the page content verbatim. Preserve every product name, navigation entry, link, and list item exactly as it appears. Do not summarize, paraphrase, deduplicate, or filter for relevance."*
2. **For plain-text structural catalogs (`llms.txt`, `sitemap.xml`):** do **not** use WebFetch — its summarizer will mangle the catalog. Fetch with `curl -sL <url>` via Bash and store the raw response. These files are the only fully reliable product-enumeration source, so they must survive intact.

**Special case — GitHub non-root pages:** when the URL is `github.com/<org>/<repo>/<...>` (for example `/tree/...`, `/blob/...`, `/issues/...`), this protocol runs in **single-page mode**. The intent is to capture only the requested GitHub page, not the whole repository.

Steps:

1. **Check whether the URL is a GitHub non-root page.**
   - **If yes:** skip steps 2–6 below entirely. Fetch only the exact URL and store it as a one-page raw capture. Do **not** fetch `llms.txt`, do **not** discover docs pages, and do **not** discover a companion GitHub repo or run product discovery. Return `companion_github_url = null`, `products = []`. Skip ahead to step 8 (write).
   - **If no:** continue with step 2.
2. **Check `<domain>/llms.txt`** — fetch with: `curl -sL https://<domain>/llms.txt -o /tmp/pin-llm-wiki-llmstxt-<slug>.txt`. **Do not** invoke WebFetch on llms.txt — the WebFetch summarizer mangles it. Always go through the on-disk file.

   After curl, `cat /tmp/pin-llm-wiki-llmstxt-<slug>.txt | wc -c` to verify a non-empty response. If empty / 404 / not-found-style HTML, treat llms.txt as absent and skip to step 3.

   **The on-disk file is the canonical capture.** When step 8 assembles the raw file, the `## llms.txt — <url>` section is produced by **reading** `/tmp/pin-llm-wiki-llmstxt-<slug>.txt` and inserting its contents verbatim. Do not retype the content from memory; do not summarize; do not "list relevant entries." If you find yourself paraphrasing the catalog, stop — read the on-disk file again and paste those bytes literally. Step 5 discovery operates on this raw section; if it has been summarized, DeepAgents-class entries are silently dropped and discovery can never recover them.

   llms.txt is the primary product-discovery signal in Step 5; every line must reach Step 5 unfiltered. llms.txt supplements but does **not** replace steps 3–5.
3. **Fetch the landing page** (`<final-url>`). Capture verbatim. In particular, preserve the literal text of the hero section, primary nav, "Products" / "Frameworks" menus, product cards, and footer link blocks — these enumerate products that may not appear anywhere else. Paraphrased summaries of these elements are insufficient for Step 5.
4. **Discover docs pages** — always, regardless of whether llms.txt was found. Try `/docs`, `/documentation`, `/guide`, `sitemap.xml`, and the conventional subdomain `docs.<domain>` (in that order). Stop at the first that returns real content. For `sitemap.xml`, fetch with `curl -sL` (it is a structural catalog like llms.txt). For HTML docs pages, use WebFetch with the verbatim directive — capture the full top-level navigation tree, every section heading and link, not a paraphrase. Top-level docs sections are the strongest product-discovery signal.
   - At `brief`: skip docs entirely.
   - At `standard`: fetch the docs index page and ~4–10 key pages (product overviews, getting-started, architecture, reference).
   - At `deep`: fetch the docs index page and ~10–25 key pages, then run product discovery (step 5) and per-product docs fetch (step 6).
5. **Product discovery** (`deep` only — skipped at `brief`/`standard` and in single-page mode). The goal is to determine whether this site presents **multiple distinct products** that each merit their own wiki source page.

   Scan, in priority order:
   a. The docs nav/landing of the docs site discovered in step 4 — top-level sections that point to distinct product subsections.
   b. The landing page hero/nav and footer for product-card lists, "Products" menus, or repeated `<product>.<domain>` subdomains.
   c. The llms.txt content from step 2 — distinct product entries point to distinct products.
   d. GitHub repo URLs referenced anywhere in the captured content.

   **Multi-product trigger:** `len(products) >= 2`. If `len(products) < 2`, set `products = []` and proceed in single-product deep mode.
6. **Per-product docs fetch** (deep multi-product only).
7. **Companion GitHub repo discovery** (brief/standard/single-product deep only).
8. **Compile and write the raw file** at `raw/web/<slug>.md`.
9. **Follow redirects; log the final URL** to the raw file.
10. Respect `robots.txt`. Set a descriptive user agent. Rate-limit between requests.

**README.md row format** (`raw/web/README.md`):
`| raw/web/<slug>.md | <slug> | <pages-fetched> | <YYYY-MM-DD> | |`
