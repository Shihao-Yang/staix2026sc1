# Lessons from teaching with coding agents

Written up after **SISMID 2026**, where I co-taught "Statistics and Modeling with Novel Data
Streams" with Mauricio Santillana: two and a half days, roughly thirty epidemiologists and
biostatisticians, most of whom do not write code for a living, all of them using coding agents
throughout.

This is the long version of the five lessons in
[`notebooks/00_start_here.ipynb`](../notebooks/00_start_here.ipynb). It is organized as
environment, then teaching, then the open questions I have not solved.

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
