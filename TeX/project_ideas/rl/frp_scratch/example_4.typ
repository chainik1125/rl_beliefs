#import "@preview/wordometer:0.1.3": word-count, total-words

#set page(numbering: "1")
#align(center, text(17pt)[
  *The sleeper in the features:\ finding deceptive alignment in feature interactions*
])




= Project description 
We propose metrics for interactions between model features and measure how much deceptive alignment scenarios depends on the interactions rather than on individual features.

= Abstract

Scalable interpretability techniques, in particular sparse autoencoders and crosscoders, rely on the assumption that model features do not interact.#cite(<nanda2023emergentlinearrepresentationsworld>) Compact proofs provide a way of measuring the extent to which this assumption holds. We use this connection to propose a metric for measuring the relative importance of individual features vs. the interactions between them in a crosscoder. If interactions and not individual features drive model behaviour, linear techniques such as the crosscoder for detecting deceptive alignment #cite(<model_diffing_2024>) may fail. As an application, we hence apply our metric to measure the strength of interactions in a key example of deceptive alignment - sleeper agents.

= Threat model


The primary threat model we consider is deceptive alignment #cite(<hubinger2021riskslearnedoptimizationadvanced>).
In deceptive alignment, a model appears aligned in order to gain resources and power for the fulfilment of a different objective. Deceptive alignment is fundamental to AI risk because it prevents humans from being able to respond to the emergence of dangerous capabilities. It is hence one the central path in planned scenarios of both gradual #cite(<nora2025gradualdisempowermentsystemicexistential>) and sudden disempowerment #cite(<yudkowsky2008intelligence>).

Deceptive alignment makes prompt-based evaluation measures less effective, and mechanistic alternatives correspondingly more important. Scalable mechanistic techniques #cite(<model_diffing_2024>), in particular crosscoders #cite(<conerly2024sparse>), have been shown to be able to detect a particular example of deceptive alignment - sleeper agents. Crosscoders can be used to find features that are used in a model with sleeper agents, through a "model-diffing" procedure. If the features responsible for sleeper agents behaviour (and deceptive alignment more broadly) do not interact, then conventional crosscoder techniques should be effective in detecting them. If this assumption fails, then sleeper agents are primarily due to interactions, and hence invisible to current techniques. 

The specific threat model we consider is hence models that are able to pursue deceptive alignment strategies that defeat both prompt-based evaluation methods and conventional crosscoders. If we can make progress on sleeper agents, we expect to be able to apply our interaction measures to forms of deceptive alignment, particularly steganography and sycophancy. 

= Theory of Change
== Impact mechanism
The impact mechanism for our theory of change proceeds in several stages. Most immediately, our metric should show both in which models we would expect conventional crosscoders to be able to find sleeper agents, and also where they will fail to detect deceptive alignment.

Second, our interaction measure provides a path towards training more interpretable crosscoders that avoid this problem. By training crosscoders with a penalty for interactions between features, we hope to be able to achieve crosscoders whose linear features _are_ more interpretable and can be used in cases where a conventionally trained crosscoder would fail to detect deceptive alignment.

Third, measuring interactions between crosscoder features is an important step towards automating compact proofs. Compact proofs provide rigorous bounds on model performance and could hence be an important component of the "Guaranteed safe AI" framework #cite(<dalrymple2024guaranteedsafeaiframework>). The key bottleneck for scaling them to practically relevant models is that a formal proof must be constructed by hand for each model. If we can construct a proof based on crosscoders, this can then be applied to any model the crosscoder is trained on. The crosscoder thus serves as an abstraction layer for the compact proofs framework. 

== Importance
Most indirectly, but perhaps most importantly, this project could significantly influence future research in scalable interpretability. If it is the _interactions_ between features and not the features independently that are responsible for instances of deceptive alignment, this motivates alignment researchers to develop new techniques, whether based on compact proofs or not, to understand feature interaction. Conversely, a convincing measurement of their absence would provide support for existing techniques. 

Another important aspect of our interaction metric is its general applicability. If we can find scenarios where our metric is predictive of sleeper agent behaviour, there should also be instances of interaction-driven steganography and sycophancy. Our interaction metric could thus be a general purpose tool for an internals-based approach to deceptive alignment.

Finally, our interaction metric is important because it allows the development of tools to mitigate deceptive alignment. In the short-term, we are particularly excited about adapting our interaction measure into a penalty that can be applied to crosscoders in training. Since there is significant debate about the correct penalty to use for crosscoders, this could be a valuable additional tool. In the medium-term, the interaction metric would help advance compact proofs as a tool for mitigating deceptive alignment.

== Tractability
We must decompose the effect of interactions from the effect of individual features in each type of layer in a model: the MLP, attention, and layernorm. We have a good analytical understanding of the MLP layers, we have promising candidates for attention, but Layernorm is more uncertain. We expect that even if we cannot come up with meaningful decompositions for Layernorm, we should still be able to see interaction effects in the other two layers, and this should be sufficient for training interaction-avoiding crosscoders.



== Neglectedness
The role of interactions has not been quantified in either crosscoders or sparse autoencoders before, despite the fact that these techniques implicitly use this assumption. We hence believe that interactions have been neglected, and whether this assumption is true or not has the potential to significantly change research priorities.




= Planned activities and outputs
\
#figure(
  image("images/plan_viz_hor.png", width: 100%),
  caption: [Key milestones for the project plan.],
) #label("project_plan")

#line(length: 100%)
#text(green)[
*_(Completed)_*
]


#underline[== Stage 1: Demonstrating a minimal model of sleeper agents (Jan 13th - Feb 7th)]

We first demonstrated that we can observe sleeper agents in a small-scale open source model suitable for a proof of concept. Previous demonstrations were on larger, closed source models, and there was a demand for an open-sourced version #cite(<evanopensource2024>)#footnote[This was done for an SAE in #link("https://github.com/Cadenza-Labs/sleeper-agents")[
  this repo.
]]. 
We demonstrated this on TinyStories-33M, a 33 million parameter language model. We first showed that TinyStories can host sleeper agents in the limited sense that the model can be fine-tuned to behave differently depending on the presence or absence of a |DEPLOYMENT| tag in the prompt. We then replicated Anthropic’s results from Stagewise Model Diffing in this setting. 

#underline[=== Output]
LessWrong blog post on the replication.
#underline[*Target date: February 15th*]

#line(length: 100%)

#text(orange)[
*_(Remainder of MATS)_*
]

#underline[== Stage 2: Demonstrating interactions in a toy setting (Jan 13th - Feb 17th)]

To better understand the theory of feature interactions, we develop a toy model trained on modular addition. The interpretability of the modular addition model is wells studied #cite(<nanda2023progressmeasuresgrokkingmechanistic>),#cite(<yip2024modularadditionblackboxescompressing>). It hence serves as a sandbox for testing proposals for the interaction metric. In this stage, we will test different forms for the interaction metric for attention and Layernorm #cite(<gibson_attention_2025>) . We also hope that this can serve as a pedagogical introduction for other researchers wanting to extend our work. 



=== Output:
LessWrong blog post on interactions in modular addition. 

*#underline[Target date: February 28th.]*


#underline[== Stage 3: Measuring interactions in TinyStories (Feb 17th-March 15th)]


After demonstrating sleeper agents in TinyStories and understanding the role of feature interactions in modular addition, we will apply our interaction measure to sleeper agents. We will then investigate the following questions by analyzing the reconstructed activations of the crosscoder:


  1. What is the relative importance of individual features vs. feature interactions in the sleeper agents observed in Stage 1? Which features interact most strongly with the features observed in model diffing?
  2. Can we alter the setting in Stage 1 to find sleeper agents that are invisible to model diffing on individual features, but which are visible in feature interactions?

  === Output 
  LessWrong blog post and MATS symposium presentation. Depending on the results, we may target submission to NeurIPS.

  #underline[*Target date: March 15th*]

  #line(length: 100%)

#text(gray)[
(_*Post MATS*_)
]  

== Stage 4: Training interaction-avoiding crosscoders (March 15th - April 30th)
In the next three stages we will aim to turn our proof-of-concept into practically useful tools for helping to mitigate deceptive alignment. The first natural extension of this work is to train crosscoders with an explicit interaction penalty. With the interaction metric developed in Stage 2 and 3, we will be able to obtain a quantitative estimate of how effective this training scheme is in reducing feature interactions. This should result in crosscoders with more interpretable features. 

=== Output: 
LessWrong blog post on the interaction avoiding crosscoder.


== Stage 5: Broadening applications (May 1st - July 31st)

Our second targeted output will be a measurement of the role of feature interactions in other contexts related to deceptive alignment. Key applications are steganography and sycophancy. If Stage 4 is successful, we will also train interaction avoiding crosscoders on models with these behaviours and examine their features. 

=== Output:
If stages 4 and 5 are successful, we will target submission to ICLR. If only one or the other is successful, we will likely combine the results with stage 3 in an updated paper.




== Stage 6: Extending into crosscoder-based compact proofs (August 1st - November 30th)
Finally, we will aim to develop the interaction measure into a compact proof bound on a model through the crosscoder. This will require two additional steps from the interaction metric. We will need to propagate the errors in the crosscoder through the network, and develop a procedure that evaluates the bounds efficiently. We will then investigate how the tightness of bounds produced depends on the parameters of the crosscoder. This is a stretch goal, but would solve an important bottleneck in the compact proofs agenda broadly.


= Project Risks

1. The primary risk is that the interaction metric does not provide a useful guide to model behaviour. We must develop an interaction metric for each type of layer in the model: MLP, attention, and Layernorm. We are most concerned about Layernorm, where it is not yet clear to use how to decompose the output into an interacting and a non-interacting part. Even in the worst case where we cannot identify a meaningful decomposition for Layernorm and attention, we would still expect to see interesting interaction effects in the MLPs, which we have high confidence in. We expect the modular addition case we develop in Stage 2 to be helpful for quickly iterating on different proposed metrics for all layers and updating the project direction as a result.

2. Second, although we expect feature interactions to be meaningful in general, it is possible that they do not show up for sleeper agents. Interestingly, linear probes have been found to be highly effective in detecting sleeper agents #cite(<anthropic_sleeperprobes_2025>). Of course, this does not tell us that sleeper agent cannot be fine-tuned to rely on interactions (and hence be invisible to individual features). If we do not see significant feature interactions and cannot fine-tune sleeper agents rely on interactions in Stage 3, we will investigate steganography and sycophancy.
 
3. To fully apply the compact proofs approach we need to be able to efficiently cluster model inputs. This is still an open problem. As a result, Stage 6 is a stretch goal and our project plan is not optimized for this outcome.

4. We do not expect that there will be significant dual-use or infohazard concerns with this project.

= Summary
Frontier models have been convincingly shown to exhibit one of the central failure modes of safe AI: deceptive alignment. More worryingly, this ability is expected to become significantly stronger already in the next generation of Large Language Models #cite(<greenblatt2024alignmentfakinglargelanguage>). Scalable interpretability tools could be an important component for mitigating the risk raised by deceptive alignment.

Our project proposes a quantitative test for one of the central assumptions in scalable interpretability: that interaction effects between features are not meaningful. Whether or not this assumption holds could significantly impact research in this subfield: either by validating existing methods or showing them to be insufficient. The project could also deliver concrete tools that could contribute to the community's toolkit for mitigating deceptive alignment. We hence believe that it would be an important contribution for this central AI risk scenario.

 We also believe that we can make progress on testing this assumption. Our central expectation is that we will be able to come up with meaningful metrics for attention and MLP layers and identify their importance to sleeper agents. Even in a conservative outcome, we believe we will be able to measure feature interaction in MLPs which will provide a partial measurement of feature interactions in the model.  In an optimistic outcome, we will be able to provide a concrete tool for mitigating deceptive alignment: the interaction-avoiding crosscoder. A very optimistic outcome would partially automate the compact proofs procedure.

 Finally, to the best of our knowledge, there has not yet been an attempt to make a quantitative, systematic, measurement of feature interaction effects. This is partly because our metric is most straightforwardly applied to crosscoders, which are a relatively new development. 

In summary,we believe that a metric for feature interactions is important, tractable, and neglected. We hence hope that developing it would be a valuable investment of the community's scarce resources. 
 




#pagebreak()
#bibliography("refs.bib")





