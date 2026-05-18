---
type: journey-note
title: "Metaphoric vs Oric Remix — deep comparison and decision check"
created: 2026-05-17
status: decision check — confirms §2 of 01-decision-bom-order
related_wiki:
  - "[[OldWer-Metaphoric]]"
  - "[[Board-Folk-Oric-Remix]]"
  - "[[forum.defence-force.org]]"
---

# Metaphoric vs Oric Remix — deep comparison and decision check

> **Purpose:** before any money is spent, confirm that **Metaphoric** (chosen in `01-decision-bom-order.md` §2) is the right board — by deep-reading both GitHub repos and the Defence Force forum, and being honest about where Oric Remix actually wins.
>
> **Verdict up front:** the decision holds. Metaphoric is the correct board *for your brief*. This doc shows the working, including the cases where Oric Remix would be the better answer — none of which match your stated constraints.

---

## 1. The two projects, accurately framed

|  | **Metaphoric** ([[OldWer-Metaphoric]]) | **Oric Remix** ([[Board-Folk-Oric-Remix]]) |
|---|---|---|
| What it is | An **enhanced clone** — memory subsystem redesigned from OriClone-1, new form factor, two PCBs (main + MX keyboard) | A **faithful replica** of the original Tangerine motherboard — ROM/software/form-factor compatible, drops into an original Oric case |
| Author(s) | OldWer (single author) | The Board Folk team (Rob Taylor, Ian Cudlip, Chrissy, Simon Luce) |
| Needs original HCS10017 ULA | Yes | Yes |
| Needs original 6502A / 6522A | Yes (AY-3-8910 alt OK) | Yes (AY-3-8910 alt OK) |
| License | **CC0-1.0** (true public domain) | None declared — README "releases into the public domain, solely for study and historical preservation" |
| EDA tool | KiCAD | KiCAD 9 |
| Latest design work | V2, **April 2025** | **v1.2, May 2026** |
| Keyboard | **Complete MX keyboard PCB in-repo** | None yet — MX replica *planned*; PS/2 prototype works; USB code unfinished |
| Joysticks | 2× DB9 on the keyboard PCB | None on-board |
| Stars / forks | 5 / 0 | 3 / 2 |
| GitHub issues | Enabled (1, closed) | **Disabled** |

Both are remanufacturable PCBs that still need the original NMOS chipset — neither is a "from-silicon" clone. The real difference is **clone vs replica**: Metaphoric is a redesigned machine you build as a standalone unit; Oric Remix is a new-manufacture original board meant to revive a donor Oric.

---

## 2. Scored against your seven constraints (`01 §0`)

This is the part that matters — not a generic feature list, but how each board does against *your* brief.

| # | Your constraint | Metaphoric | Oric Remix | Winner |
|---|---|---|---|---|
| 1 | **Build it yourself** | Through-hole build, two PCBs, full BOM + gerbers + STLs in repo | Through-hole build, gerbers + interactive BOM in repo | tie |
| 2 | **No case needed** | Doesn't need one; STL case provided but optional | Its headline feature is *case-compatibility* — worthless to you | tie (Remix's edge is void) |
| 3 | **Fully functional keyboard, included** | **MX keyboard PCB shipped in-repo** (`MetaphoricKBV2/`, 58 switches) | **No keyboard.** MX replica planned, not released. PS/2 prototype only | **Metaphoric — decisive** |
| 4 | **DB9 joystick ports** | **2× DB9** on the keyboard PCB (IJK "Stingy" + cursor/space), IJK-disable switch | **None** on-board | **Metaphoric** |
| 5 | **Every part open / understand it** | CC0-1.0 — unambiguous public domain | No license file; only a prose "public domain for study" line | **Metaphoric** (CC0 is explicit) |
| 6 | **One machine** | Self-contained two-PCB machine | Designed as a transplant into a donor Oric — implies sourcing a donor | **Metaphoric** |
| 7 | **Through-hole skills, no fine SMD** | All through-hole; AD724 video is the only non-period part, still solderable | All through-hole; AD724 likewise | tie |

**Five ties-or-wins for Metaphoric, zero for Oric Remix against your brief.** Constraint #3 alone is decisive: Oric Remix cannot give you a working keyboard today, and you explicitly required one in the build.

---

## 3. Where Oric Remix genuinely wins (the honest column)

A fair comparison has to name these — otherwise this doc is just confirmation bias.

- **It is the more actively maintained project.** Oric Remix shipped **v1.2 in May 2026**; Metaphoric's last commit is **April 2025** (~13 months ago). If "most recently touched" mattered, Remix wins.
- **A real bug was found and fixed.** Oric Remix v1.1 had a `/ROMDIS` defect — the signal that lets an expansion disable the internal ROM didn't work, which broke LOCI. Simon Luce diagnosed it; v1.2 fixes it and is confirmed working with LOCI. That is a project visibly being tested and corrected.
- **KiCad 9** (current) vs Metaphoric's older, unstated KiCad version.
- **It drops into a real Oric case** with the original keyboard connector in the original position — a genuine strength, just not one you want.

That v1.1 `/ROMDIS` bug raises the one fair worry about Metaphoric: *is Metaphoric stale because it's finished, or stale because too few people have built it to surface a similar latent bug?*

**The forum answers this.** Defence Force thread **`t=2672` ("Loci – First user impressions")** has a builder reporting LOCI tested on **both an original Atmos and a Metaphoric clone**, "happy to say it works with the clone (and its behaviour is identical on both systems)." LOCI exercises exactly the ROM-disable / expansion-bus path that the Oric Remix `/ROMDIS` bug broke. On Metaphoric that path is **empirically confirmed working**. So Metaphoric is stale because it is *done*, not because it is broken. (Metaphoric's own GitHub issue tracker: one issue, closed.)

---

## 4. Community and support network

If you hit trouble mid-build, who can help?

- **Metaphoric:** multiple Defence Force threads with active developer participation — `t=2675` (announcement, Dec 2024) and `t=2733` (V2, Apr 2025), both multi-reply, with OldWer answering questions directly, plus Dbug, Sodiumlightbaby, Bieno and others engaged. LOCI-with-Metaphoric is discussed and confirmed.
- **Oric Remix:** **one** forum thread — `t=2746` "Oric remix ?", ~4 posts, essentially "anyone know this project?" with no build chatter. Combined with **issues disabled** on the GitHub repo, there is effectively no public Q&A surface. If you got stuck, you'd be largely on your own or emailing the authors.

For a first hardware build, a live support network is worth real money. Metaphoric has one; Oric Remix does not yet.

(Note: the forum thread IDs in `00-build-vs-buy-research.md` §13 were inaccurate. Verified IDs: Metaphoric announcement `t=2675`, Metaphoric V2 `t=2733`, LOCI impressions `t=2672`, Oric Remix `t=2746`, OCULA `t=2709`.)

---

## 5. What would flip this decision

Metaphoric is not universally better — it is better *for your brief*. Oric Remix becomes the correct choice if **any** of these change:

1. **You decide you want it in an original Oric case** with the authentic look — Remix is built for that; Metaphoric's keyboard PCB is not.
2. **You're willing to wait months for a keyboard** (or harvest one from a donor Oric) — removes Metaphoric's biggest advantage.
3. **You weight "most recently maintained" over "stable and proven"** — Remix is the live project; Metaphoric is the settled one.
4. **You want to revive/repair a real donor Oric** rather than build a standalone machine — that is literally Oric Remix's purpose.

None of these match the brief in `01 §0`: you want a standalone working machine, no case, a keyboard included now, built once. **So the decision stands — build Metaphoric.**

---

## 6. Conclusion

Going with Metaphoric is the right call, and now a checked one:

- It wins or ties every one of your seven constraints; Oric Remix wins none of them *as your brief is written*.
- Oric Remix's real advantages (active maintenance, a visible bug-fix cycle, case-compatibility) are either irrelevant to you or outweighed by Metaphoric having a keyboard, joysticks, CC0 licensing, and a real support community **today**.
- The one legitimate concern — Metaphoric being 13 months stale — is resolved: forum evidence (`t=2672`) confirms a Metaphoric clone runs LOCI identically to a real Atmos, so it is finished, not abandoned.

No change to `01-decision-bom-order.md`. Proceed with the Metaphoric BOM.

## 7. Decision log

- **2026-05-17.** Deep Metaphoric-vs-Oric-Remix comparison performed (both GitHub repos + Defence Force forum read while logged in). Outcome: **Metaphoric confirmed.** Decision in `01 §2` unchanged.
