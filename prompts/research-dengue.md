# The research prompts, verbatim

Every prompt from [`notebooks/01_research_dengue.ipynb`](../notebooks/01_research_dengue.ipynb),
in order. Copy them into Claude Code or Codex with the notebook open beside it.

Four prompts take you from a raw CSV to a working ARGO model with dynamic training, LASSO term
selection, and a leak-free out-of-sample comparison against three benchmarks.

---

## 1. Get oriented

> There is a CSV at `data/MX_Dengue_trends.csv`. `Dengue CDC` is monthly reported dengue cases
> in Mexico; the other columns are Google search interest for Spanish dengue terms. Load it,
> tell me the date range and the number of months, and plot cases against the `dengue` search
> series on a twin axis. Print the correlation of every search column with cases.

Notice what is absent: no pandas, no `parse_dates`, no matplotlib. Describe the outcome and
let the agent choose the plumbing.

**Your check, not the agent's:** do the seasonal peaks land where dengue season actually is?

---

## 2. The honest baseline

> Fit ordinary least squares of `Dengue CDC` on the single `dengue` search column, training only
> on 2004-2006. Then predict 2007-2011 from that frozen fit and report out-of-sample RMSE and
> correlation. Do not refit on anything after 2006.

That last sentence is load-bearing. Leakage is the most common way this kind of analysis goes
quietly wrong, and an agent optimizing for a good-looking number will refit if you let it.

---

## 3. Now make it ARGO

> Now build the ARGO model from Yang, Santillana and Kou (PNAS 2015), adapted to this monthly
> data. Work in log space. Regress log cases on the logs of all four search terms plus three
> autoregressive lags of log cases. Use L1 regularization with cross-validated penalty, and
> retrain on a rolling 36-month window at every time step so the model only ever sees the past.
> Also fit two references on the identical rolling scheme: an autoregression-only model, and a
> search-only model. Return all predictions on the original case scale.

Two structural ideas carry ARGO, and they are both in this paragraph: **autoregression** and
**dynamic training**.

---

## 4. Score everything against each other

> Build one comparison table over the common evaluation window: RMSE, MAE, and correlation for
> the static baseline, the autoregression-only model, the search-only model, and ARGO. Add a
> column giving each model's RMSE relative to the autoregression benchmark. Then plot the ARGO
> prediction against the truth over time.

---

## The prompt that is not in the notebook

After every step, some version of this, and it is the one that matters:

> Walk me through what you just did, line by line. Where did you have to make a choice I did
> not specify? What would break if my data were slightly different?

In this notebook that question surfaces `np.log1p`. The agent used it instead of `log` because
40% of one search column is exactly zero, and it never said so. The patch was correct. The
silence was the problem, because those zeros are Google Trends thresholding low search volume
away, which is missingness dressed up as a small number, and that changes what the model can
honestly claim.

---

## Reusing this shape

The transferable object is not the dengue result, it is the sequence:

**orient → baseline → add the real method → verify → compare**

Swap the disease, the geography, the data stream. At SISMID a student took an outbreak-detection
exercise in this shape and pointed it at West Nile virus in an afternoon. The scaffold holds.

Try it with your own problem:

> I have [data] measuring [quantity] over [period]. I want to predict [target]. Start by
> loading it and showing me what is there, then propose the simplest honest baseline before we
> do anything clever.
