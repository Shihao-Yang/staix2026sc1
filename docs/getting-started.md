# Zero to a working agent, in about ten minutes

For people who have never run a coding agent. This is the setup used for everything in this
repo, and it is deliberately the smallest possible version.

---

## 1. Get an environment (2 minutes)

**Option A, browser, nothing to install.** On any GitHub repo, click the green **Code** button →
**Codespaces** tab → **Create codespace on main**. You get a real Linux machine with VS Code in
a browser tab. The free tier covers roughly 60 hours a month on a 2-core machine, which is far
more than you will use learning this.

**Option B, your own terminal.** Also completely fine. Everything below is identical.

Codespaces is worth knowing about mainly because it makes a *room full of people* identical,
which is why courses use it. Alone, your laptop is fine.

## 2. Install an agent (2 minutes)

Two good options, and nothing in this repo depends on which you pick.

**If you already have a ChatGPT account**, use [Codex](https://developers.openai.com/codex/cli).
It signs in with the account you have, so there is nothing to provision:

```bash
npm install -g @openai/codex && codex
```

**Otherwise** use [Claude Code](https://claude.com/claude-code), which is also what everything
in this repo was built with:

```bash
npm install -g @anthropic-ai/claude-code && claude
```

Either will walk you through signing in on first run. Full login instructions, including how to
supply an API key and what to do when it does not work, are in
[`docs/agent-setup.md`](agent-setup.md).

What matters is the *category*, not the brand: you want the kind that runs in a terminal,
executes code, reads its own errors, and fixes itself. **Not** the Copilot-style completion
pane inside your editor, which is a genuinely different tool and will not do any of this.

## 3. Arrange your screen (30 seconds, matters more than it sounds)

Open a Jupyter notebook, and put the agent's terminal **underneath it**, not beside it.

Vertical stacking reads as a single conversation flowing downward. Side-by-side makes your eyes
jump horizontally between two things that are supposed to be one thing. I taught a two-and-a-half
day course side by side and watched a room lose the thread; this is the cheapest improvement on
the list.

## 4. Your first task should be boring (5 minutes)

Do not open with something impressive. Open with something you already know how to do and
resent doing, because then you can verify the result instantly and you are betting nothing.

The one in this repo, if you want to start without leaving:

> Look at `data/MX_Dengue_trends.csv` and tell me what is in it. Then plot each column over time
> in a small grid so I can see the shape of everything at once.

Fetching data is the demonstration that tends to convert people. It is the chore everyone
dreads and nobody feels expert at, the agent is genuinely good at it, and one plot tells you
whether it worked:

> Download the last five years of weekly US influenza data from CDC FluView, save it as a tidy
> CSV, and plot it.

Then do one against a mess you already have on disk. Something in this shape:

> This folder has one output CSV per simulation run, with the parameter settings encoded in the
> filenames. Combine them into a single tidy table with those settings parsed into real columns,
> and show me the row count per run so I can check nothing was dropped.

Note the last clause. Ask for the number that would expose the failure, not just the result.
That is the habit the rest of this repo is about, and it is worth building from the first task.

---

## Four things that will save you an afternoon each

**Write your environment's facts into a file the agent reads automatically.** Every agent has
this: a plain markdown file at your project root that gets loaded into every session. Codex
reads `AGENTS.md`, Claude Code reads `CLAUDE.md`, and both are just prose, so one file copied
under the other name covers you either way. Put in it the things nobody can derive: this API
rate-limits at ten calls a minute, this column is zero when it means missing, our cluster needs
that module loaded first. Every time you debug something surprising, add it. This is the single
highest-return habit in this document and it compounds weekly.

**Ask for the plan before the action, on anything that writes.** "Show me the table of changes
and do not write anything until I say go." Reads are free. Writes deserve a look.

**Give it a way to check itself.** An agent that can run the tests, see the plot, or read the
error will iterate to something correct. An agent that only emits text into a chat window
cannot. This is most of why terminal agents outperform completion panes.

**Let it fail in front of you.** The instinct is to intervene the moment something breaks. Wait.
Watching an agent read a traceback and fix its own bug teaches you more about what it can and
cannot do than any amount of reading, and it calibrates you fast.

---

## Where to go next

Once the tool feels ordinary, the thing left to learn is how to check its work. That is a
separate skill and it is the subject of the rest of this repo.

- [`prompts/research-dengue.md`](../prompts/research-dengue.md): four prompts that build a real
  forecasting model, plus the follow-up question worth asking after every one of them.
- [`notebooks/01_research_dengue.ipynb`](../notebooks/01_research_dengue.ipynb): that follow-up
  question catching a real silent decision, in a live analysis.
- [`docs/lessons-learned.md`](lessons-learned.md): what worked and what did not, from teaching
  this to a room of epidemiologists, several of whom do not code.
