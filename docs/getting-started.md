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

```bash
npm install -g @anthropic-ai/claude-code
```

Then start it in your project directory:

```bash
claude
```

It will walk you through signing in on first run. [Codex](https://openai.com/codex) works
comparably; use whichever you have access to.

**Not** the Copilot-style completion pane inside your editor. That is a different kind of tool.
You want the one that runs in a terminal, executes code, reads the errors, and fixes itself.

## 3. Arrange your screen (30 seconds, matters more than it sounds)

Open a Jupyter notebook, and put the agent's terminal **underneath it**, not beside it.

Vertical stacking reads as a single conversation flowing downward. Side-by-side makes your eyes
jump horizontally between two things that are supposed to be one thing. I taught a two-and-a-half
day course side by side and watched a room lose the thread; this is the cheapest improvement on
the list.

## 4. Your first task should be boring (5 minutes)

Do not open with something impressive. Open with something you already know how to do and
resent doing, because then you can verify the result instantly and you are betting nothing.

Good first prompts:

> Look at `data/MX_Dengue_trends.csv` and tell me what is in it. Then plot each column over time
> in a small grid so I can see the shape of everything at once.

> This folder has 200 figures named `fig_1.png` through `fig_200.png`. Rename them using the
> experiment name in the matching `.json` sidecar file. Show me the first ten renames before
> doing any of them.

> Download the last five years of weekly US influenza data from CDC FluView, save it as a tidy
> CSV, and plot it.

The last one is the demonstration that tends to convert people. Fetching data is the chore
everyone dreads and nobody feels expert at, the agent is genuinely good at it, and one plot
tells you whether it worked.

## 5. Learn the one habit that matters

After the agent produces something, ask:

> Walk me through what you just did, line by line. Where did you have to make a choice I did not
> specify? What would break if my data were slightly different?

This is the whole discipline. In [notebook 01](../notebooks/01_research_dengue.ipynb) that
question is what surfaces the fact that the agent silently swapped `log` for `log1p`, because
40% of a column was exactly zero. The patch was correct and the silence was not, and no amount
of prompting for a better model would have revealed it.

---

## Four things that will save you an afternoon each

**Write your environment's facts into a file the agent reads automatically.** A `CLAUDE.md` at
your project root gets loaded every session. Put in it the things nobody can derive: this API
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

- [`prompts/research-dengue.md`](../prompts/research-dengue.md): four prompts that build a real
  forecasting model. Copy them and follow along.
- [`docs/lessons-learned.md`](lessons-learned.md): what worked and what did not, from teaching
  this to thirty people who mostly do not code.
