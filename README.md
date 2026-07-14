# Week 2: Simple Linear Regression (Python & R)

This repository contains two parallel implementations of the same data-science workflow: **predict salary from years of experience** using a straight-line statistical model (simple linear regression). One version was built by hand (`manual/`); the other was built with AI assistance (`ai/`).

You do not need to be an expert programmer to use this project. The sections below start with plain-language explanations, then add technical detail for experienced developers.

---

## What problem does this solve?

**In plain terms:** We have a spreadsheet (`regression_data.csv`) with two columns:

- **YearsExperience** — how long someone has worked  
- **Salary** — what they earn  

We want to answer: *“As experience goes up, how much does salary tend to increase?”*

A **linear regression** draws the best straight line through the scatter of points. That line can be used to:

1. **Visualize** the trend (scatter plot + line)  
2. **Summarize** the trend with two numbers: a starting salary (intercept) and pay increase per year (slope)  
3. **Score** how well the line fits (metrics like R²)

Both Python and R notebooks/scripts do the same math; they differ mainly in syntax and plotting libraries.

---

## Repository layout

```
Week_2/
├── regression_data.csv      # Shared dataset (10 rows)
├── environment.yml          # Conda environment definition
├── requirements.txt         # Python pip packages
├── setup_env.sh             # HPC/class environment setup helper
├── manual/                  # Part A: hand-written work (no AI)
│   ├── regression_python.ipynb / .html / .py
│   └── regression_r.ipynb / .html / .r
└── ai/                      # Part B: AI-assisted rebuild
    ├── regression_python.ipynb / .html / .py / .png
    ├── regression_r.ipynb / .html / .r / .png
    ├── PROMPTS.md           # Key AI prompts used
    ├── prompt_history.md    # Detailed prompt/action log
    └── CHAT_SESSION.md      # Full AI pair-programming session record
```

| Folder | Purpose |
|--------|---------|
| **`manual/`** | Your original, typed-by-hand notebooks and scripts. |
| **`ai/`** | Same workflow rebuilt via AI prompting (plan → iterate → execute). |

The dataset lives at the project root so both folders can read it with `../regression_data.csv`.

---

## Quick start (beginners)

### 1. Open the environment

On the class cluster (OSC example):

```bash
module load miniconda3/24.1.2-py310
conda activate 7030_class_2
cd /path/to/Week_2
```

If the environment does not exist yet, run `./setup_env.sh` once (see [Environment setup](#environment-setup-pros)).

### 2. Run a notebook in Jupyter

```bash
jupyter lab --no-browser --port=2000
```

Open either:

- `manual/regression_python.ipynb` or `ai/regression_python.ipynb` (Python)  
- `manual/regression_r.ipynb` or `ai/regression_r.ipynb` (R)  

Run cells top to bottom (**Kernel → Restart & Run All**). You should see tables, plots, and model numbers.

### 3. Run a script from the terminal (no Jupyter)

**Manual scripts** use three positional arguments: `filename`, `x_column`, `y_column`.

```bash
# From Week_2 root — manual version
python manual/regression_python.py regression_data.csv YearsExperience Salary
Rscript manual/regression_r.r regression_data.csv YearsExperience Salary
```

**AI scripts** use named flags:

```bash
python ai/regression_python.py --filepath regression_data.csv --x-col YearsExperience --y-col Salary
Rscript ai/regression_r.r --filepath regression_data.csv --x-col YearsExperience --y-col Salary
```

Each script saves a PNG plot (see [Output files](#output-files)).

---

## What each notebook does (step by step)

Both Python and R notebooks follow the same story:

1. **Load data** — read the CSV  
2. **Explore** — preview rows and summary statistics  
3. **Scatter plot** — dots for each person (experience vs salary)  
4. **Fit a linear model** — compute intercept and slope  
5. **Overlay the regression line** — draw the fitted line on the scatter  
6. **Evaluate** — print fit metrics (R² and, in the AI version, RMSE and MAE)

The AI notebooks use clearer section headers and slightly richer evaluation output. The manual notebooks are more exploratory (e.g., separate cells showing `x` and `y`).

---

## Output files

| Version | Python plot | R plot |
|---------|-------------|--------|
| **manual/** (scripts) | `linear_regression_python_output.png` (current working directory) | `linear_regression_r_output.png` (cwd) |
| **ai/** (scripts) | `ai/regression_python.png` | `ai/regression_r.png` |

HTML exports (`.html`) are static snapshots of the notebooks for submission or sharing without Jupyter.

---

## The model (for curious readers)

We fit:

$$\text{Salary} = \beta_0 + \beta_1 \times \text{YearsExperience} + \varepsilon$$

| Symbol | Meaning | Example (this dataset) |
|--------|---------|-------------------------|
| $\beta_0$ | Intercept — predicted salary at 0 years | ~\$29,204 |
| $\beta_1$ | Slope — extra salary per year of experience | ~\$8,285 / year |
| R² | Fraction of salary variation explained by experience | ~0.79 (79%) |

Python uses `sklearn.linear_model.LinearRegression`; R uses `lm()`. Both use ordinary least squares, so coefficients match.

---

## Manual vs AI: main differences

| Topic | `manual/` | `ai/` |
|-------|-----------|-------|
| CLI arguments | Positional: `file x y` | Named: `--filepath`, `--x-col`, `--y-col` |
| Script structure | Exported from notebooks | Standalone scripts with validation |
| Python kernel (notebook) | `7030_class_1` | `7030_class_2` |
| R plot style | Red points, blue fitted line (`geom_line`) | Points + red line from coefficients (`geom_abline`) |
| Extra metrics | R² (Python); `summary()` (R) | R², RMSE, MAE in both |
| Prompt documentation | — | `PROMPTS.md`, `prompt_history.md`, `CHAT_SESSION.md` |

The assignment treats these differences as a feature: Part C reflects on *how* AI choices diverged from hand-written work.

---

## Environment setup (pros)

**Conda env:** `7030_class_2` from [`environment.yml`](environment.yml)

| Component | Package / kernel |
|-----------|------------------|
| Python kernel | `7030_class_2` → display name **Python (7030_class_2)** |
| R kernel | `ir_7030_class_2` → display name **R (7030_class_2)** |
| Python libs | `pandas`, `matplotlib`, `scikit-learn` ([`requirements.txt`](requirements.txt)) |
| R plotting | `ggplot2` (manually installed in env) + base R `lm()` |

Register kernels after creating the env (see [`setup_env.sh`](setup_env.sh)):

```bash
pip install -r requirements.txt   # if not already installed
python -m ipykernel install --user --name 7030_class_2 --display-name "Python (7030_class_2)"
Rscript -e 'IRkernel::installspec(name="ir_7030_class_2", displayname="R (7030_class_2)")'
```

**Export notebook to HTML:**

```bash
cd manual/   # or ai/
jupyter nbconvert --to html regression_python.ipynb
jupyter nbconvert --to html regression_r.ipynb
# R execute/export may need: --ExecutePreprocessor.kernel_name=ir_7030_class_2
```

**Re-run notebook in place:**

```bash
jupyter nbconvert --execute --inplace regression_python.ipynb
jupyter nbconvert --execute --inplace regression_r.ipynb --ExecutePreprocessor.kernel_name=ir_7030_class_2
```

---

## Git branches

| Branch | Typical contents |
|--------|------------------|
| `main` | Course baseline + `manual/` deliverables |
| `ai-coding` | AI-assisted work under `ai/` |

Merge workflow preserves both folders; neither replaces the other.

---

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| Kernel not found | Re-run kernel registration in `setup_env.sh` |
| CSV not found from notebook | Open Jupyter from `Week_2` root; notebooks use `../regression_data.csv` |
| `ModuleNotFoundError` (Python) | `conda activate 7030_class_2` and `pip install -r requirements.txt` |
| R notebook runs as Python | Select **R (7030_class_2)** kernel or use `ir_7030_class_2` when executing via nbconvert |
| Matplotlib font cache warning | Harmless on shared systems; plot still saves |

---

## Assignment context (PAS 7030)

This repo supports a two-part intro data-science assignment:

- **Part A (`manual/`)** — no AI; type everything yourself.  
- **Part B (`ai/`)** — rebuild with AI; graded on correctness, not identical code.  
- **Part C** — written reflection comparing manual vs AI approaches (see differences table above).

---

## Further reading in this repo

- [`ai/PROMPTS.md`](ai/PROMPTS.md) — condensed AI prompts for Part B  
- [`ai/prompt_history.md`](ai/prompt_history.md) — timestamped prompt/action log  
- [`ai/CHAT_SESSION.md`](ai/CHAT_SESSION.md) — full AI pair-programming session transcript  

---

## License / course use

Course materials for PAS 7030 Week 2. Use and adapt per instructor guidelines.
