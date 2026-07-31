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
| **[`notebooks/01_research_dengue.ipynb`](notebooks/01_research_dengue.ipynb)** | **Research, hands-on.** The four prompts that rebuild the ARGO model (Yang, Santillana & Kou, *PNAS* 2015) on Mexican dengue data, with empty cells for your agent to fill. |
| **[`notebooks/01_research_dengue_soln.ipynb`](notebooks/01_research_dengue_soln.ipynb)** | **Research, worked.** The same thing executed, with figures, a model comparison table, and my honest reading of the results. Your fallback if the agent is not cooperating. |
| **[`notebooks/02_education_reading_group.ipynb`](notebooks/02_education_reading_group.ipynb)** | **Education.** The agent as the instructor's TA: Canvas as an API, a mailing list reconstructed from three email threads, recordings to transcripts to summaries. |

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

`data/MX_Dengue_trends.csv` holds monthly reported dengue cases in Mexico (`Dengue CDC`) alongside Google search interest for four Spanish-language terms, 2004-2011 (96 months). From the [MIGHTE-lab SISMID](https://github.com/MIGHTE-lab/SISMID25) teaching materials.

There is **no student data in this repository**. The roster example in notebook 02 is fabricated; it preserves the structure of the real problem and none of the people.

## For instructors reusing this

[`secrets/README.md`](secrets/README.md) explains the encrypted class credential: how to create, rotate and revoke it, and why the passcode is the entire security model.

## Related

- [`Shihao-Yang/sismid2026`](https://github.com/Shihao-Yang/sismid2026): the full SISMID 2026 short course this material was distilled from.
- [ARGO](https://www.pnas.org/doi/10.1073/pnas.1515373112): Yang, Santillana & Kou, *PNAS* 112(47), 2015.

## License

Teaching material, released under [CC BY 4.0](LICENSE). Use it, fork it, teach with it.

Questions: shihao.yang@isye.gatech.edu
