# Simple Linear Regression — Python & R (PAS 7030 Week 3 / Assignment 3)

> **AI-generated README** (Assignment 3, Part B). Produced by Cursor from repository code and docs.  
> Identical content lives at the repo root [`README.md`](../README.md) (updated from Week 2). Compare paths/roles for Part C reflection if needed.

This repository implements the **same data-science workflow twice**: predict **Salary** from **Years of Experience** using simple linear regression (a straight-line statistical model). One version is hand-written (`manual/`); the other is AI-assisted (`ai/`).

The guide below is written for **two audiences**:

- **Beginners** — plain-language steps to open notebooks, run scripts, and understand what the numbers mean.
- **Advanced readers** — implementation details, git layout, environment setup on HPC, and how the two code paths differ.

For a structured comparison of Part A vs Part B (excluding the Part C essay), see [`CODE_REVIEW.md`](CODE_REVIEW.md).

An identical copy of this README lives at the repo root [`README.md`](../README.md).

---

## Table of contents

1. [The problem in plain language](#the-problem-in-plain-language)
2. [Repository layout](#repository-layout)
3. [Quick start (beginners)](#quick-start-beginners)
4. [What each notebook does](#what-each-notebook-does)
5. [Running scripts from the terminal](#running-scripts-from-the-terminal)
6. [Output files](#output-files)
7. [The model and metrics](#the-model-and-metrics)
8. [Manual vs AI — key differences](#manual-vs-ai--key-differences)
9. [Environment setup (detailed)](#environment-setup-detailed)
10. [Git branches and workflow](#git-branches-and-workflow)
11. [Exporting and re-running notebooks](#exporting-and-re-running-notebooks)
12. [Troubleshooting](#troubleshooting)
13. [Assignment context (PAS 7030)](#assignment-context-pas-7030)
14. [Further reading in this repo](#further-reading-in-this-repo)

---

## The problem in plain language

You have a small spreadsheet, [`regression_data.csv`](regression_data.csv), with two columns:

| Column | Meaning |
|--------|---------|
| `YearsExperience` | How long someone has worked |
| `Salary` | What they earn (USD) |

There are **10 rows** — one row per person. We want to answer:

> *As experience increases, how much does salary tend to go up?*

**Simple linear regression** finds the straight line that best fits the scatter of points. That line is useful for:

1. **Visualizing** the trend (dots + line)
2. **Summarizing** the trend with two numbers — a starting salary (intercept) and pay increase per year (slope)
3. **Scoring** how well the line fits (R², MSE, and related metrics)

Python and R use different syntax and plotting libraries, but for ordinary least squares (OLS) on the same data they should produce **the same coefficients**.

---

## Repository layout

```
linear-regression-jupyter/
├── regression_data.csv       # Shared dataset (10 rows)
├── environment.yml           # Conda environment (Python 3.10, Jupyter, R, IRkernel)
├── requirements.txt          # Python pip packages (pandas, matplotlib, scikit-learn, scipy)
├── setup_env.sh              # One-time HPC/class environment bootstrap
├── README.md                 # Project README (identical to ai/README_AI.md)
├── manual/                   # Part A — hand-written (no AI)
│   ├── regression_python.ipynb / .html / .py
│   ├── regression_r.ipynb / .html / .r
│   └── *.png                 # Plot outputs from scripts/notebooks
└── ai/                       # Part B — AI-assisted rebuild
    ├── regression_python.ipynb / .html / .py / .png
    ├── regression_r.ipynb / .html / .r / .png
    ├── PROMPTS.md            # Key AI prompts (submission artifact)
    ├── prompt_history.md     # Timestamped prompt/action log
    ├── CHAT_SESSION.md       # Full AI pair-programming session record
    ├── CODE_REVIEW.md        # Part A vs Part B code review (2026-07-16)
    └── README_AI.md          # This file (Part B deliverable; same as root README)
```

| Folder | Role |
|--------|------|
| **`manual/`** | Your original typed work. Positional CLI scripts. Part A deliverables. |
| **`ai/`** | Same workflow rebuilt via AI prompting. Named CLI flags, validation, richer metrics. Part B deliverables. |

Notebooks read the CSV with `../regression_data.csv`, so launch Jupyter from the **project root** (or ensure that relative path resolves).

---

## Quick start (beginners)

### Step 1 — Activate the environment

On the OSC class cluster (example):

```bash
module load miniconda3/24.1.2-py310
conda activate 7030_class_2
cd /path/to/linear-regression-jupyter
```

If the environment does not exist yet, run `./setup_env.sh` once (see [Environment setup](#environment-setup-detailed)).

### Step 2 — Open Jupyter Lab

```bash
jupyter lab --no-browser --port=2000
```

Use the URL and token printed in the terminal (on OSC, typically via SSH port forwarding).

### Step 3 — Pick a notebook

| Goal | Open |
|------|------|
| Hand-written Python | `manual/regression_python.ipynb` |
| Hand-written R | `manual/regression_r.ipynb` |
| AI-built Python | `ai/regression_python.ipynb` |
| AI-built R | `ai/regression_r.ipynb` |

Select the correct kernel:

- **Python (7030_class_2)** for Python notebooks
- **R (7030_class_2)** for R notebooks

Run all cells: **Kernel → Restart Kernel and Run All Cells**.

You should see data previews, scatter plots with a regression line, and model numbers.

### Step 4 — Or run a script (no Jupyter)

From the project root:

```bash
# Part A — manual (positional arguments: file, x column, y column)
python manual/regression_python.py regression_data.csv YearsExperience Salary
Rscript manual/regression_r.r regression_data.csv YearsExperience Salary

# Part B — AI (named flags)
python ai/regression_python.py --filepath regression_data.csv --x-col YearsExperience --y-col Salary
Rscript ai/regression_r.r --filepath regression_data.csv --x-col YearsExperience --y-col Salary
```

Each script prints metrics and saves a PNG (see [Output files](#output-files)).

---

## What each notebook does

Both Python and R notebooks follow the same story:

| Step | What happens |
|------|----------------|
| 1. Load | Read `regression_data.csv` |
| 2. Explore | Preview rows; sometimes separate `x` and `y` cells (manual) or a summary table (ai) |
| 3. Scatter | Plot experience vs salary |
| 4. Fit | Estimate intercept and slope (OLS) |
| 5. Overlay | Draw the fitted line on the scatter |
| 6. Evaluate | Print R², MSE, and/or `summary(model)`; Part B also shows equation and metrics on the plot |

**Manual notebooks** are more exploratory (e.g., individual cells for `x` and `y`). The `assignment_3` branch adds on-plot annotations: regression equation, correlation **r**, and MSE.

**AI notebooks** use section headers, a single coherent pipeline, and an annotation box with equation, **R²**, and MSE.

---

## Running scripts from the terminal

### Part A — manual scripts

**Interface:** three positional arguments.

```bash
python manual/regression_python.py <csv_file> <x_column> <y_column>
Rscript manual/regression_r.r <csv_file> <x_column> <y_column>
```

Example:

```bash
python manual/regression_python.py regression_data.csv YearsExperience Salary
```

The Python script uses `sys.argv`; the R script uses `commandArgs(trailingOnly = TRUE)`.

### Part B — AI scripts

**Interface:** named flags (via `argparse` in Python; custom parser in R).

```bash
python ai/regression_python.py --filepath regression_data.csv --x-col YearsExperience --y-col Salary
Rscript ai/regression_r.r --filepath regression_data.csv --x-col YearsExperience --y-col Salary
```

Both AI scripts validate that the file exists, columns are present, and values are numeric before fitting.

---

## Output files

| Version | Python plot | R plot |
|---------|-------------|--------|
| **manual/** scripts | `linear_regression_python_output.png` (cwd) | `linear_regression_r_output.png` (cwd) |
| **manual/** notebooks (`assignment_3`) | `manual/regression_plot_python.png` | `manual/regression_plot_r.png` |
| **ai/** scripts & notebooks | `ai/regression_python.png` | `ai/regression_r.png` |

HTML files (`.html`) are static snapshots of notebooks — useful for submission or sharing without a live Jupyter server.

---

## The model and metrics

### The equation

We fit:

$$\text{Salary} = \beta_0 + \beta_1 \times \text{YearsExperience} + \varepsilon$$

| Symbol | Name | Meaning on this dataset |
|--------|------|-------------------------|
| $\beta_0$ | Intercept | Predicted salary at 0 years experience (~$29,204) |
| $\beta_1$ | Slope | Extra salary per year of experience (~$8,285/year) |
| $\varepsilon$ | Error | Residual — what the line does not explain |

### Fit metrics (this dataset)

| Metric | Value | Interpretation |
|--------|-------|----------------|
| **R²** | ~0.785 | About 79% of salary variation is explained by experience alone |
| **MSE** | ~17,523,844 | Average squared prediction error (same units as salary²) |
| **RMSE** | ~4,186 | Typical prediction error in dollars (~√MSE) |
| **r** (Pearson) | ~0.886 | Linear correlation; note **r² = R²** for simple regression |

Python (Part B) uses `sklearn.linear_model.LinearRegression` and `sklearn.metrics`. R uses base `lm()` and `summary()`. Both use **ordinary least squares**, so coefficients should match.

---

## Manual vs AI — key differences

| Topic | `manual/` | `ai/` |
|-------|-----------|-------|
| CLI | Positional `file x y` | Named `--filepath`, `--x-col`, `--y-col` |
| Validation | Assumes valid input | Checks file, columns, numeric types |
| Python fit | sklearn + scipy `linregress` (Part A updates) | sklearn only |
| R plot | `geom_line` + sometimes `geom_smooth` | `geom_abline` from coefficients |
| On-plot text | Equation, **r**, MSE | Equation, **R²**, MSE |
| Extra console metrics | R², MSE | R², MSE, RMSE, MAE |
| Documentation | — | `PROMPTS.md`, logs, `CODE_REVIEW.md` |

These differences are **intentional** for the assignment: Part B is graded on correctness, not identical code. Part C asks you to reflect on *how* the approaches diverged.

---

## Environment setup (detailed)

### Conda environment

Defined in [`environment.yml`](environment.yml):

| Component | Detail |
|-----------|--------|
| Env name | `7030_class_2` |
| Python | 3.10 |
| Jupyter | JupyterLab + ipykernel |
| R | r-base + r-irkernel |

Python packages via [`requirements.txt`](requirements.txt):

```
pandas
matplotlib
scikit-learn
scipy          # used in manual/ for scipy.stats.linregress
```

R plotting uses **ggplot2** (manually installed in the class environment per course instructions).

### First-time setup

```bash
module load miniconda3/24.1.2-py310
./setup_env.sh
```

Or manually:

```bash
conda env create -f environment.yml
conda activate 7030_class_2
pip install -r requirements.txt

python -m ipykernel install --user --name 7030_class_2 --display-name "Python (7030_class_2)"
Rscript -e 'IRkernel::installspec(name="ir_7030_class_2", displayname="R (7030_class_2)")'
```

### Kernels in notebooks

| Notebook folder | Python kernel metadata | R kernel metadata |
|-----------------|------------------------|-------------------|
| `manual/` | Often `7030_class_1` (legacy) | `ir` or course R kernel |
| `ai/` | `7030_class_2` | `ir_7030_class_2` |

If a kernel is missing, re-run the registration commands above or pick the closest match in Jupyter’s kernel menu.

---

## Git branches and workflow

| Branch | Typical contents |
|--------|------------------|
| `main` | Course baseline + `manual/` deliverables |
| `assignment_3` | Part A updates (annotations, MSE, scipy) — PR into `main` |
| `ai-coding` | Part B AI work under `ai/` |

**Agent / automation policy:** edits for AI-assisted work go on `ai-coding`; merge to `main` manually when ready:

```bash
git checkout main
git merge ai-coding    # or assignment_3 for Part A
git push origin main
```

Both `manual/` and `ai/` coexist after merge — neither replaces the other.

---

## Exporting and re-running notebooks

### Export to HTML (static)

```bash
cd manual/    # or ai/
jupyter nbconvert --to html regression_python.ipynb
jupyter nbconvert --to html regression_r.ipynb
```

For R, if execution is needed during export:

```bash
jupyter nbconvert --execute --to html regression_r.ipynb \
  --ExecutePreprocessor.kernel_name=ir_7030_class_2
```

### Re-execute in place

```bash
jupyter nbconvert --execute --inplace regression_python.ipynb \
  --ExecutePreprocessor.kernel_name=7030_class_2

jupyter nbconvert --execute --inplace regression_r.ipynb \
  --ExecutePreprocessor.kernel_name=ir_7030_class_2
```

---

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| **Kernel not found** | Re-register kernels (see [Environment setup](#environment-setup-detailed)) |
| **CSV not found** | Start Jupyter from project root; notebooks use `../regression_data.csv` |
| **`ModuleNotFoundError`** | `conda activate 7030_class_2` and `pip install -r requirements.txt` |
| **R notebook runs as Python** | Select **R (7030_class_2)** kernel |
| **Matplotlib font cache warning** | Harmless on shared HPC; plot still saves. Remove stale lock in `~/.cache/matplotlib/` if needed |
| **R script ignores column args** | Known issue on some `manual/` script versions — see [`ai/CODE_REVIEW.md`](ai/CODE_REVIEW.md) |
| **Two regression lines in R plot** | `geom_line` + `geom_smooth` both draw a line — use one (documented in code review) |

---

## Assignment context (PAS 7030)

| Part | Folder | Requirement summary |
|------|--------|---------------------|
| **A** | `manual/` | No AI. Type notebooks and scripts yourself. CSV → scatter → fit → line → evaluate. HTML + CLI. |
| **B** | `ai/` | Rebuild with AI. Same workflow; graded on correctness. Include prompt logs. |
| **C** | (written) | Reflect on differences between manual and AI approaches — see comparison table above and [`ai/CODE_REVIEW.md`](ai/CODE_REVIEW.md). |

---

## Further reading in this repo

| Document | Contents |
|----------|----------|
| [`CODE_REVIEW.md`](CODE_REVIEW.md) | Part A PR review, Part B review, side-by-side comparison, rubric checklists |
| [`PROMPTS.md`](PROMPTS.md) | Condensed key prompts for Part B |
| [`prompt_history.md`](prompt_history.md) | Timestamped prompt and action log |
| [`CHAT_SESSION.md`](CHAT_SESSION.md) | Full AI pair-programming session transcript |
| [`README_AI.md`](README_AI.md) | This file (Part B deliverable; same as root README) |
| [`../README.md`](../README.md) | Project README at repo root |

---

## License / course use

Course materials for PAS 7030 Week 3 (Assignment 3). Use and adapt per instructor guidelines.
