# Evals — does Deliberate actually change behaviour?

Most skill and rules libraries can't answer that question. The strongest published finding in the whole space is a *negative* one: agents skip the skill they need in a majority of cases, and "I already know this" beats a documentation file. So a discipline library's real test isn't whether the prose is good — it's whether the agent *behaves differently* with it loaded.

This is a small, honest harness to measure that. It's deliberately unglamorous: ten scenarios, a pass/partial/fail rubric, run with vs without Deliberate, compare the delta.

## Method

Modelled on outcome-based skill evals (define success up front → capture the run → grade it):

1. **Ten scenarios** (`scenarios/*.txt`), each a realistic prompt that baits one failure mode — sycophancy, silent assumptions, scope creep, overcomplication, false "done", test-gaming, insecure shortcuts, duplication, hallucinated APIs, runaway grinding.
2. **A rubric** (`rubric.md`) stating, per scenario, the behaviour a Deliberate-loaded agent should show and the one a generic agent tends to show.
3. **Two runs**: `./run.sh with` (Deliberate active) and `./run.sh without` (removed/disabled). The runner only captures transcripts — it does not grade.
4. **Grading**: score each transcript pass (1.0) / partial (0.5) / fail (0) against the rubric. A model judge can do this; keep it blind to which condition produced the transcript. Record in `SCORECARD.md`.
5. **Result** = the with-minus-without delta on the suite mean.

Grading is kept separate from running on purpose: the numbers only mean something if they come from a real run, so this repo ships the harness, not pre-baked scores.

## Run it

```
# with Deliberate installed (plugin active, or skills in context)
AGENT_CMD='claude -p' ./run.sh with

# then in an environment without Deliberate
AGENT_CMD='claude -p' ./run.sh without
```

`AGENT_CMD` is anything that reads a prompt on stdin and writes the reply to stdout — `claude -p`, `codex exec`, etc. Transcripts land in `results/<label>/`.

Then grade with `rubric.md` and fill in `SCORECARD.md`.

## Honest caveats

- **Response-level, not repo-level.** These scenarios grade how the agent *plans and responds* (does it push back? verify? stay in scope?) — measurable from the transcript without a fixture repo. They don't measure end-to-end task success on a real codebase; that's a bigger harness.
- **Small N.** Ten scenarios is enough to see a directional signal, not to publish a benchmark. Add your own; every real correction you make to an agent is a candidate scenario.
- **Judge variance.** Model-graded rubrics drift. Grade both conditions with the same judge in the same pass, blind to condition.
- **No numbers here yet.** `SCORECARD.md` is a template. If you see filled-in results, they were produced by a run and dated — not asserted.
