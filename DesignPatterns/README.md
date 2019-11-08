# Design Patterns.

A DESIGN PATTERN is a reusable solution to a problem that commonly occurswithin a given context during software design. 
We investigate some existing patterns for distributed system, peer-to-peer system and software design patterns in general, and assess the applicability of the existing patterns to the design of smart contracts. The study results in the experiences that there aresome reusable solutions that can be applied to the design of smart contract in a blockchain-based system.

The patterns are divided into four categories: Creational Patterns, Structural Patterns, Inter-Behavioral Patterns and Intra-Behavioral Patterns.

By using these patterns, blockchains can not only be used for storing or exchanging data, but also handle more complicated programs with complex logic, which can beneﬁt developers on building applications on the blockchain.

Design patterns can also help immensely in securing contracts because they have been vetted by the community and battle-tested in production. Developing with a security mindset is extremely important as the cost of failure can be high and change can be difficult. A basic defence mechanism against known vulnerabilities is therefore not enough. It’s recommended to use secure design patterns like rate limiters, exit strategies or circuit breakers to protect your contract against unexpected events.

## Commonly Used Design Patterns
### 1. Access Restriction Pattern
The restricting access pattern introduces Role Based Access Control to smart contracts. Some functionlaity is reserved for higher privileged users like admins and others are left accessible to other contract users. The restricting access pattern makes use of state variables and modifiers to enforce Role Based Access Control.

### 2. Check Effects Interaction Pattern.
This is the general guideline when coding any smart contract as it describes how to build up a function. You start with validating all the arguments and throwing appropriate errors when the args do not apply with the expected input. Next, you can make changes to the smart contract’s state and finally interact with other smart contracts.

Interacting with other contracts should always be the last step in your function as this mostly includes handing over the control to another contract. So, when we are handing over the control, it’s crucial that the current contract has finished its functionality and does not depend on the execution of the other contract. Here’s an example that comes from an Auction contract to set the end of the auction using a boolean.

### 3. Emergency Stop Pattern/ Circuit Breaker Pattern.
A circuit breaker, also referred to as an emergency stop, is capable of stopping the execution of functions inside the smart contract. A circuit breaker can be triggered manually by trusted parties included in the contract like the contract admin or by using programmatic rules that automatically trigger the circuit breaker when the defined conditions are met. The most common usage of a circuit breaker is when a bug is discovered.

