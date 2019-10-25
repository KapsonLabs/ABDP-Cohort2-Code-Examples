# A Primer on Inheritance.

Inheritance is one of the pillars of object orientation and Solidity supports inheritance between smart contracts. Inheritance is the process of defining multiple contracts that are related to each other through parent-child relationships.

The contract that is inherited is called the parent contract and the contract that inherits is called the child contract.
Similarly, the contract has a parent known as the derived class and the parent contract is known as a base contract.

Inheritance is mostly about code-reusability. There is a is-a relationship between base and derived contracts and all public and internal scoped
functions and state variables are available to derived contracts.

In fact, Solidity compiler copies the base contract bytecode into derived contract bytecode. The is keyword is used to inherit the base contract in the derived contract. It is one of the most important concepts that should be mastered by every Solidity developer because of the way contracts are versioned and deployed.

Solidity supports multiple types of inheritance, including single inheritance, multiple inheritance, multi-level inheritance and hierachiccal inheritance. Solidity copies the base contracts into the derived contract and a single contract is created with inheritance. A single address is generated that is shared between contracts in a parent- child relationship.

## Multiple Inheritance and Linearization

Solidity resembles Python since they both follow C3 Linearization. These rules mean that the sequence of base classes in the directive is important. Direct base contracts must be presented in the order from most base-like to most derived.

After Solidity calls functions that are declared several times in separate contracts, it searches the provided bases from right to left. The search ends at the first match.

```
pragma solidity >=0.4.0 <0.7.0;

contract X {}
contract A is X {}
contract C is A, X {}
```

The code snippet above triggers an error because C requests X to replace A, but A asks to replace X. This cannot compile.

### Please note,
You need to run ```npm install openzeppelin-solidity``` to add the openzeppelin dependency.