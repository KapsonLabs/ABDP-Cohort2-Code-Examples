# Inheritance, Interfaces and Abstract Contracts.

Extensibility is key when it comes to building larger, more complex distributed applications (dapps). In computing Extensibility refers to the ability of being designed to allow for the addition of new capabilities or functionality.
Solidity offers two ways to facilitate this in your dapps: *Abstract Contracts* and *Interfaces*.

## Inheritance.

Inheritance marks several associated contracts with a parent-child relationship. Solidity inheritance rules highly resemble Python, but they have a few differences. Inheritance generates one contract and places it into the blockchain.

 - Solidity inheritance is a process resulting in parent-child relationships between contracts.
 - There are two types of inheritance: single and multi-level.
 - Solidity constructors are optional. If not set, contracts have a default constructor.
 - You can indicate constructor arguments in two ways.

## Abstract Contracts.

Contracts in Solidity are akin to classes in object-oriented languages. They include state variables that contain persistent data as well as functions that can manipulate the data in the state variables. Contracts are identified as *Abstract Contracts* when at least one of their functions lacks an implementation. As a result, they cannot be compiled. They can however be used as base contracts from which other contracts can inherit from.

## Interfaces.

Interfaces are similar to abstract contracts, but cannot have any *implemented functions*, cannot inherit other *contracts or interfaces*, cannot define a *constructor*, cannot define *state variables*.
Interfaces can define *structs*, and *enums* begining from solidity version 0.5.0. 
Interfaces are expressed using the interface keyword
For more infos :
https://solidity.readthedocs.io/en/latest/contracts.html#interfaces


