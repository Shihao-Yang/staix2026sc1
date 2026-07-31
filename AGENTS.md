# Repo orientation for coding agents

This repo's guidance lives in [`CLAUDE.md`](CLAUDE.md). It is plain markdown and applies to any agent, not just Claude Code. **Read it before editing anything here.**

The short version, because these three constraints are easy to violate by accident:

1. **`00_start_here.md` and the notebooks are the talk.** There are no slides, deliberately, and there is no `docs/` or `prompts/` directory: prose lives in the root markdown file and every prompt lives in the notebook that uses it. Do not reintroduce those directories. `01_research_dengue_soln.ipynb` and `02_education_reading_group.ipynb` are committed *with their outputs*; re-execute them if you change a code cell. `01_research_dengue.ipynb` is the hands-on version and its code cells are **meant to be empty**, so do not helpfully fill them in.
2. **Results are reported honestly and must not be inflated.** The dengue model beats its benchmark by only about 2.5%. That modest number is the teaching point.
3. **No student data, ever.** The roster in notebook 02 is fabricated. Real names and addresses must not enter this public repo.

Also: **no em dashes** in English prose here.
