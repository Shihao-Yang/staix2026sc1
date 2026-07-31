# STAI-X 2026 SC01 guest segment: repo orientation

This repo is a **15-minute conference talk delivered as one markdown file plus three Jupyter notebooks**. Read this before editing anything here.

## What this is

- **Venue:** STAI-X 2026, short course SC01, *Agentic AI: From Zero to Infinity* (primary instructor Tian Zheng, Columbia). Boston, Friday July 31 2026, 8:00-12:00. Shihao Yang is a **guest speaker**, not an instructor: 15 minutes plus 5 minutes Q&A.
- **Title:** "Out-of-the-Box Agentic AI for Research and Education."
- **Brief from the organizer:** how to use agentic AI such as Claude Code in daily task workflows, how to get started and hit the ground running, two use cases, lessons learned.
- **Audience:** statisticians. Mostly no prior agent experience. They are working in Codespaces during the course.

## Deliberate design decisions (do not undo these without asking)

- **No slides.** `00_start_here.md` and the notebooks replace the deck. This was an explicit choice: they show prompt, code, and result together, which is the talk's thesis. The talk prose is plain markdown at the repo root specifically so it can be edited directly.
- **Notebooks are executed and committed with outputs.** Figures and tables must be visible on GitHub without running anything. If you edit a code cell, re-execute the notebook.
- **Results are real and reported honestly, and every number is recomputed, never asserted.** The research notebook downloads both data sources live (Google Trends via pytrends, cases from OpenDengue) and re-executes. On the 2015-2019 window ARGO beats the AR(3) benchmark by ~10% RMSE with correlation 0.80 to 0.97. That is a genuine result, but it rests on **33 evaluation months**, and the notebook says so rather than rounding the caveat away. If you change the window or the data, re-run and update every quoted figure, including the table in `00_start_here.md`. Never let prose claim a number the notebook does not print.
- **LoopPlane is third-party and never vendored.** `scripts/open-dashboard.sh` clones `github.com/LJC-FVNR/LoopPlane` on demand; `LoopPlane/`, `.loopplane/` and `LOOPPLANE_DASHBOARD.url` are all gitignored. Two facts the script exists to paper over, verified against v1.6.0 on 2026-07-31: the dashboard is **token-gated** (bare host:port is a 401, the real link lands in `LOOPPLANE_DASHBOARD.url`), and it accepts **POSTs only from its bind origin** (`dashboard.py:1175`, no allowed-origins list exists), so through a forwarded Codespaces URL you can read the dashboard but every action button 403s. The escape hatch is `--allow-forwarded-origin`, which sets `same_origin_required` false in the workflow's `config/security.json` and restarts. That is CSRF protection, not the auth gate: the token is still required, verified against v1.6.0 by POSTing off-origin with and without one (202 and 401). If any of this changes upstream, fix the script and the caveat in `03_loopplane_research_loop.md` together.
- **No student data.** The roster in notebook 02 is fabricated with the real structure and none of the real people. The actual reading group has ~28 named students; their names and addresses must never enter this public repo.
- **`logs/` is gitignored** and may contain personal context from the authoring sessions.

## Layout

```
00_start_here.md                            the talk itself, at repo root. Written to be
                                            SCROLLED THROUGH LIVE with a terminal below it:
                                            title-and-bullet sections, terse lines, and every
                                            prompt in a fenced block so it can be copied
                                            straight into the terminal. Do not turn these back
                                            into flowing paragraphs. Ends with the long-form
                                            SISMID appendix.
notebooks/01a_research_data.ipynb           use case 1 part A, hands-on: live downloads,
                                            then interrogate what came back. Slow and
                                            failure-prone ON PURPOSE.
notebooks/01b_research_model.ipynb          use case 1 part B, hands-on: modeling. Starts from
                                            PRE-FETCHED data so it never waits on the network.
                                            Split from A so two Claude sessions can run in
                                            parallel in a 15-minute slot. Keep them independent.
notebooks/01_research_soln.ipynb            use case 1, worked: both halves, executed
02_education_reading_group.md               use case 2, at repo root. Same scroll-and-copy
                                            format as 00_start_here.md. Runs against the author's
                                            real Outlook, so it is driven from his laptop, not a
                                            Codespace. Deliberately NOT a notebook: there is no
                                            code to execute, only prompts.
03_loopplane_research_loop.md               use case 3, at repo root. Same scroll-and-copy format.
                                            ONE prompt (taken verbatim from slide 2 of "AI Agent
                                            for Research.pptx") that hands a whole study to
                                            LoopPlane. Deliberately NOT a notebook: no code to
                                            execute, and the audience runs it on their OWN project.
scripts/                                    secret-encrypt.sh, claude-login.sh, open-dashboard.sh
secrets/                                    encrypted class credential + its README
data/                                       MX_Dengue_trends.csv is the old SISMID curated
                                            file, kept only as the thing the live download is
                                            checked against. gt_dengue_mx.csv and
                                            opendengue_mexico_monthly.csv are download caches
                                            so the notebook still runs without network.
```

**There is no `docs/` and no `prompts/`, deliberately.** Every prompt lives in the notebook that uses it, and the prose lives in `00_start_here.md`. Both directories existed and were folded in, because a separate copy of a prompt is a copy that drifts. Do not reintroduce them.

## Rebuilding the notebooks

`01_research_soln.ipynb` was generated by `build_*_nb.py` scripts (gitignored scaffolding, kept locally) and then executed:

```bash
.venv/bin/jupyter nbconvert --to notebook --execute --inplace notebooks/01_research_soln.ipynb
```

For small text fixes, edit the `.ipynb` directly rather than regenerating. Note that the generator scripts still write to the pre-split filenames, so check the output path before running one.

## Source material this was distilled from

- `~/Workspace/sismid2026/` is the SISMID 2026 short course. `agentic-ai-teaching-lessons.md` (in Chinese) is the primary lessons-learned source; the appendix at the bottom of `00_start_here.md` is the English port aimed at this different audience.
- `~/Workspace/sismid2026/course-repo/` is the SISMID course repo, source of the dengue data and the two-lane (prompt / worked-solution) notebook pattern.
- `~/Workspace/agentic-ai-presentations/skills/` holds the sourced digests of Anthropic's Agent Skills docs, and `skills-reading-group.tex/.pdf` is the 16-frame deck generated from them. That is the real artifact behind the education file's first demo.
- **Canvas is deliberately gone.** The education segment used to lead with the Canvas REST API and the hand-written 2024 scripts in `~/Workspace/canvas/`. It was dropped: slide generation and mailing-list work demo better in the time available. Do not reintroduce it.

## Writing conventions

- **Claude Code only.** Codex, ChatGPT and `AGENTS.md` were deliberately removed: the talk is 15 minutes and the course provides Anthropic keys, so a second toolchain is time the author does not have. Do not reintroduce them.
- **Prompts must sound like a person typed them, not like a specification.** Lowercase, comma-spliced, no backticks inside the prompt, no exhaustive filenames. "get me google trends for mexico, monthly, going back as far as it lets you" is right; "Download monthly Google search interest in Mexico for `dengue`, ... over the longest window it will give me in one request" is wrong. The reason is not style: a prompt that reads as agent-authored makes a reader think "I would never write that", and that distance is exactly what stops people using these tools. Prompts are also kept **identical** across the hands-on notebooks and the worked one; they have drifted apart twice already.
- **No em dashes** in any English prose here (a standing preference of the author).
- **Soft-wrap, do not hard-wrap.** Every paragraph and bullet is ONE long line, in the markdown files and in notebook markdown cells alike. This is deliberate: the author presents by scrolling the markdown in an editor and resizes the window, so the text must reflow to whatever width is set. Do not reintroduce fixed-column line breaks. Code fences, tables, and headings are exempt and stay as they are.
- Prose over bullet fragments in the notebooks. These are read aloud and read later.
- Do not oversell. The talk's credibility rests on stating the caveats out loud: the coverage gaps, the changing case definition, and the small evaluation sample.
