# Use case 2 (education): the agent as *my* TA, not my students'

### Shihao Yang &nbsp;·&nbsp; Georgia Tech ISyE &nbsp;·&nbsp; STAI-X 2026 SC01

**Run this file the way you ran [`00_start_here.md`](00_start_here.md):** scroll it, copy the fenced prompts into the terminal below, and let the agent work. Everything here runs against my real mailbox and my real reading group, so I drive this one from my own laptop rather than a Codespace.

---

## Start with what I have not solved

* **I have no good answer for how students should use AI in assessment.** I have policies in my syllabi and I am not confident in any of them.
* I have gotten very good at using these tools for my own work while still not knowing what to tell a first-year who asks whether they may use one on a homework.
* That gap is uncomfortable, and I think it is the more important problem. I would rather say so than sell you a solution I do not have.

**So this is not about students using AI.** It is about the half of teaching nobody presents on: preparing material, running a mailing list, scheduling, and answering the same request for the fifteenth time. Most of the hours, none of the glory, and almost perfectly shaped for an agent.

My running example is the **Agentic AI reading group** I started in May 2026. It accreted to roughly 28 students across three email threads. The agent is my TA for it, not theirs.

---

## Why the back office is the easy win

| | Research modeling | Course administration |
|---|---|---|
| Is a mistake visible? | Often not | Almost always, immediately |
| Cost of a mistake | A wrong scientific claim | A wrong due date |
| Needs domain judgment? | Constantly | Rarely |
| Is it repetitive? | No | Relentlessly |

* Everything in the right column says **delegate this**.
* And unlike research code, I do not need to read every line, because **the output is the check.** I look at the email, or the slide, and either it is right or it is not.

---

## Demo 1: turn a blog post into a lecture

The reading group needed a session on **Agent Skills**. I did not want to write a deck, and the primary sources were scattered across Anthropic's docs, a couple of engineering blog posts, and two GitHub repos.

```
Read Anthropic's Agent Skills documentation and their engineering blog post
"Equipping agents for the real world with Agent Skills". Also pull the README of
github.com/anthropics/skills and two real SKILL.md examples from it. Write each
one into a digest file under skills/, and give me an index README that records
the source URL and fetch date for every single one.
```

Then, and only then:

```
From those digests, build a Beamer deck for a 45 minute student reading group.
Assume the room knows what an LLM is and has never seen a skill. I want the
motivation first, then the SKILL.md format, then progressive disclosure, then a
worked example of an agent actually loading one, then the ecosystem, then open
questions to argue about. Compile it to PDF.
```

**What came out:** a 16 frame deck, compiled, with a roadmap, a worked example, a section on where portability leaks, and discussion questions. I taught from it the next day.

**Say this while it is on screen:**

* **Two prompts, not one.** Fetch and digest first, *then* build. If you ask for slides directly it invents the content. Ask for sourced digests first and the slides are downstream of something you can check.
* **The index file is the point.** Every digest carries its source URL and fetch date, so when a student asks "where did this claim come from" I have an answer, and when the docs change in six months I know what is stale.
* **I still owned the argument.** The ordering, what to cut, which open questions were worth the room's time. The agent wrote the LaTeX.
* This is the single biggest time saver in my teaching, and it is not close.

---

## Demo 2: the mailing list nobody designed

The reading group was not planned. I emailed ISyE PhD students asking who was interested. People replied. Then people replied to *forwarded* copies. Then people asked to be added after attending a session. Then a second thread started for a related group, with partial overlap.

Three months later the authoritative membership list existed only as an unstructured conversation, which is the normal way this goes.

So I stopped maintaining a list and started **re-deriving** it on demand:

```
Search my Outlook for every message in the reading group threads since May 1.
Extract everyone who asked to join, everyone who asked to be removed, and
everyone who only ever said they could not attend. Exclude me. Deduplicate by
email, keep the display name from the most recent message, and give me a table
with which thread each person came in through.
```

**Two details worth pointing at, because they are what a hurried human gets wrong:**

* **Exclude yourself.** Your own messages are in every thread. Forget this and you email yourself forever.
* **A removal has to beat a join regardless of order.** Someone who joined in May and opted out in June is opted out. Group first, then filter; filtering first silently re-adds them. Emailing somebody who asked to be left alone is the one error here with a real human cost.

Then the weekly announcement, which is the actual chore:

```
Draft an email to the reading group list announcing next week's session. The
paper is the one we picked on Friday. Keep it under 150 words, plain prose, no
bullet-point salad, and include the room and the Zoom link from last week's
message. Show me the draft. Do not send.
```

**"Do not send" is not optional, and I will come back to that.**

---

## Demo 3: where the CLI stops and the desktop starts

I ask for a scheduling poll constantly. Here is the real one from this group, sent 2026-05-20, subject *"Summer Reading Group: Kickoff on Agent Skills (please vote)"*.

```
Draft a scheduling poll email for the reading group kickoff on Agent Skills.
Four candidate slots across next week, 45 minutes each, avoiding Tuesday
morning. Recipients are the roster you just built.
```

The agent drafts the email fine. Then it hits a wall, and the wall is the interesting part.

* **A real Microsoft 365 scheduling poll is not text.** It is a FindTime widget you insert from the Outlook web UI. There is no CLI flag for it, and there never will be.
* **My terminal agent cannot do it.** It drives my mailbox over a small command-line tool. That tool can compose, reply, attach, and send. It cannot click "Insert poll".
* **The desktop app can**, because it can drive a real Chrome session: open Outlook on the web, click through the poll UI, fill the slots.
* **And even then it only gets most of the way.** The inserted poll is a cross-origin iframe to `forms.office.com` inside a page served from `outlook.cloud.microsoft`. Clicks land, but **keyboard input does not cross that boundary**, and JavaScript cannot reach into it either. So the agent sets up everything around the poll and I type the five fields inside it myself.

**Why I am showing you a demo that half fails:**

* Because this is what the tools actually feel like right now, and a talk that only shows the wins is not useful to you on Monday.
* Because the *shape* of the limit is learnable: **terminal agents are excellent at APIs and files, and blind to anything that only exists as a rendered widget.** Once you know that, you stop being surprised.
* Because the fallback is fine. Lettered options in the body, poll by reply. Works for a group of thirty.

---

## Demo 4: the fifteenth identical request

Real ones from this group, paraphrased: *"Could you please add me to the mailing list and let me know the time?"* and *"I would appreciate it if you can add me to it."*

Each takes ninety seconds and arrives at 11pm. There were dozens.

```
Find every unanswered message in the reading group threads where someone is
asking to join or asking about logistics. For each one, draft a reply in my
voice: warm, two sentences, confirm they are added, state the standing time and
where to find the material. Show me all the drafts as a list before you create
any of them.
```

* The drafts are usually better than my own tired 11pm phrasing.
* I read all of them. It takes two minutes instead of forty.
* **Then I send them myself.**

---

## The line I actually enforce

| Agent does it, no review | I review, then it acts | I do it myself |
|---|---|---|
| Search my mail, build the roster | Send any email to students | Anything touching a grade |
| Fetch sources, draft slides | Publish to the course site | Accommodation judgment calls |
| Read the gradebook, flag anomalies | Post the scheduling poll | Anything I would not sign |
| Draft replies to routine requests | Calendar invites to real people | Recommendation letters |

* **Reads are free, writes are reviewed, and anything a student experiences as coming from me has to actually have come from me.**
* Not because the drafts are bad. Because the responsibility should stay attached to a person.
* **FERPA is real.** Rosters, grades and accommodation requests are not material to hand to an arbitrary third-party service without knowing where it goes. In practice the read-heavy work runs against my own mailbox with my own credentials, and **there is no student data in this public repo** at all.

---

## What made this stick: the skill

* The first month, I re-explained my setup in every conversation. How to reach my mailbox. That subject lines must be ASCII. That timestamps come back in the wrong timezone. That drafts must never auto-send.
* The fix was to stop re-explaining and write it into a **skill**: a folder of instructions the agent loads only when the task is about email.
* Mine is a page of prose plus a companion file of accumulated gotchas, appended to every time something breaks in a confusing way:

```
SSH timeout is not a broker failure. The box is asleep; Tailscale reports it
active from a cached heartbeat, which is misleading. Ask, do not restart.

ASCII subjects only. Em-dashes and smart quotes get mangled in the SSH to
Windows to COM pipeline. Bodies delivered via stdin are safe for any Unicode.
```

* Neither is knowledge an agent can derive. Both cost me a confusing afternoon exactly once.
* **When you debug something surprising, write it down where the agent will read it next time.** That is the whole habit.

---

## Honest scorecard

**Works well, use it tomorrow.** Turning primary sources into teaching material. Reconstructing structure out of unstructured email. Drafting the fifteenth reply to the same question. None of this needs a clever agent.

**Works, with a human gate.** Anything outbound.

**Does not work yet.** Rendered-widget UIs like the scheduling poll, unless you hand the agent a browser, and even then only partly.

**Still unsolved.** The thing I opened with. I notice I have gotten fluent at using these tools for my own work while still not knowing what to tell a student who asks whether they may use one. That gap is the more important problem, and I would genuinely like to hear this room on it.

---

**Back to:** [`00_start_here.md`](00_start_here.md)
