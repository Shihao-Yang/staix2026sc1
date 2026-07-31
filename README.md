# Out-of-the-Box Agentic AI for Research and Education

Guest segment for **STAI-X 2026, SC01: *Agentic AI: From Zero to Infinity***
(Tian Zheng, Columbia; Boston, July 31 2026).
15 minutes plus Q&A, by **[Shihao Yang](https://shihaoyang.info)**, Georgia Tech ISyE.

**There are no slides.** The talk is three Jupyter notebooks, and they run.

## Start here

| | |
|---|---|
| **[`00_start_here.ipynb`](notebooks/00_start_here.ipynb)** | The talk. Setup, the two use cases, five lessons. Read this first. |
| **[`01_research_dengue.ipynb`](notebooks/01_research_dengue.ipynb)** | **Research.** Rebuild the ARGO model (Yang, Santillana & Kou, *PNAS* 2015) on Mexican dengue data from four prompts, with no hand-written Python. Executed, with figures and a model comparison table. |
| **[`02_education_reading_group.ipynb`](notebooks/02_education_reading_group.ipynb)** | **Education.** The agent as the instructor's TA: Canvas as an API, a mailing list reconstructed from three email threads, recordings to transcripts to summaries. |

Supporting material:

- **[`prompts/`](prompts/)**: every prompt from both notebooks as copy-pasteable text.
- **[`docs/lessons-learned.md`](docs/lessons-learned.md)**: the long version, written up from
  teaching a SISMID 2026 short course where ~15 epidemiologists used coding agents for two and
  a half days.
- **[`docs/agent-setup.md`](docs/agent-setup.md)**: install and log in. Codex if you already
  have a ChatGPT account, Claude Code otherwise, plus the encrypted fallback token for when the
  workspace key does not cooperate.

Getting started from zero now lives inside
[`00_start_here.ipynb`](notebooks/00_start_here.ipynb) rather than in a separate file, so the
setup, the first tasks, and the talk are one document.

## Run it

**In the browser (recommended).** Click the green **Code** button, choose the **Codespaces**
tab, and create a codespace on `main`. The container builds in about a minute with everything
installed. Then open `notebooks/00_start_here.ipynb`.

**Locally.** Python 3.11 or newer:

```bash
git clone https://github.com/Shihao-Yang/staix2026sc1.git
```

```bash
cd staix2026sc1 && python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
```

```bash
.venv/bin/jupyter lab
```

The research notebook runs end to end in under a minute on the bundled data. Nothing here
needs an API key.

## The argument in three sentences

The plumbing of computational research is now close to free, and a plain, unclever coding
agent is enough to capture nearly all of that. What did not get cheaper is knowing which
analysis is worth running, and whether the number that came back deserves to be believed. So
the useful skill is no longer implementation, it is verification, and the notebook format is
what makes verification possible at speed.

## What is in the data

`data/MX_Dengue_trends.csv` holds monthly reported dengue cases in Mexico (`Dengue CDC`) alongside
Google search interest for four Spanish-language terms, 2004-2011 (96 months). From the
[MIGHTE-lab SISMID](https://github.com/MIGHTE-lab/SISMID25) teaching materials.

There is **no student data in this repository**. The roster example in notebook 02 is
fabricated; it preserves the structure of the real problem and none of the people.

## Related

- [`Shihao-Yang/sismid2026`](https://github.com/Shihao-Yang/sismid2026): the full SISMID 2026
  short course this material was distilled from.
- [ARGO](https://www.pnas.org/doi/10.1073/pnas.1515373112): Yang, Santillana & Kou, *PNAS*
  112(47), 2015.

## License

Teaching material, released under [CC BY 4.0](LICENSE). Use it, fork it, teach with it.

Questions: shihao.yang@isye.gatech.edu
