# Inbox

Drop URLs below under `## Pending`. Run `/pin-llm-wiki run <url>` to ingest a single URL (auto-queues it if missing), or `/pin-llm-wiki run` to batch-process every pending item. Agents may use `/pin-llm-wiki queue <url>` to suggest URLs without immediately ingesting them.

## Pending

<!-- Add URLs here, one per line, as markdown checkboxes.
     Supported inline tags (append each wrapped in HTML comment syntax):
       detail:brief        — override detail level for this source
       detail:standard
       detail:deep
       branch:dev          — GitHub: use this branch instead of default
       clone               — GitHub deep: full git clone to raw/github/<org>-<repo>/
       skip                — skip this URL on the next run
       companion:github.com/<org>/<repo>  — web: use this repo as companion (skip auto-discovery)
       no-companion        — web: suppress companion GitHub fetch even if a repo is found
       note: <text>        — freeform note for human review (ignored by ingest)
-->

<!-- Curated 2026-05-17 against the build decision in build-journey/01-decision-bom-order.md:
     board = Metaphoric V2, original HCS10017 ULA, LOCI storage, OCULA as a later open experiment.
     Items are grouped: ingest the first two groups; the `skip`-tagged group is kept for the
     record but excluded from the next run. Flip a `skip` tag to re-include an item. -->

### Skip — not relevant to the chosen build (kept for the record; remove the `skip` tag to re-include)

- [ ] https://myretrostore.co.uk/product/oric-1-atmos-clone-issue-5-pcb/ <!-- skip --> <!-- note: Kenneth's Issue 5 PCB — rejected: not open source and PCB not orderable -->
- [ ] https://forum.defence-force.org/viewtopic.php?f=11&t=2447 <!-- skip --> <!-- note: Oric Remix forum thread — rejected board option (Metaphoric chosen) -->
- [ ] https://oldcrap.org/2019/12/14/oric-nova-64/ <!-- skip --> <!-- note: Nova 64 teardown — cosmetic/historical only; user dropped the Nova case/badge angle. Soft skip — re-include if you want childhood-machine reference photos -->
- [ ] https://www.986-studio.com/category/retro-computing/oric/replicoric/ <!-- skip --> <!-- note: Replic'Oric — historical 2014 project, not a build candidate -->
- [ ] https://en.wikipedia.org/wiki/Pravetz_(computer) <!-- skip --> <!-- note: Pravetz 8D — was a fallback ULA donor; ULA now sourced from eBay (Nati 99), so background only -->

## Completed

<!-- Processed lines are moved here automatically.
     Format after ingest: - [x] https://... with an "ingested YYYY-MM-DD" HTML comment appended.
     To re-fetch: add a "refresh" HTML comment to the line, then run /pin-llm-wiki run.
     The refresh tag is removed automatically after re-fetch.
-->

- [x] https://github.com/OldWer/Metaphoric <!-- ingested 2026-05-17 -->
- [x] https://github.com/Board-Folk/Oric-Remix <!-- ingested 2026-05-17 -->
- [x] http://oric.free.fr/ <!-- ingested 2026-05-17 -->
- [x] https://www.defence-force.org/ <!-- ingested 2026-05-17 -->
- [x] https://forum.defence-force.org/index.php <!-- ingested 2026-05-17 -->
- [x] https://osdk.org/ <!-- ingested 2026-05-17 -->
- [x] https://library.defence-force.org/ <!-- ingested 2026-05-17 -->
- [x] https://blog.defence-force.org/ <!-- ingested 2026-05-17 -->
- [x] http://www.48katmos.freeuk.com/ <!-- ingested 2026-05-17 -->
- [x] https://github.com/sodiumlb/loci-firmware <!-- ingested 2026-05-17 -->
- [x] https://www.raxiss.com/article/id/38-LOCI <!-- ingested 2026-05-17 -->
- [x] https://github.com/sodiumlb/loci-hardware <!-- note: LOCI hardware design files + project wiki; LOCI is the chosen storage peripheral --> <!-- ingested 2026-05-17 -->
- [x] https://oric.signal11.org.uk/html/diagrom.htm <!-- ingested 2026-05-17 — slug oric.signal11.org.uk -->
- [x] https://forum.defence-force.org/viewtopic.php?f=11&t=2675 <!-- folded 2026-05-17 — "Metaphoric - a new Oric clone"; corrected from wrong t=2268; summarised into wiki/sources/forum.defence-force.org.md -->
- [x] https://forum.defence-force.org/viewtopic.php?f=11&t=2733 <!-- folded 2026-05-17 — "Metaphoric V2"; corrected from wrong t=2398; summarised into wiki/sources/forum.defence-force.org.md -->
- [x] https://forum.defence-force.org/viewtopic.php?f=11&t=2672 <!-- folded 2026-05-17 — "Loci - First user impressions"; corrected from wrong t=2522; summarised into wiki/sources/forum.defence-force.org.md -->
- [x] https://oric.forumactif.org/t945-metaphoric <!-- folded 2026-05-17 — thread login-walled to guests; noted in wiki/sources/forum.defence-force.org.md -->
- [x] https://ceo.oric.org/community/oric-atmos/metaphoric/ <!-- folded 2026-05-17 — summarised into wiki/sources/forum.defence-force.org.md -->
- [x] https://github.com/sodiumlb/ocula-hardware <!-- ingested 2026-05-17 -->
- [x] https://github.com/sodiumlb/ocula-pivic-firmware <!-- ingested 2026-05-17 -->
- [x] https://github.com/sodiumlb/ocula-docs <!-- ingested 2026-05-17 -->
- [x] https://forum.defence-force.org/viewtopic.php?f=11&t=2709 <!-- folded 2026-05-17 — OCULA thread; already summarised in wiki/sources/forum.defence-force.org.md -->
- [x] https://github.com/MiSTer-devel/Oric_MiSTer <!-- ingested 2026-06-21 -->
