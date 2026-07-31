# Use case 3 (research, scaled up): hand the whole study to a durable loop

### Shihao Yang &nbsp;·&nbsp; Georgia Tech ISyE &nbsp;·&nbsp; STAI-X 2026 SC01

**Same format as [`00_start_here.md`](00_start_here.md):** scroll it, copy the fenced prompt into the terminal below, and let the agent work. There is no code in this file on purpose. You do not run LoopPlane. You ask your agent to, in plain English, and it runs the commands for you.

Use case 1 was one model in one notebook. This is what happens when you stop supervising each step and give the agent a study to run for days.

---

## The one prompt

Paste this into Claude Code (or Codex) in the folder you want worked on:

```
Use LoopPlane to set up a durable workflow for this project.
Project: <your project folder, or a link to the proposed research plan>
Outcome: <the result you want, or a link to requirements>
Optional: review-gated planning first; do not start execution until I approve.
If LoopPlane isn't here, clone github.com/LJC-FVNR/LoopPlane. Run the commands yourself; give me the dashboard URL.
```

That is the whole interface. Fill in the two angle brackets, keep the last two lines exactly as they are, and send it.

**The two lines people delete, and should not:**

* `review-gated planning first; do not start execution until I approve` is the difference between reviewing a plan and discovering at hour six that it went somewhere you would not have sent it.
* `give me the dashboard URL` is how you get a window into a run you are no longer watching line by line.

**No API key needed.** It drives your existing Claude Code or Codex CLI subscription. LoopPlane itself is Apache-2.0 and its core is Python standard library.

---

## What the agent will do, in order

| Step | What you see |
|---|---|
| install | It clones LoopPlane if the folder is not already there |
| plan | It writes `PROJECT_BRIEF.md` and `PLAN.md`: phases, tasks, and what counts as done for each |
| review | You read the plan on the dashboard, not in the chat scrollback |
| approve | Nothing executes until you say so |
| run | It goes to the background and keeps going after you close the laptop |

---

## Seeing the dashboard

This is the step that trips everyone, for two reasons at once.

* **The dashboard is token-protected.** The bare `host:port` returns a 401. The real link, with `?token=...` on it, is written to `LOOPPLANE_DASHBOARD.url` at the top of your project.
* **In a Codespace, `localhost` is not your browser's localhost.** The URL the agent hands you points inside the container, so it will just look broken.

**The click path:** open the **PORTS** panel next to TERMINAL, find the row for the port, hover it, and click the globe icon. Then paste the `?token=...` part on the end.

**Or the script in this repo,** which does all of that for you. It clones LoopPlane if it is missing, starts the dashboard, steps to the next port if yours is busy, reads the token back out, and prints one URL that works in a Codespace or on your laptop:

```bash
scripts/open-dashboard.sh
```

Point it somewhere else, or share it with the person next to you:

```bash
scripts/open-dashboard.sh --project ~/my-study --port 8765 --public
```

`--public` matters because a forwarded Codespaces port is **private by default**, so anyone else clicking your link gets a login wall rather than your dashboard. Think before you use it: that link carries the token, so anyone with it can read your run.

**If a button gives you `same-origin check failed`,** that is the one snag in this whole setup. Through a forwarded URL you can *read* the dashboard fine, but the buttons that *act* send a POST, and LoopPlane only accepts POSTs whose origin is the host it bound to, so they come back 403. One flag turns that check off and restarts the server:

```bash
scripts/open-dashboard.sh --allow-forwarded-origin
```

**What you are giving up, stated plainly:** that check is CSRF protection, so switching it off means any page in your browser could aim a POST at your dashboard. It would still need the token, which is the actual gate and stays on. I checked: with the flag set, an off-origin POST carrying the token is accepted and one without it is still refused. On your own laptop none of this arises, so do not set the flag there.

---

## Why this is a folder and not a chat

A LoopPlane study is six things on disk, which is the entire argument:

| | |
|---|---|
| `PROJECT_BRIEF.md` | the goal, in plain English |
| `PLAN.md` | phases, tasks, what counts as done |
| `evidence/` | the artifacts each task actually produced |
| `validation/` | per-task and phase-level objective checks |
| `.loopplane/` | an append-only log of everything that happened |
| dashboard | a read-only view of all of the above |

**Two checks, not one, and this is the part worth stealing even if you never install this.** The task validator asks "did this task produce the file it was supposed to?" The objective gate asks "given every piece of evidence so far, is the goal actually met?" Every task can pass and the objective gate can still say not yet. You are not trying to train a more honest agent. You are building a workflow where a dishonest step does not survive a check.

---

## Where the blueprint comes from, and why you already have one

Automation needs a blueprint, and you have written dozens: the grant proposal. Problem statement, the new idea, how to realize it, where the hard parts are, what to try when blocked, fallbacks if a wall will not move. That is exactly what an executable plan needs.

Which flips what a proposal is for. It stops being a chore you write to extract money and becomes the main body of the work, with an objective success test: a good proposal is one you can hand to an agent that executes it end to end, and when it gets stuck it looks the answer up in the proposal.

---

## Honest caveats, because I am asking you to run someone else's code

* **This is third-party software and you are about to let it drive an agent unattended in a folder you care about.** Point it at a scratch copy the first time. I have never had it delete anything, and that is an anecdote, not a guarantee.
* **The plan review is not optional.** The failure mode is not a crash, it is a confident plan solving a slightly different problem than yours, discovered late.
* **A background run bills tokens while you are not watching.** Check the dashboard before you go to lunch, not after.
* **v1.6.0 is young.** Pin what you clone if you are going to depend on it.

---

**Back to:** [`00_start_here.md`](00_start_here.md) &nbsp;·&nbsp; **Repo:** [github.com/LJC-FVNR/LoopPlane](https://github.com/LJC-FVNR/LoopPlane)
