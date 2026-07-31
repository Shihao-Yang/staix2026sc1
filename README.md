# Out-of-the-Box Agentic AI for Research and Education

Guest segment for **STAI-X 2026, SC01: *Agentic AI: From Zero to Infinity*** (Tian Zheng, Columbia; Boston, July 31 2026). 15 minutes plus Q&A, by **[Shihao Yang](https://shihaoyang.info)**, Georgia Tech ISyE.

**There are no slides.** The talk is a markdown file and three notebooks, and they run.

## Start here

> ### [`00_start_here.md`](00_start_here.md)
> The talk itself, written to be scrolled through while presenting: title-and-bullet sections,
> every prompt in a copyable block. Setup, logging in, the two use cases, four habits, and a
> long-form appendix from teaching this at SISMID. **Read this first.**

Then the two use cases:

| | |
|---|---|
| **[`notebooks/01a_research_data.ipynb`](notebooks/01a_research_data.ipynb)** | **Research, part A.** Download both data sources live, then interrogate what came back. The slow half, and the one most likely to break, which is the point. |
| **[`notebooks/01b_research_model.ipynb`](notebooks/01b_research_model.ipynb)** | **Research, part B.** Rebuild the ARGO model (Yang, Santillana & Kou, *PNAS* 2015) from three prompts. Starts from pre-fetched data so it runs instantly. Drive this in a second session, in parallel with part A. |
| **[`notebooks/01_research_soln.ipynb`](notebooks/01_research_soln.ipynb)** | **Research, worked.** Both halves executed, with figures, the model comparison table, and my honest reading of the results. Your fallback if an agent is not cooperating. |
| **[`02_education_reading_group.md`](02_education_reading_group.md)** | **Education.** The agent as the instructor's TA: turning primary sources into a lecture deck, a mailing list re-derived from three email threads, scheduling, and the fifteenth identical student request. Prompts only, no code. |

Every prompt lives in the notebook that uses it. There is nothing else to look up.

## Run it

**In the browser (recommended).** Click the green **Code** button, choose the **Codespaces** tab, and create a codespace on `main`. The container builds in about a minute with everything installed.

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

The solution notebook runs end to end in under a minute on the bundled data, and needs no API key. Installing and logging in an agent is covered in [`00_start_here.md`](00_start_here.md).

## The argument in three sentences

The plumbing of computational research is now close to free, and a plain, unclever coding agent is enough to capture nearly all of that. What did not get cheaper is knowing which analysis is worth running, and whether the number that came back deserves to be believed. So the useful skill is no longer implementation, it is verification, and the notebook format is what makes verification possible at speed.

## What is in the data

Part A **downloads its own data** at runtime, from three unrelated organisations, and every result is cached into `data/` so nothing else has to wait on a network:

| File | Source | What it is |
|---|---|---|
| `gt_dengue_mx.csv` | Google Trends, via `pytrends` | Monthly search interest in Mexico for four Spanish dengue terms, 2004-2024 |
| `opendengue_mexico_monthly.csv` | [OpenDengue](https://opendengue.org/) V1.3 national extract | Mexican dengue case counts, aggregated to months |
| `who_flunet_mexico_weekly.csv` | [WHO FluNet](https://www.who.int/tools/flunet) via the WHO xmart API | Weekly influenza positives for Mexico, 1997-2026. This is the disease ARGO was actually built for, and part B's prompts transfer to it unchanged |

`data/MX_Dengue_trends.csv` is the older curated SISMID file, kept because part A checks the live download against it and the two disagree in an instructive way.

There is **no student data in this repository**. The roster example in notebook 02 is fabricated; it preserves the structure of the real problem and none of the people.

## For instructors reusing this

[`secrets/README.md`](secrets/README.md) explains the encrypted class credential: how to create, rotate and revoke it, and why the passcode is the entire security model.

## Related

- [`Shihao-Yang/sismid2026`](https://github.com/Shihao-Yang/sismid2026): the full SISMID 2026 short course this material was distilled from.
- [ARGO](https://www.pnas.org/doi/10.1073/pnas.1515373112): Yang, Santillana & Kou, *PNAS* 112(47), 2015.

## License

Teaching material, released under [CC BY 4.0](LICENSE). Use it, fork it, teach with it.

Questions: shihao.yang@isye.gatech.edu
