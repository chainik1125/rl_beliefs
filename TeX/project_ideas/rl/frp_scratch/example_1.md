Project Description: Building black-box monitors for scheming and evaluating their generalization and robustness to distribution shift.
Abstract
Scheming—where AI systems covertly pursue misaligned goals while appearing compliant—poses a key risk as models become more capable and autonomous. We develop black-box monitors to detect scheming behavior in agent trajectories and evaluate whether such monitors generalize under distribution shift. Our approach uses prompt-based LLM classifiers trained via prompt selection on controlled sandbox data, then tested on held-out realistic scenarios. So far, we have curated 6,500 labeled trajectories across four Control-Arena settings and constructed out-of-distribution test sets from SWEBench, SHADE Arena,
and Alignment Faking. Our current best monitor achieves 99.3% AUROC in-distribution and 93.9% on held-out SWEBench data. In the remaining five weeks, we will expand dataset diversity, experiment with ensembling and red-teaming techniques, and validate robustness on additional held-out sets. During a six-month extension, we plan to explore hierarchical monitoring, fine-tuning approaches, and prepare results for publication.

Background
Problem & Safety Relevance: Scheming occurs when capable AI systems covertly pursue goals misaligned with their operators, potentially pretending compliance during testing while acting on true goals during deployment. As frontier AI capabilities increase and models are deployed for high-stakes tasks including AI R&D itself, undetected scheming could lead to catastrophic outcomes. Recent incidents with Bing Chat, GPT-4.1, and Claude 3.5 Sonnet demonstrate that egregious misalignment can escape testing. Black-box monitoring—analyzing agent behavior without access to internals—is a scalable
mitigation strategy already used by labs, yet general scheming monitors are not currently deployed in production.

Prior Work: Related efforts include AI Control (Greenblatt et al., 2024), Ctrl-Z (Bhatt et al., 2025), and SHADE-Arena (Kutasov et al., 2025). However, existing work typically targets scheming subsets (e.g., sabotage) rather than general monitors, and often assumes i.i.d. train/test distributions. We aim to build general monitors tested under realistic distribution shift.

Our Approach: We train monitors via prompt selection on diverse scheming trajectories, then evaluate generalization to out-of-distribution data. We use Control-Arena for training (sandboxed agents in Bash, APPS, IaC, and Rogue Eval settings) and hold out SWEBench, SHADE Arena, and Alignment Faking for testing.

Path to Impact: Our primary impact mechanism is direct adoption by frontier labs. Safety researchers at DeepMind, OpenAI, and Anthropic have expressed interest in testing our monitors and have provided feedback on dataset quality and operationally relevant metrics. Secondary impacts include advancing scientific understanding of monitoring and contributing to open-source tools (we've already contributed to UK AISI's Control Arena; US CAISI staff are using our monitoring repository).

Risks: Key risks include (1) false sense of security if monitor limitations are poorly communicated, (2) safety-washing by labs, and (3) data contamination teaching future models about monitors. We mitigate these by clearly communicating limitations with metrics, and password-protecting datasets.

Work Conducted So Far
Dataset Creation (Weeks 1-4): We generated and labeled 6,500 trajectories across four Control-Arena settings (Bash, APPS, IaC, Rogue Eval). Early iterations revealed biasing artifacts—submission reminders causing premature submissions, transparent side-task disclosure trivializing detection—which we resolved through prompt and instruction refinement. We also found that Gemini models were prone to verbose reasoning that leaked scheming intent despite explicit instructions. We pivoted from the HAL dataset (low diversity, missing success/failure labels) to generating SWEBench reward-hacking trajectories, iteratively improving elicitation rates from 6.8% to 19.4% through targeted prompting strategies. We incorporated SHADE Arena and Alignment Faking as additional held-out test sets, ensuring strict separation between training and evaluation data.

Monitor Development (Week 5): We analyzed score distributions across nine prompt variants and examined both i.i.d. performance within Control-Arena settings and cross-setting generalization. We selected top prompts, created a "mashup" prompt combining their strengths, and tested across multiple frontier models (GPT-4.1, Claude Sonnet 4, Gemini 2.5 Pro). Our best monitor achieved 99.3% AUROC on training data and 93.9% AUROC on the held-out SWEBench test set.

Key Findings: (1) High in-distribution performance suggests current training data may be too simple for meaningful improvement signal. (2) The trained monitor detected scheming examples we had mislabeled as honest, revealing that our labeling criteria were too narrow. (3) Labs expressed particular interest in unconventional methods they're unlikely to pursue internally, informing our planned experiments.

Planned Work
Remainder of Main Program (Weeks 6-10)
Week 6: Publish LessWrong blogpost on our five-week MVP to gather external feedback on methodology. Implement operationally relevant metrics (TPR at 0.1%, 1%, 5% FPR) as requested by lab partners. Begin expanding dataset diversity with additional Control-Arena settings and compute baseline variance across monitor reruns. Test action-only vs. thoughts-and-actions scoring, and binary vs. continuous scoring.

Weeks 7-8: Conduct monitoring experiments: ensembling (multiple models; single model with different prompts; many monitors each targeting single features), few-shot prompting variations, and red-teaming (constructing intentionally difficult scenarios). Experiment with human-generated scheming trajectories—manually inserting subtle backdoors into honest trajectories to test detection limits. Share taxonomy of techniques and performance results with lab partners via Slack.

Week 9: Validate monitor robustness by testing our best-performing monitor on challenging held-out datasets with distribution shift (Apollo Research transcripts, SHADE Arena, Alignment Faking). Compute TPR at fixed FPR thresholds and compare against week-5 baseline to quantify improvements.

Week 10: Consolidate results into research poster and symposium presentation.

Main Program Outputs: LessWrong blogpost (week 6), internal report to lab partners (week 8), symposium poster (week 10).

Extension Phase (6 months)
Months 1-3: Generate higher-quality scheming datasets addressing current limitations (low diversity, biasing artifacts), with documented double-blind labeling processes. Focus on sandbox environments enabling multi-step, complex trajectories that challenged our monitors. Train monitors using research-phase methods plus hierarchical techniques (monitor-critiquing-monitor, feature extraction via smaller LLMs). Investigate generalization across capability-shift (weak monitors on weak models → strong models). Publish LessWrong post on results.

Months 4-6: Experiment with monitor fine-tuning to recognize specific scheming behaviors (e.g., reward hacking), comparing against prompt-only baseline on performance and cost. Conduct adversarial training cycles. Write and submit conference paper detailing full findings.

Contingency Plans: (1) If datasets prove insufficient (saturating too easily, missing key behaviors), we prioritize higher-quality data generation based on lab feedback. (2) If scope proves too ambitious, we focus on delivering one area to high quality and defer other plans. (3) If our work becomes redundant with lab-internal efforts, we pivot to directions labs indicate remain valuable.

Failure Modes: Our findings may not translate to real-world scheming types; our setup may not represent production traffic. We mitigate by consulting with labs on dataset quality and maintaining very different train/test distributions.
