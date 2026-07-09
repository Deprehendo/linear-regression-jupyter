# Key AI Prompts — Part B Deliverables

The 3–5 most important prompts used to build the `ai/` folder. Full detail is in [`prompt_history.md`](prompt_history.md) and [`CHAT_SESSION.md`](CHAT_SESSION.md).

---

## 1. Initial plan (no manual code peek)

> I want to build a plan before we start any coding. I am needing both python and R notebooks using the 7030_class_2 kernel that can read a CSV file, create a scatter plot from these, fit a linear model, and overlay the regression model line, and then evaluate the model. Give me a comprehensive plan on the best way to conduct this and any other useful information (package info or model info) you can. **DO NOT LOOK AT MY WORK IN MANUAL.** All files at the end of this will need to be deposited into the ai directory and I wish for you to keep a running prompt history from this moment forward in the ai directory as well.

**Why it mattered:** Set scope, parallel Python/R structure, kernel metadata, and isolated AI work from Part A.

---

## 2. Plan iteration — ggplot2 for R

> ggplot2 is already in the environment, just manually installed and should be used for the r notebook, propose this in the new change.

**Why it mattered:** Switched R visualization from base R to ggplot2 with explicit `lm()` + `geom_abline()` (not hidden inside `geom_smooth()`).

---

## 3. Execute the plan

> Looks good, go ahead and begin building the notebooks.

**Why it mattered:** Approved transition from plan mode to implementation; produced both `.ipynb` files and verification.

---

## 4. HTML + CLI scripts with arguments

> Take these notebooks, convert them into HTML and script files, the script files need to be runable and the output needs the model fit line overlayed with scatter plot saved as a .png. The script files need to be able to accept command line arguments for the filepath, x_col, and y_col.

**Why it mattered:** Expanded deliverables beyond notebooks to HTML exports and parameterized CLI scripts with PNG output.

---

## 5. Trim notebooks, then implement

> I would first before you start this plan like to edit the notebooks to remove the predicted vs actual table and the residual plot cells, then implement this plan with the proper edits here.

**Why it mattered:** Aligned notebook, HTML, and script scope by dropping diagnostic extras before export/script generation.
