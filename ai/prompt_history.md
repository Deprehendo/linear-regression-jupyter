# Prompt History — Week 2 Regression Notebooks

Running log of user prompts and agent actions for the `ai/` deliverables.

---

## 2026-07-09 — Session start

**User:** I want to build a plan before we start any coding. I am needing both python and R notebooks using the 7030_class_2 kernel that can read a CSV file, create a scatter plot from these, fit a linear model, and overlay the regression model line, and then evaluate the model. Give me a comprehensive plan on the best way to conduct this and any other useful information (package info or model info) you can. DO NOT LOOK AT MY WORK IN MANUAL. All files at the end of this will need to be deposited into the ai directory and I wish for you to keep a running prompt history from this moment forward in the ai directory as well.

**Action:** Created comprehensive plan for parallel Python (matplotlib + sklearn) and R (ggplot2 + lm) notebooks in `ai/`. Did not read `manual/` directory.

---

## 2026-07-09 — Plan iteration: ggplot2

**User:** ggplot2 is already in the environment, just manually installed and should be used for the r notebook, propose this in the new change.

**Action:** Updated plan to use ggplot2 for R visualization (`geom_point` + `geom_abline` from `coef(model)`), keeping base R for `lm()` and `summary()`.

---

## 2026-07-09 — Execution approved

**User:** Looks good, go ahead and begin building the notebooks.

**Action:** Building `ai/regression_python.ipynb`, `ai/regression_r.ipynb`, and verifying execution.

---

## 2026-07-09 — Session pickup (verification completed)

**User:** Pick up where the last agent got cut off.

**Action:** Completed verification that was interrupted during pip install. Both notebooks execute cleanly with the `7030_class_2` conda environment.

### Verification results

| Metric | Python (sklearn) | R (lm) |
|--------|------------------|--------|
| Intercept (β₀) | 29,203.52 | 29,203.52 |
| Slope (β₁) | 8,285.29 | 8,285.29 |
| R² | 0.7852 | 0.7852 |
| RMSE | 4,186.15 | 4,186.15 |

- Python notebook: `jupyter nbconvert --execute` succeeded from `ai/` (CSV path `../regression_data.csv` resolves correctly).
- R notebook: same; ggplot2 loads and plots render without error.
- Python deps (`pandas`, `matplotlib`, `scikit-learn`) confirmed installed in `7030_class_2`.

---

## 2026-07-09 — HTML export + CLI scripts

**User:** Convert notebooks to HTML and runnable scripts with CLI args (`--filepath`, `--x-col`, `--y-col`); save scatter+line PNGs as `regression_python.png` / `regression_r.png`. Trim notebooks first (remove predicted-vs-actual table and residual plot).

**Action:** Implemented full deliverable set in `ai/`.

### Notebook trim

Removed from both notebooks:
- Predicted vs actual `results` table
- Residual plot cells

Re-executed notebooks in place (R kernel: `ir_7030_class_2`).

### New files

| File | Purpose |
|------|---------|
| `ai/regression_python.py` | CLI script; saves `regression_python.png` in `ai/` |
| `ai/regression_r.r` | CLI script; saves `regression_r.png` in `ai/` |
| `ai/regression_python.html` | nbconvert export of trimmed Python notebook |
| `ai/regression_r.html` | nbconvert export of trimmed R notebook |

### Verification

Both scripts run successfully:

```bash
python ai/regression_python.py --filepath regression_data.csv --x-col YearsExperience --y-col Salary
Rscript ai/regression_r.r --filepath regression_data.csv --x-col YearsExperience --y-col Salary
```

Metrics unchanged: β₀=29203.52, β₁=8285.29, R²=0.7852, RMSE=4186.15.

---

## 2026-07-09 — PNG location + commit

**User:** Move PNGs to ai directory; prepare for commit.

**Action:** Moved PNGs; updated scripts to save beside script file; committed 9 files on `ai-coding` (`355cd68`).

---

## 2026-07-09 — Documentation

**User:** Create general README for mixed audience; save entire chat in ai/ (user will commit README and push).

**Action:** Created root `README.md`, `ai/PROMPTS.md` (key prompts for Part B), `ai/CHAT_SESSION.md` (full session transcript).

---

## 2026-07-16 — Graph annotations: MSE, equation, R²

**User:** Make a plan to improve the graphs in the ai folder (without reading manual/). Add Mean Squared Error (MSE) for both scripts and incorporate MSE, the regression equation, and R² on each graph. Scope: scripts and notebooks.

**Action:** Planned upper-left annotation box on all regression plots; implemented across Python and R scripts and notebooks.

### Changes

- Reordered metric computation before plotting in `regression_python.py` and `regression_r.r`.
- Added on-plot annotation: `y = β₀ + β₁ × x`, R², and MSE (semi-transparent text box, upper-left).
- Added MSE to console output alongside existing R², RMSE, and MAE.
- Mirrored changes in `regression_python.ipynb` and `regression_r.ipynb`.

### Verification results

| Metric | Python (sklearn) | R (lm) |
|--------|------------------|--------|
| Intercept (β₀) | 29,203.52 | 29,203.52 |
| Slope (β₁) | 8,285.29 | 8,285.29 |
| R² | 0.7852 | 0.7852 |
| MSE | 17,523,844.08 | 17,523,844 |
| RMSE | 4,186.15 | 4,186.15 |

- Scripts: both PNGs show equation, R², and MSE in upper-left.
- Notebooks: re-executed with `7030_class_2` / `ir_7030_class_2` kernels.

---

## 2026-07-16 — HTML export + GitHub prep

**User:** Update HTML files to match; update logs in `ai/`; prepare to upload to GitHub.

**Action:** Regenerated `regression_python.html` and `regression_r.html` from executed notebooks; updated `prompt_history.md`, `PROMPTS.md`, and `CHAT_SESSION.md`; committed and pushed on `ai-coding`.

---

## 2026-07-16 — Assignment 3 Part B: code review + AI README (Part C deferred)

**User:** Review assignment3 PR diff (ignore Part C). Store comparison in `ai/CODE_REVIEW.md`. Generate in-depth README; update prompt logs; prepare commit upon approval.

**User (follow-up):** Pasted full Assignment 3 brief clarifying Part B deliverables: `README_AI.md` (do not overwrite manual README), `PROMPTS.md` for three AI tasks, address ≥1 substantive review comment.

**Action:** Completed Assignment 3 Part B documentation on `ai-coding`. Root `README.md` updated to match `ai/README_AI.md` (Week 3 refresh from Week 2 AI README).

### Review outputs

| File | Purpose |
|------|---------|
| `ai/CODE_REVIEW.md` | Review of `main...assignment_3` PR + `ai/` deliverables; rubric checklists; substantive findings table |
| `ai/README_AI.md` | AI-generated in-depth README (beginner + advanced) |
| `README.md` (root) | Updated to match `README_AI.md` (Week 3 refresh from Week 2) |

### Part A PR findings (summary)

- **Strengths:** MSE + equation annotations; `scipy` in requirements; numerically correct metrics on sample data.
- **Substantive issues:** R script hardcodes `Salary`/`YearsExperience` despite CLI args; R ggplot uses both `geom_line` and `geom_smooth`; Python plot labels **r** while evaluation prints **R²**; inconsistent PNG filenames between notebook and script.

### Part B status

- Regression deliverables complete; Assignment 3 workflow docs added.

### Logs updated

- `PROMPTS.md` — restructured for commit messages, code review, README prompts
- `prompt_history.md` — this entry
- `CHAT_SESSION.md` — Turn 16

**Pending:** User approval before git commit on `ai-coding`.
