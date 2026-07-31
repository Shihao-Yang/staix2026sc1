# Out-of-the-Box Agentic AI for Research and Education

### Shihao Yang &nbsp;·&nbsp; Georgia Tech ISyE
**STAI-X 2026, SC01: *Agentic AI: From Zero to Infinity*** &nbsp;·&nbsp; Boston, July 31, 2026
&nbsp;·&nbsp; guest segment, 15 minutes + Q&A

---

There are no slides for this segment. You are looking at the talk. The deck is a repo, the repo runs, and you can have it:

> ### `github.com/Shihao-Yang/staix2026sc1`
> Open in a Codespace, or clone it. Everything here executes.

---

## Where I am coming from

I am not an agent researcher. I am a statistician who forecasts epidemics from internet
search data, and who got tired of the parts of that job that are not statistics.

- My first paper, [ARGO](https://www.pnas.org/doi/10.1073/pnas.1515373112) (*PNAS* 2015),
  used Google search volume to nowcast influenza.
- I taught a Statistics and Modeling in Infectious Diseases (SISMID) short course this July where roughly 15 epidemiologists, some of whom
  did not write code, used coding agents for two and a half days. That course is where most
  of what follows was learned.

Tian asked me to talk about getting started and hitting the ground running. Rather than slides, I think a live demo serve the purpose better. I have two examples, the primary one is for research, the secondary one is for education.

## The setup, in full

I want to be concrete about how little there is, because the *perceived* setup cost is the main
thing keeping people out. This is the whole stack, and we will do it live.

### 1. An environment

A [GitHub Codespace](https://github.com/features/codespaces): a real Linux machine in a browser
tab, free tier, nothing to install. Click the green **Code** button on any repo, choose the
**Codespaces** tab, and create one. The free allowance is roughly 60 hours a month on a 2-core
machine, far more than you will use today.

At SISMID the whole room was running inside ten minutes, on their own free accounts, at zero
cost to me. Codespaces earns its place mainly because it makes *a room full of people
identical*. Working alone, your own terminal is just as good.

### 2. A terminal agent

One `npm` command either way.

**If you already have a ChatGPT account**, use [Codex](https://developers.openai.com/codex/cli)
and sign in with it. Nothing to provision:

```bash
npm install -g @openai/codex && codex
```

**Otherwise** use [Claude Code](https://claude.com/claude-code), which is what everything in
this repo was built with, and the one I can actually help you with in the room:

```bash
npm install -g @anthropic-ai/claude-code && claude
```

Deliberately **not** the Copilot pane built into your editor. That is a genuinely different
tool: terminal agents run code, read the errors, and fix themselves, and watching that loop is
most of the point.

### 3. Logging in

**Codex** signs in with the ChatGPT account you already have. Run `codex`, and in a Codespace
it prints a URL rather than opening a browser: open it in a normal tab, approve, come back.

**Claude Code** uses the API key from Tian's course workspace (Settings, then API keys, at
[platform.claude.com](https://platform.claude.com); it is shown **only once**, so save it):

```bash
export ANTHROPIC_API_KEY='sk-ant-...'
```

Append that same line to `~/.bashrc` and it survives new terminals and a Codespace restart.

**If the key does not work**, there is a shared class token in this repo, encrypted, that I
unlock with a passcode I will say out loud:

```bash
source scripts/claude-login.sh
```

Use `source`, not `bash`, or the variable lands in a subshell that exits immediately and
nothing sticks. Then:

```bash
claude --dangerously-skip-permissions
```

Two warnings on that. **Start it in the terminal, not the VS Code Claude panel**: in a
Codespace the panel loads before you unlock, cannot see the token, and will offer you a login
screen that signs you into your own account instead. And the flag lets the agent read, edit and
run commands without stopping to confirm each one, which I use in demos deliberately so you see
what an agent does uninterrupted. It is fine here because a Codespace is disposable. **Do not
make a habit of it on your own machine.**

### 4. One notebook, stacked *below* the agent

The agent writes directly into the notebook, so you read markdown, code, figures and tables in
one column.

**Stack them vertically, not side by side.** This sounds trivial and is not. I ran
side-by-side for two days at SISMID and watched people saccade left and right until they lost
the thread. Top and bottom reads as one conversation flowing downward.

---

That is the entire stack. No orchestration framework, no vector database, no multi-agent
anything. **Everything in this repo was produced with the plainest possible use of a single
agent**, and I want to be clear about that, because at a workshop called *From Zero to
Infinity* it is easy to conclude you need to be near infinity before you start. You do not.
The unglamorous end of this technology is where nearly all of my actual value has come from.

## Your first hour, once it is running

### Start with a boring task, not an impressive one

Open with something you already know how to do and resent doing. Then you can verify the result
instantly and you are betting nothing. Trying to be impressed on day one is how people conclude
it does not work.

The one in this repo, if you want to start without leaving:

> *Look at `data/MX_Dengue_trends.csv` and tell me what is in it. Then plot each column over
> time in a small grid so I can see the shape of everything at once.*

Fetching data is the demonstration that tends to convert people. It is the chore everyone
dreads and nobody feels expert at, the agent is genuinely good at it, and one plot tells you
whether it worked:

> *Download the last five years of weekly US influenza data from CDC FluView, save it as a tidy
> CSV, and plot it.*

Then point it at a mess you already have on disk. Something in this shape:

> *This folder has one output CSV per simulation run, with the parameter settings encoded in
> the filenames. Combine them into a single tidy table with those settings parsed into real
> columns, and show me the row count per run so I can check nothing was dropped.*

Note the last clause. **Ask for the number that would expose the failure**, not just the
result. That habit is what the rest of this talk is about, and it is worth building from the
very first task.

### Four things that will each save you an afternoon

**Write your environment's facts into a file the agent reads automatically.** Every agent has
this: a plain markdown file at your project root, loaded into every session. Codex reads
`AGENTS.md`, Claude Code reads `CLAUDE.md`, and both are just prose, so one file copied under
the other name covers you either way. Put in it the things nobody can derive: this API
rate-limits at ten calls a minute, this column is zero when it means missing, our cluster needs
that module loaded first. Add to it every time you debug something surprising. This is the
highest-return habit here and it compounds weekly.

**Ask for the plan before the action, on anything that writes.** "Show me the table of changes
and do not write anything until I say go." Reads are free. Writes deserve a look.

**Give it a way to check itself.** An agent that can run the tests, see the plot, or read the
error will iterate to something correct. One that only emits text into a chat window cannot.
This is most of why terminal agents outperform completion panes.

**Let it fail in front of you.** The instinct is to intervene the moment something breaks.
Wait. Watching an agent read a traceback and fix its own bug teaches you more about what it can
and cannot do than any amount of reading, and it calibrates you fast.

## Two use cases

Both are in this repo, both executed, both yours to fork.

---

### [1. Research: rebuild my own first paper, from prompts only](notebooks/01_research_dengue.ipynb)

Dengue in Mexico, 2004-2011. Four prompts take it from a raw CSV to a working ARGO model with
dynamic training, LASSO term selection, and a leak-free out-of-sample comparison against
three benchmarks. **I wrote no Python.**

What the segment is actually about is the cell in the middle where I stop and check what the
agent did, and find that it quietly patched a problem instead of reporting it.

---

### [2. Education: the agent as my TA, not my students'](notebooks/02_education_reading_group.ipynb)

I do not have a good answer for how students should use AI. I am not going to pretend
otherwise.

What I do have is the instructor's back office: Canvas as an API, a mailing list that lives
in three email threads, recordings that become transcripts that become summaries. My reading
group of ~28 students runs this way. It is unglamorous and it gave back more hours than
anything else I did this year.

## Five lessons, in the order I would want to hear them

**1. Start with the boring task, not the impressive one.**
The best first use of an agent is the thing you already know how to do and resent doing.
Scraping a dataset, reshaping a file, renaming two hundred figures. You can verify the result
instantly, which means you learn what the tool is like without betting anything on it. Trying
to be impressed on day one is how people conclude it does not work.

**2. Fetching data is where agents are strongest. Modeling is where they are riskiest.**
This was the clearest split at SISMID and I did not expect it to be so clean. Data collection
has a low judgment requirement and a visible answer: you plot the CSV and you know. Modeling
is dense with silent design choices, and a wrong one produces a plausible number rather than
an error. Delegate freely at one end, supervise closely at the other.

**3. The notebook is the safety mechanism.**
Because the agent writes its code into cells, I can skim what it actually did. I once asked
for sentiment analysis and glanced at the cell to find a single regular expression matching a
handful of words. It ran, it produced numbers, and the numbers were meaningless. Ten seconds
of reading caught it. A chat window would not have shown me that.

**4. Write your hard-won knowledge down where the agent will read it.**
Every environment has facts nobody can derive: this API rate-limits at ten calls a minute,
this column is zero when it means missing, our cluster needs that module loaded first. Put
them in a file the agent loads automatically. This is the difference between a demo that
works once and a workflow you rely on, and it compounds every week.

**5. Reads are free. Writes get reviewed.**
My whole safety policy. The agent reads my mailbox, my course site and my data as much as it
likes. Anything that leaves my machine and reaches a student, a co-author or a public repo,
I look at first. Not because the drafts are bad. Because the responsibility should stay
attached to a person.

## The one that is not a tip

Rebuilding ARGO took four prompts and about twenty minutes. It took me the better part of a
year in 2015.

Almost all of that year was plumbing, and plumbing is now close to free. But look at what did
not get cheaper. Knowing that Google Trends thresholds low search volume to zero, so that 40%
of one column is missingness wearing the costume of a small number. Deciding that a 2.5%
improvement over a simple benchmark is modest, and writing that in the paper anyway. Choosing
which idea was worth testing at all.

The agent collapsed the distance between having an idea and seeing a number. It did nothing
at all to the distance between seeing a number and believing it. If anything it made that
second gap more dangerous, because the number now arrives so fast, and looking so finished.

That gap is the job. It was always the job. It is just that it used to be hidden inside twelve
months of data wrangling, and now it is the only thing left standing.

---

## Things I would like to argue about in Q&A

- What do you tell a first-year student who asks whether they may use an agent on a homework?
  I do not have an answer I believe.
- Does watching an agent produce a working model in four prompts teach a student the method,
  or teach them that the method is somebody else's problem?
- The "bring your own problem" format split my SISMID room cleanly in two: people with a
  well-defined question got enormous value, people who came to look around got lost. Is that
  fixable, or is it just what this format is?
- Reads free, writes reviewed is a rule I can hold as one person. Does it survive a lab of
  fifteen?

---

### Take the repo

```bash
git clone https://github.com/Shihao-Yang/staix2026sc1.git
```

Or open it in a Codespace from the green **Code** button. Every prompt lives in the notebook
that uses it, so there is nothing else to look up. The long version of the lessons, written up
from the SISMID course, is the appendix at the bottom of this page.

**Shihao Yang** · shihao.yang@isye.gatech.edu · ISyE, Georgia Tech

---

# Appendix: the long version of the lessons

Written up after **SISMID 2026**, where I co-taught "Statistics and Modeling with Novel Data
Streams" with Mauricio Santillana: two and a half days, roughly fifteen epidemiologists and
biostatisticians, several of whom do not write code for a living, all of them using coding
agents throughout.

This is the long version of the five lessons above. It is organized as environment, then
teaching, then the open questions I have not solved. Nothing here is needed to follow the
talk; it is for anyone who wants to run something like this themselves.

One framing note before anything else, because it determines which of these lessons transfer.

**My course used agents as a tool. SC01 teaches the tool itself.** In my course the agent was
a means: I was teaching novel data streams and epidemic models, and the agent existed to flatten
an enormous range of coding ability so that everyone could reach the actual material. When you
are teaching the agent as the subject, some of my problems (the agent being distractingly
flashy, for instance) are not problems at all, they are the point. Read accordingly.

---

## Part 1: environment and tooling

### What worked

**Codespaces plus a notebook is the seamless combination.** This is the setup I am most
confident recommending. The agent edits a notebook directly; the student sees markdown, code,
figures and result tables in one column, can copy anything, and can re-run everything. I tried
several arrangements and nothing else came close.

**Kill the installation step entirely.** I arranged authentication in advance so students
opened a browser tab and were working. This mattered far more than any content decision I made.
An introduction to agents does not need to be advanced: no multi-agent orchestration, no
elaborate tooling. **Basic single-agent use already amazes people**, and every minute spent on
setup is a minute spent losing the half of the room with the older laptop.

**Use a terminal agent, not the editor's built-in assistant.** Claude Code and Codex both worked
well. The Copilot-style inline pane is a different kind of tool and was not what the course
needed: the terminal agents run code, read their own errors, and fix themselves, and watching
that loop is a large part of what students are there to see.

**Data collection is where agents shine.** Scraping was consistently the most successful use in
the whole course, and I did not fully expect that. Finding and fetching data is the thing
everybody dreads and nobody feels expert at. The agent does it, the output is a CSV, and one
plot tells you whether it worked. Low judgment requirement, instantly visible answer. If you are
introducing agents to a research audience and want one demonstration that lands, use this one.

**Fork and diverge.** Students wanted their own annotated copy with their own data. Forking gave
them that cleanly, and several went off to their own disease or country the same afternoon.

### What did not work

**Side-by-side layout is worse than stacked.** I ran the agent and the notebook as left and
right panes and watched people saccade horizontally until they lost the thread. **Vertical,
agent below notebook, reads as one conversation.** For a single-notebook workflow with no file
tree to navigate, stacked is simply better, and this is the cheapest fix on this list.

**Fork drift is a real cost.** When I pushed fixes mid-course, forked students could not
`git pull` them, because they needed to pull from **upstream** rather than **origin**. Nobody
knew that, and it silently split the room. Teach it explicitly and early, or push nothing after
the forks are made.

**Web browsing is still the weak tool.** For novel data streams I wanted the agent to go and
look at sites, and its fetch capability was thin. This is the gap that cost me the most content.

**GUI and desktop agents do not fit yet.** Everything here assumes a terminal agent. I have no
good answer for integrating desktop or GUI agents while keeping setup seamless and uniform
across a room, and I would like one.

---

## Part 2: teaching

### What worked

**Do not introduce agents. Just start using one.** I gave almost no "what is an agent" lecture.
We opened one and used it, and when something broke I explained the failure at the moment it
mattered and then had the agent debug itself in front of everyone. Explaining while using beat
explaining before using by a wide margin, and I now think the up-front conceptual introduction
is mostly instructor anxiety.

**Be explicit that scraping and modeling are different risks.** This was the single most useful
distinction I drew all course:

- **Scraping.** Tell the agent the sources, it fetches, it hits bugs, it usually finds its own
  bugs, out comes a CSV. One visualization confirms it. Delegate freely.
- **Modeling.** Dense with design choices and assumptions, and the agent will quietly make some
  of them. A wrong assumption does not raise an error, it returns a plausible number. My
  approach became: unfold what the agent produced step by step, in real time, with a plot at
  each step, and interrogate whether the result is *interpretable* rather than whether it ran.

**Notebooks give you code visibility, and you will need it.** Because the agent writes Python
into cells, you can skim what it actually did. I asked for sentiment analysis once and found a
single trivial regular expression matching a handful of words. It ran. It produced numbers. The
numbers were meaningless, and ten seconds of reading caught it. A chat window would not have
shown me that.

**Well-designed exercises transfer immediately.** I built a COVID early-outbreak-detection
exercise; a student took its structure straight to West Nile virus and had results the same
afternoon. Design the exercise as a reusable *shape* (orient, baseline, method, verify, compare)
rather than as a single worked answer, and students will carry it somewhere you did not plan.

**Let the room ask, and answer by prompting.** When a student asked something I could have
answered, I often put the question to the agent in front of everyone instead. Watching a
question get resolved was more instructive than hearing me resolve it, and their questions
frequently exposed a genuine gap in my own setup.

### Tensions I did not resolve

**Agents are flashy enough to eat the actual lesson.** I was teaching data streams and models;
the agent kept stealing the room's attention. Students left excited about the tool and hazier
than I wanted on the caveats of the data. **This is specifically a problem for courses that use
agents as a means.** If the tool is the subject, ignore this.

**Modeling stayed rough all course.** Less visible than scraping, less comfortable for everyone,
and occasionally we simply got stuck in front of the room. Notebook code review helped a lot and
did not fully solve it. This is the honest weak point of the whole approach.

**My code-review habit is not how most people use these tools.** I emphasized skimming the code
to see what it did. The mainstream usage is increasingly hands-off: never read the code, just
ask for visualizations and diagnostics. Both are defensible. Teaching one while the students'
world runs on the other is a tension worth resolving deliberately rather than by accident.

**"Bring your own problem" splits the room in two.** Students who arrived with a well-defined
question they had been chewing on for months got enormous value, fast. Students who came to look
around got lost. If you use this format, have real problems in your back pocket for the second
group.

---

## Part 3: still open

1. **Should students use the agent to produce their final presentation?** Some did, from
   notebooks or generated slides, and it went fine. Whether to make it the assignment is a
   different question.
2. **Do your students arrive with a problem, or with curiosity?** This one fact determines
   whether "bring your own problem" is your best format or your worst.
3. **How do GUI and desktop agents fit** without wrecking a uniform setup?
4. **Teaching the tool versus using the tool.** The single most important thing to decide before
   designing any of this. Most of my "distraction" problems are somebody else's curriculum.
5. **What do we tell students about their own use?** I run these tools constantly for my own
   research and administration, and I still do not have an answer I believe for the first-year
   student who asks whether they may use one on a homework. I find that gap uncomfortable and I
   think it is the more important unsolved problem in this document.

---

## Defaults I would now set without thinking

- Vertical layout, agent below notebook.
- One notebook per session, not a sprawling file tree.
- Terminal agent (Claude Code or Codex), never the editor's built-in pane.
- Authentication solved before the room walks in.
- Teach `git pull upstream main` on day one, or freeze the repo after forking.
- Lead with a data-fetching demonstration.
- Environment knowledge lives in a file the agent loads automatically, not in your head.
- Reads free, writes reviewed.
