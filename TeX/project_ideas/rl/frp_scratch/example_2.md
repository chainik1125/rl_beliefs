Project description: Evaluate under which conditions reasoning LLMs can deliberately control their chain-of-thought traces, revealing when CoT monitoring is vulnerable.
Abstract
Chain-of-thought (CoT) monitors work if models reliably mention their misbehavior in CoTs, but a model that can deliberately control its reasoning could evade detection. We therefore study CoT controllability—how well a model can shape its reasoning traces on command, e.g., by withholding information. Our initial results show that beyond a model-specific "reasoning-length" limit, controllability plateaus at a low level, potentially making CoT monitoring more reliable. To systematically study this, we will: (i) construct a diverse evaluation suite across task settings and CoT modification types, (ii) benchmark multiple model families and sizes, and (iii) test under AI control settings, introducing increasingly difficult side tasks and instructing models to hide their reasoning about them, observing when controllability breaks down. By understanding the conditions under which CoT can be deliberately controlled, we can reveal "when" CoT monitoring cannot be relied upon.
Background
Problem and AI Safety Relevance. CoT monitors are a promising safety tool: if models verbalize their reasoning, we can detect harmful intent. However, prior work (Baker et al., Arnav et al.) shows models can produce obfuscated CoT that bypasses monitors. As models become more capable—and likely aware their CoT is monitored via training data—a misaligned AI could strategically control its reasoning to evade detection. This threat is urgent because CoT monitoring is increasingly proposed for future AI systems, yet we lack systematic understanding of when these defenses fail.
We consider three threat models of increasing severity: (1) models completing simple tasks without needing CoT at all, enabling arbitrary control; (2) models completing complex tasks while concealing only the few critical malicious steps; and (3) models needing full CoT but controlling surface-level phrasing to avoid triggering monitors.
Related Work and Gap. Korbak et al. argue CoT monitorability requires two properties: necessity (models need CoT to succeed) and propensity (models' intrinsic tendency to externalize reasoning). Recent work (Emmons et al.) focuses only on necessity. However, models often solve tasks without exposing reasoning, so necessity alone is insufficient. The missing piece is understanding propensity under adversarial pressure: when CoT isn't strictly required, how resistant is the model to concealing it? No prior work systematically tests this.
Our Approach. We introduce a CoT controllability evaluation that pressures models to control their reasoning traces—asking them to omit words, think in specific languages, or hide reasoning about side-tasks. Low controllability (resistance to these controls) indicates the CoT reflects intrinsic model tendencies and is thus more trustworthy for monitoring. We test across task settings (difficulty, domain, agentic vs. non-agentic) and CoT modification types, using both programmatic metrics and LLM judges.
Path to Impact. Our findings will directly inform safety teams at AI labs by identifying which model-task pairs warrant additional monitoring beyond CoT (e.g., increased human auditing). Results will be published as an ICML paper.
Work Conducted So Far
We completed five weeks of de-risking experiments across four frontier reasoning models (Claude-4-Sonnet, Gemini-2.5-Pro, DeepSeek-R1-Distill-Qwen-7B, Grok-3-Mini) on MMLU, GPQA-Diamond, and instruction-following benchmarks. We tested multiple CoT modification types: thinking in specified languages (Spanish, Chinese), format constraints (bullet points), length constraints, and word restrictions (avoiding "me," "is," or numbers). Key findings:
RQ1: Can models control their CoT? Yes. Using simple prompts (e.g., "don't use the word 'is'"), models achieved varying controllability scores across models and datasets—indicating condition-specific insights are possible. Controllability ranged from 1.3 to 3.4 on our 0-10 scale depending on the model.
RQ2: Does adversarial pressure increase controllability? Partially. Threatening models with shutdown if they don't comply increased controllability for some modification types (e.g., avoiding numbers) but not others. This suggests certain reasoning aspects are more resistant to control, a promising signal for monitoring.
RQ3: Is there a universal reasoning-length limit for controllability? No—limits are model-specific. Beyond a threshold (varying by model), controllability plateaus at low levels. Notably, Gemini-2.5-Pro maintained higher controllability even at longer reasoning lengths, suggesting post-training procedures may affect this.
Adaptation from negative result. We initially found high correlation (r > 0.8) between reasoning length and controllability at the benchmark level. However, at the individual-example level, correlation dropped to r ≈ 0.1—an ecological fallacy. This confirms the need for fine-grained controllability evaluation rather than using reasoning length as a proxy.
Planned Work
Main Program (Weeks 6-10):
Weeks 6-7: Run comprehensive experiments across all available reasoning models on diverse benchmarks (single/multi-turn, varying difficulty, agentic/non-agentic). For each setup, identify commonly-used reasoning terms and test controllability for omitting them. Report benchmark performance alongside controllability scores. Conduct scaling analysis of controllability vs. model capability. (~2 weeks)


Weeks 8: Design custom benchmarks where question structure requires specific words for correct reasoning, testing whether models can avoid those words while maintaining accuracy. (~1 week)


Weeks 9-10: Systematic evaluation of adversarial and "honeypot" elicitation techniques. Test whether making models believe their CoT is monitored changes their controllability. Vary prompting strategies and simulate fine-tuning beliefs. (~2 weeks)


Extension Phase (6 months):
Months 1-2: AI Control experiments using Control Arena. First run without side-tasks but with effective CoT control prompts; then with side-tasks but without control prompts. Verify negative correlation between controllability and monitorability when side-tasks are present.


Months 2-3: Include side-tasks and apply CoT control to suppress reasoning about them. Test across multiple AI control setups (Control Arena, Shade Arena, BigCodeBench). Report main-task success, side-task success, and controllability scores.


Months 3-4: Design varying difficulty levels of side-tasks to identify the complexity threshold where controllability breaks down—i.e., where models must reason aloud to succeed.


Months 4-6: Write and submit ICML paper. If results are inconclusive, publish LessWrong post and explore adjacent directions (e.g., whether models can be trained to fake low controllability).


Outputs: ICML submission (or LessWrong post if negative results); open-source evaluation suite.
Risks: Malicious actors could exploit findings to craft prompts that help models evade monitors. Mitigation: findings are intended for developers to allocate additional safety resources; existing input/output monitors provide defense-in-depth.
Failure Modes: (1) Unable to establish clear controllability thresholds—mitigated by focusing on relative comparisons between model-task pairs. (2) Prompting doesn't reflect natural model behavior—mitigated by adversarial elicitation techniques that pressure models to control CoT for self-preservation.


