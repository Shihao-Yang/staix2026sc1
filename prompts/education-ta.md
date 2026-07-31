# The education prompts, verbatim

Every prompt from
[`notebooks/02_education_reading_group.ipynb`](../notebooks/02_education_reading_group.ipynb).

These run against real systems (a Canvas course site, a mailbox), so unlike the research
prompts they are not reproducible from this repo alone. They are here because the *shape* is
what transfers.

---

## Canvas: bulk operations on the course site

Every Canvas site sits on a full REST API. `pip install canvasapi`, then generate a token from
Account → Settings → New Access Token.

> Using the `canvasapi` package and my `CANVAS_API_KEY`, list the assignments in course 405896.
> Shift every due date forward by one year, but keep them on the same weekday rather than the
> same calendar date, keep the 23:59 Eastern time, and skip anything that would land in the week
> of fall break. Show me the full before-and-after table and do not write anything until I say go.

**"Show me the table and do not write anything until I say go" is the whole safety protocol.**
A due-date table is checkable at a glance, which is what makes this delegable at all.

Others in the same family:

> Audit course 405888: list every assignment with no description, no due date, or zero points,
> and every quiz that is unpublished. Just the table, no changes.

> Duplicate the quiz "HW1 self-grading" in course 405888 six times, named HW2 through HW7,
> keeping every setting identical, all unpublished. List what you are about to create first.

> Compare the Canvas gradebook against `roster.csv`. Who is enrolled but has no submissions,
> and who has submissions but is not on the roster?

---

## Email: reconstruct a mailing list that was never designed

> Search my Outlook for every message in the reading group threads since May 1. Extract everyone
> who asked to join, everyone who asked to be removed, and everyone who only ever attended.
> Exclude me. Deduplicate by email, keep the display name from the most recent message, and give
> me a table with which thread each person came in through.

Two failure modes worth naming in the prompt, because both have real costs:

- **Exclude yourself.** Your own messages are in every thread.
- **A removal must beat a join regardless of order.** Someone who joined in May and opted out in
  June is opted out. Group first, then filter; filtering first silently re-adds them. Emailing
  somebody who asked to be left alone is the one error here with a human cost.

---

## Recordings: transcript to summary to inbox

```
recording ──▶ transcript ──▶ summary + decisions ──▶ email to the roster
   Zoom        local ASR         the agent            drafted, I send
```

> Find yesterday's reading group recording, pull the transcript, and write a summary for the
> mailing list: what paper we covered, the three main threads of discussion, the open questions
> we did not resolve, and who volunteered to present next. Keep it under 200 words, plain prose,
> no bullet-point salad. Then draft it to the roster. Do not send.

**Audit the transcript before trusting it.** My local transcription tool has a failure mode
where the language detector flips an English meeting to another language and returns confident,
fluent, entirely hallucinated text. A summary of a hallucinated transcript is indistinguishable
from a real one. Any pipeline where step N cannot detect that step N-1 failed will eventually
publish nonsense, so the transcript step checks itself before the summary step runs.

---

## Write the environment knowledge down once

The habit that made all of this reliable: stop re-explaining your setup every session, and put
it in a file the agent loads automatically (a *skill*, a `CLAUDE.md`, whatever your tool calls
it). A page of prose plus a companion file of accumulated gotchas.

Append to the gotchas file every time something breaks in a confusing way:

```markdown
### SSH timeout is not a broker failure
If the connection itself hangs, the Windows box is asleep. Tailscale will report the
node active for a short window via cached heartbeat during sleep, which is misleading.
Ask the user to wake it; do not try to restart the broker.

### ASCII subjects only
Em-dashes and smart quotes get mangled in the SSH to Windows to COM pipeline.
Bodies delivered via stdin are safe for any Unicode.
```

Neither is knowledge an agent can derive. Both cost a confusing afternoon exactly once.

---

## The line worth enforcing

| Agent does it, no review | I review, then it acts | I do it myself |
|---|---|---|
| Search mail, build the roster | Send any email to students | Anything touching a grade |
| Pull transcripts, draft summaries | Publish to the course site | Accommodation judgment calls |
| Read the gradebook, flag anomalies | Bulk due-date changes | Anything I would not sign |

**Reads are free, writes are reviewed, and anything a student experiences as coming from me has
to actually have come from me.**

Student records are FERPA-protected. Rosters, grades and accommodation requests are not material
to hand to an arbitrary third-party service without knowing where it goes. In practice the
read-heavy work runs against my own mailbox and my own institution's API under my own
credentials.
