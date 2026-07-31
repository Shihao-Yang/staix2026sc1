# Out-of-the-Box Agentic AI for Research and Education

### Shihao Yang &nbsp;·&nbsp; Georgia Tech ISyE **STAI-X 2026, SC01: *Agentic AI: From Zero to Infinity*** &nbsp;·&nbsp; Boston, July 31, 2026 &nbsp;·&nbsp; guest segment, 15 minutes + Q&A

> ### `github.com/Shihao-Yang/staix2026sc1`
> Open in a Codespace, or clone it. Everything here executes.

**No slides.** You are looking at the talk: one markdown file, a terminal underneath, and two notebooks. Live demo beats a deck for this.

---

## Where I am coming from

* Not an agent researcher. A **statistician doing time series forecasting**, mostly **forecasting epidemics from internet search data**.

* Taught a SISMID short course this last week (Statistics and Modeling in Infectious Diseases): ~15 epidemiologists, several of whom do not code, using coding agents for two and a half days. That is where most of what follows was learned.

* Tian asked me to cover **getting started and hitting the ground running**. Two use cases: research (the main one) and education (if we have time).

### The research demo, and why this one

* My first paper: [**ARGO**](https://www.pnas.org/doi/10.1073/pnas.1515373112) (Yang, Santillana & Kou, *PNAS* 2015). Google search volume to nowcast influenza.

* I did that work as a PhD student in this department. It took the better part of a year.

* **So: how much of a year of PhD work can an agent reproduce in 15 minute?** That is the demo. Let us find out together.

---

## The setup, in full

* The **perceived** setup cost is the main thing keeping people out. So let me be concrete about how little there is. This is the whole stack, and we do it live.

### 1. An environment

* A [**GitHub Codespace**](https://github.com/features/codespaces): real Linux machine in a browser tab, free tier, nothing to install.
* Green **Code** button, **Codespaces** tab, create. Free allowance is ~60 hours a month on a 2-core machine, far more than today needs.
* You will use it later today. You can already see me running this session inside one.

### 2. A terminal agent

* **Default: [Claude Code](https://claude.com/claude-code).** It is what this whole repo was built with, and the one I can actually help you with in this room.

```bash
npm install -g @anthropic-ai/claude-code
```

* Deliberately **not** the Copilot pane inside your editor. Different kind of tool. Terminal agents run code, read their own errors, and fix themselves. Watching that loop is the point.

### 3. Logging in

* **Claude Code**, with the API key from Tian's course workspace already in your environment: just run `claude`.

* There is a shared class token in this repo, encrypted. I unlock it with a passcode I will say out loud. Use `source`, not `bash`, or nothing sticks:

```bash
source scripts/claude-login.sh
```

* Plain `claude` defaults to asking permission before every edit, which is slow to watch. For the demo:

```bash
claude --dangerously-skip-permissions
```

* Fine here because a Codespace is disposable. **Not a habit for your own machine.**
* Demo for terminal agent vs copilot

---

## Your first task should be boring

**Fetching data.** Everyone dreads it, nobody feels expert at it, the agent is genuinely good at it, and one plot tells you whether it worked.

```
Download Google search interest for "dengue", "sintomas de dengue" and "mosquito"
in Mexico over the past five years. Save it as a tidy CSV, plot all three.
```

```
Download the last five years of weekly US influenza data from CDC, save it as a
tidy CSV, and plot it.
```


```
Download all available monthly denuge case counts in mexico from OpenDengue
```
---



## Three habits

### 1. Treat the agent like a second-year PhD student

* Capable. Fast. Will absolutely make mistakes, and will not always tell you.
* **You have the data intuition. That is the part that did not get automated.**
* So ask constantly for **visualization**: raw data, cleaned data, results.
* Ask for the **intermediate outputs you already know how to read**: MCMC trace plots, cross-validation curves, residuals, diagnostic charts. You know what wrong looks like.

### 2. Write your environment's facts where the agent will read them

* Claude Code loads a plain markdown file at your project root, `CLAUDE.md`, into every session. Just prose, no format to learn.
* Put in it what nobody can derive: *this API rate-limits at ten calls a minute*, *this column is zero when it means missing*, *our cluster needs that module loaded first*.
* Add to it every time you debug something surprising. **Highest-return habit here.**
* Demo for CLAUDE.md in this repo

* **Skills** are the next step up: a reusable folder of instructions plus scripts, loaded only when relevant. Mine for driving my email is a page of prose plus a file of accumulated gotchas.
* Demo for fetching outlook email with and without skill, and ask claude to ask chatgpt

* The point of both: **stop re-explaining your setup in every conversation.**

### 3. Ask for the plan before the action, on anything that writes

* "Show me the table of changes and do not write anything until I say go."
* Reads are free. Writes get reviewed.



---



## Use case 1 (research): rebuild my first paper, from prompts only

> ### Switch to the notebook now
> **[`notebooks/01_research_dengue.ipynb`](notebooks/01_research_dengue.ipynb)** to drive it live &nbsp;·&nbsp; **[`_soln.ipynb`](notebooks/01_research_dengue_soln.ipynb)** if the room needs the answer fast

**Say while it runs:**

* **Nothing is pre-supplied.** Search interest from Google Trends, case counts from OpenDengue, both downloaded live in the first two cells.
* **I wrote no Python.**
* The Google Trends call **fails first time**: `pytrends` passes `method_whitelist` to urllib3, which renamed it. The agent read the traceback and dropped the argument on its own. But it dropped the retry logic with it. **It fixed the error, not the intent.**
* Then interrogate the download before modeling. Three things it did not mention: the case record is **three islands** with 2008-2014 and 2020 missing; the case definition **changes** from confirmed to total partway through; and against my old curated file the totals match within 7% while the **median month differs by 30%**.
* Then the model: it quietly swapped `log` for `log1p`, because one search column is **exactly zero in 40% of months**. Google thresholds low volume away. **Missingness wearing the costume of a small number.**
* **No prompt produces those sentences.** They come from knowing the data source.

**The numbers to quote** (2015-2019, the longest clean stretch, 33 evaluation months):

| Model | RMSE | Corr | vs AR(3) |
|---|---|---|---|
| Static OLS, one term, frozen fit | 25,333 | 0.97 | 2.38 |
| AR(3), dynamic 24-month window | 10,666 | 0.80 | 1.00 |
| Search only, LASSO, dynamic | 19,454 | 0.87 | 1.82 |
| **ARGO** (search + AR, LASSO, dynamic) | **9,566** | **0.97** | **0.90** |

* **Dynamic training is the big win.** The frozen fit is more than twice as bad as anything that keeps refitting.
* **Search genuinely helps.** ARGO beats autoregression by ~10% RMSE, ~20% MAE. The striking part is correlation: AR(3) alone tracks at 0.80, ARGO at 0.97. **Autoregression gets the level, search catches the turns.** That is exactly the 2015 claim.
* **But search alone is worse than autoregression.** Real and complementary, not sufficient. Reporting the search-only model as a success would be overselling.
* **33 evaluation months is a small sample.** The honest summary is "the method reproduces and the direction is right," not "ARGO is 10% better."
* **Writing that sentence honestly is still my job**, and it decides whether the analysis is any good.

---

## Use case 2 (education): the agent as *my* TA, not my students'

> ### Switch to the notebook now
> **[`notebooks/02_education_reading_group.ipynb`](notebooks/02_education_reading_group.ipynb)**

**Open with what I have not solved:**

* **I have no good answer for how students should use AI in assessment.** I have policies in my syllabi and I am not confident in any of them.
* I have gotten very good at using these tools for my own work while still not knowing what to tell a first-year who asks if they may use one on a homework.
* That gap is uncomfortable, and I think it is the more important problem.

**Then what I have solved: the instructor's back office.**

| | Research modeling | Course administration |
|---|---|---|
| Mistake visible? | Often not | Almost always, immediately |
| Cost of a mistake | A wrong scientific claim | A wrong due date |
| Needs domain judgment? | Constantly | Rarely |
| Repetitive? | No | Relentlessly |

* Everything in the right column says **delegate this**.
* **Canvas is a REST API.** I hand-wrote a due-date shifter in 2024; an evening, mostly pasting assignment IDs. Now one prompt. The real change is not the evening saved, it is that **the class of tasks worth automating got much larger**.
* **The mailing list nobody designed.** ~28 students across three email threads. I stopped maintaining a list and started **re-deriving** it from the mailbox.
* **Recordings to summaries.** Audit the transcript before trusting it: a summary of a hallucinated transcript looks exactly like a real one.
* **Reads are free, writes are reviewed**, and anything a student experiences as coming from me has to actually have come from me. FERPA is real; that roster is fabricated.

---

## The one that is not a tip

* Rebuilding ARGO took **four prompts and about twenty minutes**. It took me most of a year in 2015.
* Nearly all of that year was plumbing. **Plumbing is now close to free.**

| Still expensive | Now nearly free |
|---|---|
| Noticing the case record has a seven-year hole in it | Downloading and aggregating the record |
| Knowing "confirmed" and "total" cases are different quantities | Joining the two tables |
| Knowing Google Trends thresholds low volume to zero | Handling the zeros once you know |
| Deciding 33 months is a small sample, and saying so | Computing the 10% |
| Choosing dynamic training as the idea worth testing | Implementing the rolling window |

* The agent collapsed the distance between **having an idea** and **seeing a number**.
* It did nothing to the distance between **seeing a number** and **believing it**.
* If anything that second gap got more dangerous, because the number now arrives fast and looking finished.
* **That gap is the job. It always was.** It used to be hidden inside twelve months of data wrangling. Now it is the only thing left standing.

---

## Things I would like to argue about in Q&A

* What do you tell a first-year who asks whether they may use an agent on a homework? I do not have an answer I believe.
* Does watching an agent build a working model in four prompts teach the method, or teach that the method is somebody else's problem?
* "Bring your own problem" split my SISMID room cleanly in two: people with a well-defined question got enormous value, people who came to look around got lost. Fixable, or just what the format is?
* Reads free / writes reviewed is a rule I can hold as one person. Does it survive a lab of fifteen?

---

### Take the repo

```bash
git clone https://github.com/Shihao-Yang/staix2026sc1.git
```

Or open it in a Codespace from the green **Code** button. Every prompt lives in the notebook that uses it. The long version of the lessons, from the SISMID course, is the appendix below.

**Shihao Yang** &nbsp;·&nbsp; shihao.yang@isye.gatech.edu &nbsp;·&nbsp; ISyE, Georgia Tech

---

# Appendix: the long version of the lessons

*Not presented. For anyone who wants to run something like this themselves.*

Written up after **SISMID 2026**, where I co-taught "Statistics and Modeling with Novel Data Streams" with Mauricio Santillana: two and a half days, roughly fifteen epidemiologists and biostatisticians, several of whom do not write code for a living, all of them using coding agents throughout.

It is organized as environment, then teaching, then the open questions I have not solved. The habits in the talk above are the compressed version of what is here.

## Part 1: environment and tooling

### What worked

**Codespaces plus a notebook is the seamless combination.** This is the setup I am most confident recommending. The agent edits a notebook directly; the student sees markdown, code, figures and result tables in one column, can copy anything, and can re-run everything. I tried several arrangements and nothing else came close.

**Kill the installation step entirely.** I arranged authentication in advance so students opened a browser tab and were working. This mattered far more than any content decision I made. An introduction to agents does not need to be advanced: no multi-agent orchestration, no elaborate tooling. **Basic single-agent use already amazes people**, and every minute spent on setup is a minute spent losing the half of the room with the older laptop.

**Use a terminal agent, not the editor's built-in assistant.** The Copilot-style inline pane is a different kind of tool and was not what the course needed: the terminal agents run code, read their own errors, and fix themselves, and watching that loop is a large part of what students are there to see.

**Data collection is where agents shine.** Scraping was consistently the most successful use in the whole course, and I did not fully expect that. Finding and fetching data is the thing everybody dreads and nobody feels expert at. The agent does it, the output is a CSV, and one plot tells you whether it worked. Low judgment requirement, instantly visible answer. If you are introducing agents to a research audience and want one demonstration that lands, use this one.

**Fork and diverge.** Students wanted their own annotated copy with their own data. Forking gave them that cleanly, and several went off to their own disease or country the same afternoon.

### What did not work

**Side-by-side layout is worse than stacked.** I ran the agent and the notebook as left and right panes and watched people saccade horizontally until they lost the thread. **Vertical, agent below notebook, reads as one conversation.** For a single-notebook workflow with no file tree to navigate, stacked is simply better, and this is the cheapest fix on this list.

**Fork drift is a real cost.** When I pushed fixes mid-course, forked students could not `git pull` them, because they needed to pull from **upstream** rather than **origin**. Nobody knew that, and it silently split the room. Teach it explicitly and early, or push nothing after the forks are made.

**Web browsing is still the weak tool.** For novel data streams I wanted the agent to go and look at sites, and its fetch capability was thin. This is the gap that cost me the most content.

**GUI and desktop agents do not fit yet.** Everything here assumes a terminal agent. I have no good answer for integrating desktop or GUI agents while keeping setup seamless and uniform across a room, and I would like one.

---

## Part 2: teaching

### What worked

**Do not introduce agents. Just start using one.** I gave almost no "what is an agent" lecture. We opened one and used it, and when something broke I explained the failure at the moment it mattered and then had the agent debug itself in front of everyone. Explaining while using beat explaining before using by a wide margin, and I now think the up-front conceptual introduction is mostly instructor anxiety.

**Be explicit that scraping and modeling are different risks.** This was the single most useful distinction I drew all course:

- **Scraping.** Tell the agent the sources, it fetches, it hits bugs, it usually finds its own bugs, out comes a CSV. One visualization confirms it. Delegate freely.
- **Modeling.** Dense with design choices and assumptions, and the agent will quietly make some of them. A wrong assumption does not raise an error, it returns a plausible number. My approach became: unfold what the agent produced step by step, in real time, with a plot at each step, and interrogate whether the result is *interpretable* rather than whether it ran.

**Notebooks give you code visibility, and you will need it.** Because the agent writes Python into cells, you can skim what it actually did. I asked for sentiment analysis once and found a single trivial regular expression matching a handful of words. It ran. It produced numbers. The numbers were meaningless, and ten seconds of reading caught it. A chat window would not have shown me that.

**Well-designed exercises transfer immediately.** I built a COVID early-outbreak-detection exercise; a student took its structure straight to West Nile virus and had results the same afternoon. Design the exercise as a reusable *shape* (orient, baseline, method, verify, compare) rather than as a single worked answer, and students will carry it somewhere you did not plan.

**Let the room ask, and answer by prompting.** When a student asked something I could have answered, I often put the question to the agent in front of everyone instead. Watching a question get resolved was more instructive than hearing me resolve it, and their questions frequently exposed a genuine gap in my own setup.

### Tensions I did not resolve

**Agents are flashy enough to eat the actual lesson.** I was teaching data streams and models; the agent kept stealing the room's attention. Students left excited about the tool and hazier than I wanted on the caveats of the data. **This is specifically a problem for courses that use agents as a means.** If the tool is the subject, ignore this.

**Modeling stayed rough all course.** Less visible than scraping, less comfortable for everyone, and occasionally we simply got stuck in front of the room. Notebook code review helped a lot and did not fully solve it. This is the honest weak point of the whole approach.

**My code-review habit is not how most people use these tools.** I emphasized skimming the code to see what it did. The mainstream usage is increasingly hands-off: never read the code, just ask for visualizations and diagnostics. Both are defensible. Teaching one while the students' world runs on the other is a tension worth resolving deliberately rather than by accident.

**"Bring your own problem" splits the room in two.** Students who arrived with a well-defined question they had been chewing on for months got enormous value, fast. Students who came to look around got lost. If you use this format, have real problems in your back pocket for the second group.

---

## Part 3: still open

1. **Should students use the agent to produce their final presentation?** Some did, from notebooks or generated slides, and it went fine. Whether to make it the assignment is a different question.
2. **Do your students arrive with a problem, or with curiosity?** This one fact determines whether "bring your own problem" is your best format or your worst.
3. **How do GUI and desktop agents fit** without wrecking a uniform setup?
4. **Teaching the tool versus using the tool.** The single most important thing to decide before designing any of this. Most of my "distraction" problems are somebody else's curriculum.
5. **What do we tell students about their own use?** I run these tools constantly for my own research and administration, and I still do not have an answer I believe for the first-year student who asks whether they may use one on a homework. I find that gap uncomfortable and I think it is the more important unsolved problem in this document.

---

## Defaults I would now set without thinking

- Vertical layout, agent below notebook.
- One notebook per session, not a sprawling file tree.
- Terminal agent (Claude Code), never the editor's built-in pane.
- Authentication solved before the room walks in.
- Teach `git pull upstream main` on day one, or freeze the repo after forking.
- Lead with a data-fetching demonstration.
- Environment knowledge lives in a file the agent loads automatically, not in your head.
- Reads free, writes reviewed.
