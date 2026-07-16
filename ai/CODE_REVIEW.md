# Code Review — Assignment 3 PR (`assignment_3` → `main`)

**Course:** PAS 7030 · **Assignment:** 3 — Git and Improvements to Assignment 2  
**Review date:** 2026-07-16  
**Reviewer:** Cursor AI agent (Assignment 3, Part B — AI code review)  
**Saved to:** `ai/CODE_REVIEW.md` (per Part B requirements)

**Scope:** Part A PR diff (`main...assignment_3` on `manual/`) and Part B deliverables (`ai/` on `ai-coding`). Part C (`REFLECTION.md`) is out of scope for this document.

---

## Assignment 3 context

| Part | Points | This review covers |
|------|--------|-------------------|
| **A — Manual** | 20 | PR diff: annotated regression, diagnostics, Git workflow |
| **B — AI** | 12 | This file + prompts for commit messages, README (`README_AI.md`) |
| **C — Reflection** | 8 | Not reviewed here — you write `REFLECTION.md` yourself |

**Part A requirement (summary):** Enhance Assignment 2 regression with **detailed diagnostics and annotated plots** in both Python and R (notebooks + scripts). Demonstrate GitHub workflow (branch, PR, tag). Hand-written root `README.md`.

**Part B requirement (summary):** AI commit messages, **this code review**, AI `README_AI.md` (do not overwrite manual README), and `PROMPTS.md` logging prompts for all three.

---

## Branches reviewed

| Branch | Base | What it contains |
|--------|------|------------------|
| `assignment_3` | `main` | Part A updates: MSE, equation, and correlation annotations in `manual/` |
| `ai-coding` | `main` | Part B deliverables: AI-built notebooks, scripts, HTML, PNGs, prompt logs |

**PR diffs examined:**

- `main...assignment_3` — 11 files, +2,159 / −917 lines (mostly notebook/HTML re-execution and PNG binaries)
- `main...ai-coding` — 11 files under `ai/` (+ README on earlier commit)

---

## Assignment requirements (Parts A & B)

From the PAS 7030 Week 2 brief and repository structure, each part should provide **parallel Python and R workflows** that:

1. Read a CSV with configurable columns (experience → salary)
2. Produce a **scatter plot**
3. **Fit a simple linear regression** (one predictor)
4. **Overlay the fitted line** on the scatter
5. **Evaluate** the model (at minimum R² or equivalent summary)
6. Export **Jupyter notebooks**, **HTML**, and **runnable CLI scripts** that accept filepath and column names
7. Part B additionally requires **AI prompt documentation** (`PROMPTS.md`, logs)

Part C (compare manual vs AI approaches) is intentionally excluded from this review.

---

## Executive summary

| Part | Verdict | Summary |
|------|---------|---------|
| **A — `assignment_3` PR** | **Meets core requirements with minor issues** | Notebooks and scripts run, add useful on-plot annotations (equation, MSE). Several consistency and polish items remain (dual fit paths in Python, hardcoded columns in R script, duplicate regression layers in R ggplot, mismatched PNG filenames). |
| **B — `ai-coding`** | **Strong — ready for submission** | Complete, validated pipeline in both languages; named CLI flags; input validation; R², MSE, RMSE, MAE; on-plot equation/R²/MSE; prompt logs present. Differences from Part A are appropriate and documentable in Part C. |

Both implementations produce **matching coefficients and MSE** on `regression_data.csv`:

| Metric | Python | R |
|--------|--------|---|
| Intercept (β₀) | 29,203.52 | 29,203.52 |
| Slope (β₁) | 8,285.29 | 8,285.29 |
| R² | 0.7852 | 0.7852 |
| MSE | 17,523,844.08 | 17,523,844 |

---

## Part A review — `assignment_3` PR (`manual/`)

**Commit:** `4b57795` — *Added regression model with equation annotation*

### What changed (source-level)

| File | Changes |
|------|---------|
| `manual/regression_python.ipynb` | Added `scipy.stats.linregress`, `mean_squared_error`; annotated plot with equation, **r**, MSE; saves `regression_plot_python.png` |
| `manual/regression_python.py` | Same logic exported to script; still uses positional `sys.argv` CLI |
| `manual/regression_r.ipynb` | Computes slope, intercept, **r**, MSE; ggplot with `geom_line` + `geom_smooth`; annotation box; saves `regression_plot_r.png` |
| `manual/regression_r.r` | Same as notebook export; **regresses on hardcoded `Salary ~ YearsExperience`** despite CLI column args |
| `requirements.txt` | Added `scipy` (needed for `linregress`) |
| PNG / HTML | Re-executed outputs committed (`linear_regression_*_output.png`, new `regression_plot_*.png`) |

### Strengths

- **Core workflow complete:** load → scatter → fit → line overlay → metrics → save plot.
- **On-plot annotations** satisfy the instructor-style ask for equation and MSE on the figure.
- **Python metrics are numerically correct:** `linregress` and `LinearRegression` agree on this dataset (verified: identical β₀, β₁, MSE).
- **R notebook** computes MSE from residuals and displays it on the plot.
- **`scipy` dependency** is documented in `requirements.txt`.

### Issues and recommendations

#### 1. Python uses two fitting paths (redundant but consistent)

The notebook fits with **sklearn `LinearRegression`** and separately with **`scipy.stats.linregress`**, then plots predictions from `linregress`. Coefficients match here, but a grader may ask why both exist.

**Recommendation:** Pick one primary fit (sklearn is already imported) and derive r or R² from that single model. Keep `linregress` only if the assignment explicitly requires it.

#### 2. Plot shows Pearson **r**, not **R²**

Annotation uses `r = {r_value:.2f}` (~0.89) while a separate cell prints sklearn **R²** (~0.79). These are related (`r² = R²` for simple linear regression) but **labeling r on the plot while printing R² elsewhere is confusing**.

**Recommendation:** Either label the plot with **R²** (to align with the evaluation cell and Part B) or add a brief comment explaining r vs R².

#### 3. Inconsistent PNG filenames (notebook vs script)

| Artifact | Python | R |
|----------|--------|---|
| Notebook | `regression_plot_python.png` | `regression_plot_r.png` |
| Script | `linear_regression_python_output.png` | `linear_regression_r_output.png` |

**Recommendation:** Use one naming convention across notebook and script (either is fine; consistency matters for grading scripts).

#### 4. R script ignores CLI column arguments (regression bug for general CSVs)

`regression_r.r` accepts `x_col` / `y_col` but the model and ggplot still hardcode `YearsExperience` and `Salary`:

```r
model <- lm(Salary ~ YearsExperience, data=dataset)
geom_point(aes(x = dataset$YearsExperience, y = dataset$Salary), ...)
```

The **main-branch script** already used a dynamic `formula <- as.formula(paste(y_col, "~", x_col))` for `lm()` but still hardcoded column names in ggplot. The PR **regressed** the formula usage in the script while improving the notebook.

**Recommendation:** Use `x_col` / `y_col` in `lm()`, `aes()`, and axis labels so the script works with arbitrary numeric columns (as the CLI contract implies).

#### 5. R ggplot draws the regression line twice

Both `geom_line(... predict(model) ...)` and `geom_smooth(method = "lm")` are layered. This can produce **two nearly identical lines** (blue + red) and is redundant.

**Recommendation:** Keep one approach — either explicit `geom_line` from `predict()` or `geom_abline(intercept=..., slope=...)` — not both plus `geom_smooth`.

#### 6. Minor script quality notes

- Python script still contains `# In[7]:` notebook cell markers from export.
- R script includes exploratory `scatter <- plot(...)` and bare `dataset` expressions (notebook artifacts).
- Matplotlib font-cache **stderr** appears in re-executed notebook/HTML (harmless on HPC; not a functional error).

### Part A rubric checklist

| Requirement | Status | Notes |
|-------------|--------|-------|
| Python notebook runs end-to-end | ✅ | Kernel `7030_class_1` in metadata (class env may use `7030_class_2`) |
| R notebook runs end-to-end | ✅ | Uses ggplot2 |
| Scatter + fitted line | ✅ | Both languages |
| Model evaluation | ✅ | R² cell (Python); `summary(model)` (R); MSE added |
| On-plot equation + error metric | ✅ | Equation, r, MSE |
| Python CLI script | ✅ | Positional args |
| R CLI script | ⚠️ | Runs for default columns; **CLI columns not wired through** |
| HTML exports | ✅ | Re-generated in PR |
| No AI in Part A | ✅ | Hand-edited workflow |

**Part A overall:** Submittable with fixes recommended for R script column handling and ggplot redundancy.

---

## Part B review — `ai-coding` branch (`ai/`)

**Latest commit:** `283c556` — *Add MSE and on-plot model annotations to AI regression deliverables.*

### Deliverables inventory

| File | Purpose | Status |
|------|---------|--------|
| `regression_python.ipynb` | Python notebook (`7030_class_2`) | ✅ |
| `regression_r.ipynb` | R notebook (`ir_7030_class_2`) | ✅ |
| `regression_python.py` / `.r` | Parameterized CLI scripts | ✅ |
| `regression_python.html` / `.r.html` | Static exports | ✅ |
| `regression_python.png` / `.r.png` | Sample plot outputs | ✅ |
| `PROMPTS.md` | Key prompts (6 entries) | ✅ |
| `prompt_history.md` | Timestamped log | ✅ |
| `CHAT_SESSION.md` | Full session transcript | ✅ |

### Strengths

- **Single, clear fit path** per language (`LinearRegression` / `lm()`).
- **Named CLI flags** (`--filepath`, `--x-col`, `--y-col`) with file/column validation and helpful errors.
- **Dynamic columns** throughout — scripts generalize beyond the sample dataset.
- **Rich evaluation:** R², MSE, RMSE, MAE in console; equation, R², MSE on plot.
- **Explicit regression line:** Python uses `model.predict` on a linspace; R uses `geom_abline` from coefficients (teaching-friendly, not hidden in `geom_smooth`).
- **Outputs saved beside scripts** in `ai/` (predictable paths for grading).
- **Prompt documentation** exceeds minimum (plan-first workflow, iteration history, verification tables).

### Minor notes (non-blocking)

- AI Python plot uses **R²** on-graph; manual Part A uses **r** — good Part C discussion point.
- AI adds **RMSE/MAE** beyond strict minimum; acceptable enhancement.
- Matplotlib font-cache warning may appear in notebook stderr on shared systems.

### Part B rubric checklist

| Requirement | Status | Notes |
|-------------|--------|-------|
| Rebuilt workflow with AI | ✅ | Documented in prompt logs |
| Python + R notebooks | ✅ | Correct kernels |
| Scatter + fitted line + evaluation | ✅ | Plus extended metrics |
| CLI scripts with column args | ✅ | Named flags |
| HTML + PNG outputs | ✅ | |
| Prompt history | ✅ | `PROMPTS.md` + logs |
| Correct numerical results | ✅ | Matches Part A coefficients |

**Part B overall:** Ready for submission.

---

## Side-by-side comparison — `manual/` vs `ai/`

| Topic | Part A (`manual/` / `assignment_3`) | Part B (`ai/` / `ai-coding`) |
|-------|--------------------------------------|------------------------------|
| **CLI interface** | Positional: `file x y` | Named: `--filepath`, `--x-col`, `--y-col` |
| **Input validation** | Minimal (assumes valid CSV/columns) | File exists, columns present, numeric coercion |
| **Python fitting** | sklearn + scipy `linregress` | sklearn only |
| **R fitting** | `lm()`; notebook hardcodes column names | Dynamic formula from CLI args |
| **R line on plot** | `geom_line` + `geom_smooth` (duplicate) | `geom_abline` from coefficients |
| **On-plot stats** | Equation, **r**, MSE | Equation, **R²**, MSE |
| **Console metrics** | R² (Python), MSE; R `summary()` | R², MSE, RMSE, MAE |
| **PNG names** | Mixed: `regression_plot_*` / `linear_regression_*_output` | Consistent: `regression_python.png`, `regression_r.png` in `ai/` |
| **Notebook style** | Exploratory cells (`x`, `y` separately) | Section headers, combined workflow |
| **Extra files** | — | Prompt logs, committed sample PNGs |
| **Dependencies** | + `scipy` in requirements | Uses sklearn metrics (no scipy) |

These differences are **expected and valid** for Part B grading (correctness over identical code). They also provide strong material for Part C reflection later.

---

## Suggested pre-merge / pre-submission actions

### Part A (`assignment_3`)

1. Fix R script to use `x_col` / `y_col` in `lm()` and ggplot aesthetics.
2. Remove duplicate `geom_smooth` (or duplicate `geom_line`) in R notebook and script.
3. Align PNG filenames between notebooks and scripts.
4. Consider showing **R²** on plots instead of (or in addition to) **r** for consistency with evaluation cells.
5. Optionally strip notebook export artifacts (`# In[n]:`) from `.py` / `.r` scripts.

### Part B (`ai-coding`)

- No blocking changes. Optional: merge `main` after Part A lands to keep both folders current in one branch for final submission.

### Repository

- Root `README.md` matches `ai/README_AI.md` (Week 3 refresh from Week 2 AI README). Part B still keeps `README_AI.md` as the named deliverable.
- This file records the comparison for Part C prep and satisfies the Part B code-review deliverable.

---

## Substantive findings — address at least one (Part B requirement)

Part B asks you to **address at least one substantive comment** from this review if you agree. Recommended fixes on `assignment_3` (Part A):

| Priority | Finding | Suggested fix | Agree? |
|----------|---------|---------------|--------|
| **High** | R script ignores CLI `x_col` / `y_col` | Use dynamic formula and `aes()` in `manual/regression_r.r` | ☐ Address on `assignment_3` |
| **High** | R ggplot draws regression line twice (`geom_line` + `geom_smooth`) | Remove one layer in notebook and script | ☐ Address on `assignment_3` |
| Medium | Python plot shows **r** but evaluation cell prints **R²** | Label plot with R² or add a short comment | Optional |
| Medium | PNG filenames differ between notebook and script | Pick one naming convention | Optional |

*Check a box and apply the fix on your Part A branch before merge, then note what you changed in Part C reflection.*

---

## Verification commands

```bash
conda activate 7030_class_2
cd /path/to/linear-regression-jupyter

# Part A scripts (assignment_3 branch)
python manual/regression_python.py regression_data.csv YearsExperience Salary
Rscript manual/regression_r.r regression_data.csv YearsExperience Salary

# Part B scripts (ai-coding branch)
python ai/regression_python.py --filepath regression_data.csv --x-col YearsExperience --y-col Salary
Rscript ai/regression_r.r --filepath regression_data.csv --x-col YearsExperience --y-col Salary
```

Expected: exit code 0; plots saved; R² ≈ 0.7852; MSE ≈ 17,523,844.

---

## Part C (deferred)

Not reviewed here. When you write Part C, use the **Side-by-side comparison** table and **Design decisions** in `CHAT_SESSION.md` as starting points: CLI design, metric choices (r vs R²), ggplot layering, plan-first AI workflow, and intentional isolation of Part B from Part A during initial AI build.
