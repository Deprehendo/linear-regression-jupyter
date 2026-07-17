# Key AI Prompts — Assignment 3, Part B

Per Assignment 3 Part B, this file records prompts used for **(1) AI commit messages**, **(2) AI code review**, and **(3) AI-generated README**. Full session detail is in [`prompt_history.md`](prompt_history.md) and [`CHAT_SESSION.md`](CHAT_SESSION.md).

Earlier Week 2 prompts (notebooks, scripts, graph annotations) are listed in **Appendix A** below.

---

## 1. AI commit messages

Used when staging and committing AI deliverables on `ai-coding`.

### Prompt A — Initial AI deliverables commit

> Move PNGs to ai directory; get ready for commit.

**Agent output (commit message used):**

```
Add AI regression deliverables with notebooks, CLI scripts, and HTML exports.
```

**Why it mattered:** First structured commit bundling all Part B regression artifacts under `ai/`.

### Prompt B — Graph annotation commit

> Update HTML files to match; update logs in ai/; prepare to upload to GitHub.

**Agent output (commit message used):**

```
Add MSE and on-plot model annotations to AI regression deliverables.

Surface the regression equation, R², and MSE on graphs and in console output
across scripts, notebooks, HTML exports, and session logs.
```

**Why it mattered:** Multi-line message explains *why* (on-plot metrics), not just *what* changed — useful for future contributors reviewing history.

### Prompt C — Assignment 3 documentation commit (pending approval)

> Prepare this for a git commit upon my approval of the work conducted.

**Suggested commit message:**

```
Add Assignment 3 Part B docs: code review, AI README, and prompt logs.

Save AI PR review to CODE_REVIEW.md, generate README_AI.md without
overwriting hand-written root README, and update session logs.
```

---

## 2. AI code review

### Prompt — Review assignment3 PR diff

> I want you to review my assignment3 PR diff. Here is the assignment 3. I want you to ignore part C right now. I would like you to do this comparison first. Once this is done and stored properly at ai/CODE_REVIEW.md.

*(User subsequently pasted full Assignment 3 brief clarifying Part A/B/C deliverables, directory structure, and that README must be saved as `ai/README_AI.md`.)*

**Why it mattered:** Produced [`CODE_REVIEW.md`](CODE_REVIEW.md) comparing `main...assignment_3` (Part A manual PR) against `ai/` (Part B), with rubric checklists and substantive findings (R script column bug, duplicate ggplot layers, r vs R² labeling).

---

## 3. AI-generated README

### Prompt — In-depth README for mixed audience

> After the comparison is done, have an AI generate a fresh README from your code. Save it as ai/README_AI.md (don't overwrite your manual README). Make it in depth for both beginners and advanced coders.

**Why it mattered:** Generated [`README_AI.md`](README_AI.md) with table of contents, beginner quick start, advanced env/git sections. Root [`README.md`](../README.md) updated to the same content (Week 3 refresh from Week 2).

---

## Appendix A — Week 2 Part B regression build (prior prompts)

These supported the original AI regression rebuild (Assignment 2 Part B), not Assignment 3 workflow tasks specifically.

| # | Summary |
|---|---------|
| 1 | Plan Python + R notebooks (`7030_class_2` kernel); do not read `manual/` |
| 2 | Use ggplot2 for R notebook |
| 3 | Execute plan — build notebooks |
| 4 | Export HTML + CLI scripts with `--filepath`, `--x-col`, `--y-col` |
| 5 | Trim notebooks (remove residual plot cells) before export |
| 6 | Add MSE, equation, and R² on graphs in `ai/` |

See [`prompt_history.md`](prompt_history.md) for verbatim prompts and verification tables.
