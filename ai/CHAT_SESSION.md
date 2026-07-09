# AI Pair-Programming Session — Full Record

Complete log of the Cursor AI session used to produce the `ai/` deliverables for Week 2 (PAS 7030). Timestamps are US Eastern (UTC-4), 2026-07-09.

---

## Session overview

| Phase | Outcome |
|-------|---------|
| Planning | Python (matplotlib + sklearn) + R (ggplot2 + lm) notebook design |
| Build | `regression_python.ipynb`, `regression_r.ipynb`, `prompt_history.md` |
| Verify | End-to-end execution; matching coefficients across languages |
| Extend | HTML export, CLI scripts, PNG outputs |
| Refine | Trim notebooks; move PNGs to `ai/`; commit on `ai-coding` |
| Review | Compared `ai/` vs `manual/`; assignment rubric assessment |
| Document | Root `README.md`, `PROMPTS.md`, this file |

---

## Conversation transcript

### Turn 1 — Plan request

**User:** I want to build a plan before we start any coding. I am needing both python and R notebooks using the 7030_class_2 kernel that can read a CSV file, create a scatter plot from these, fit a linear model, and overlay the regression model line, and then evaluate the model. Give me a comprehensive plan on the best way to conduct this and any other useful information (package info or model info) you can. DO NOT LOOK AT MY WORK IN MANUAL. All files at the end of this will need to be deposited into the ai directory and I wish for you to keep a running prompt history from this moment forward in the ai directory as well.

**Agent:** Switched to Plan mode. Explored repo (excluding `manual/`): found `regression_data.csv` (10 rows, `YearsExperience`, `Salary`), `environment.yml`, `requirements.txt`, `setup_env.sh`. Proposed parallel notebook architecture, kernel metadata, evaluation metrics, and `ai/prompt_history.md`.

---

### Turn 2 — ggplot2 update

**User:** ggplot2 is already in the environment, just manually installed and should be used for the r notebook, propose this in the new change.

**Agent:** Updated plan: R uses ggplot2 for plots (`geom_point` + `geom_abline` from `coef(model)`); modeling stays base R `lm()` / `summary()`.

---

### Turn 3 — Begin building

**User:** Looks good, go ahead and begin building the notebooks.

**Agent:** Switched to Agent mode. Created `ai/prompt_history.md`, `ai/regression_python.ipynb`, `ai/regression_r.ipynb`. Verification interrupted during pip install.

---

### Turn 4 — Session pickup

**User:** Please pick up where the last agent got cut off at, if you need to review the task look in the ai directory for prompts.

**Agent:** Completed verification. Python and R metrics matched:

| Metric | Python | R |
|--------|--------|---|
| Intercept | 29,203.52 | 29,203.52 |
| Slope | 8,285.29 | 8,285.29 |
| R² | 0.7852 | 0.7852 |
| RMSE | 4,186.15 | 4,186.15 |

Both notebooks execute via `jupyter nbconvert --execute`.

---

### Turn 5 — HTML and CLI plan

**User:** Back to plan mode. Take notebooks, convert to HTML and script files. Scripts must accept CLI args for filepath, x_col, y_col; save scatter + regression line as PNG.

**Agent:** Plan mode. User chose: fixed PNG names (`regression_python.png`, `regression_r.png`); full workflow without residual plot. Plan created for HTML export + CLI scripts.

---

### Turn 6 — Trim then implement

**User:** First edit notebooks to remove predicted vs actual table and residual plot cells, then implement the plan.

**Agent:** Updated plan with Step 0 (notebook trim). User approved implementation.

---

### Turn 7 — Implement HTML + scripts

**User:** Looks good, go ahead and implement this.

**Agent actions:**

1. Removed results-table and residual-plot cells from both notebooks  
2. Created `ai/regression_python.py` (argparse, validation, metrics, PNG)  
3. Created `ai/regression_r.r` (flag-based CLI, ggplot2, PNG)  
4. Re-executed notebooks; exported HTML  
5. Verified scripts against `regression_data.csv`  
6. Updated `prompt_history.md`

---

### Turn 8 — Move PNGs and commit prep

**User:** Move PNGs to ai directory; get ready for commit.

**Agent:** Moved PNGs to `ai/`; updated scripts to save next to script path; committed 9 files on `ai-coding` (`355cd68`).

---

### Turn 9 — Push and merge request

**User:** Push on ai-coding and merge to main without deleting ai-coding.

**Agent:** Environment hooks blocked `git push` and `checkout main`. Provided manual commands:

```bash
git push -u origin ai-coding
git checkout main && git merge ai-coding && git push origin main && git checkout ai-coding
```

---

### Turn 10 — Compare manual vs AI

**User:** Compare files in ai/ to manual/ and breakdown differences.

**Agent:** File-by-file comparison. Highlights:

- **CLI:** manual = positional; ai = named flags  
- **PNG names:** manual = `linear_regression_*_output.png`; ai = `regression_*.png` in `ai/`  
- **R plots:** manual hardcodes column names in ggplot despite CLI args; ai uses dynamic columns  
- **Metrics:** ai adds RMSE/MAE; richer notebook sections  
- **Extra ai files:** `prompt_history.md`, PNGs committed in ai/

---

### Turn 11 — Assignment rubric opinion

**User:** Would ai/ work for Part B of the assignment (manual Part A + AI Part B + Part C reflection)?

**Agent:** Yes — Part B meets rubric (runs correctly, differences are valid Part C material). Suggested adding `PROMPTS.md`. Noted manual/ gaps: README, committed PNGs, R script column hardcoding.

---

### Turn 12 — README and save chat (this turn)

**User:** Create a general README understandable to beginners but with detail for pros. Save entire chat in ai/. User will commit README and push themselves.

**Agent:** Created root `README.md`, `ai/PROMPTS.md`, `ai/CHAT_SESSION.md`; updated `prompt_history.md`.

---

## Deliverables produced in `ai/`

| File | Description |
|------|-------------|
| `regression_python.ipynb` | Python notebook (`7030_class_2` kernel) |
| `regression_r.ipynb` | R notebook (`ir_7030_class_2` kernel) |
| `regression_python.html` | Static HTML export |
| `regression_r.html` | Static HTML export |
| `regression_python.py` | CLI script |
| `regression_r.r` | CLI script |
| `regression_python.png` | Sample plot output |
| `regression_r.png` | Sample plot output |
| `prompt_history.md` | Timestamped prompt/action log |
| `PROMPTS.md` | 3–5 key prompts (Part B submission) |
| `CHAT_SESSION.md` | This full session record |

---

## Design decisions worth noting (Part C)

1. **Plan-first workflow** — User required planning before code; reduced rework.  
2. **ggplot2 + explicit coefficients** — Teaching-friendly: fit with `lm()`, draw with `geom_abline()`, not opaque `geom_smooth()`.  
3. **Named CLI flags** — AI chose argparse-style interface vs manual positional `sys.argv`.  
4. **Extra metrics** — RMSE/MAE supplement R² without changing the core assignment tasks.  
5. **Intentional isolation** — AI agent did not read `manual/` during initial build, preserving independent Part B work.

---

## Verification commands (reference)

```bash
conda activate 7030_class_2
cd Week_2

python ai/regression_python.py \
  --filepath regression_data.csv \
  --x-col YearsExperience \
  --y-col Salary

Rscript ai/regression_r.r \
  --filepath regression_data.csv \
  --x-col YearsExperience \
  --y-col Salary
```

Expected: exit code 0; PNGs in `ai/`; R² ≈ 0.7852.
