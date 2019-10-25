# Introduction to Libraries

In simple terms, a library is the reusable piece of code which is deployed once and shared many times. But libraries are not just limited to reusability, there are few other areas where ethereum developers are using the library feature. These will be discussed in further topics.

Libraries are not meant to change state of contract, They should only be used to perform simple operations based on input and return result.

## Advantages of using Libraries

Solidity libraries have the following advantages/use cases

### 1. Code Reusability
Functions in a library can be used by many contracts. If you have many contracts that have some common code, then you can deploy that common code as a library.

### 2. Economical Contract Deployment
Deploying common code as library will save gas as gas depends on the size of the contract too. Using a base contract instead of a library to split the common code won’t save gas because in Solidity, inheritance works by copying code.

## DelegateCall and How it is useful for Library Implementation.

Extracted from the solidity documentation, 
There exists a special variant of a message call, named delegatecall which is identical to a message call apart from the fact that the code at the target address is executed in the context of the calling contract and msg.sender and msg.value do not change their values.

This means that a contract can dynamically load code from a different address at runtime. Storage, current address and balance still refer to the calling contract, only the code is taken from the called address.

This makes it possible to implement the “library” feature in Solidity: Reusable library code that can be applied to a contract’s storage, e.g. in order to implement a complex data structure.

## Deployment of Libraries

Library deployment is a bit different from regular smart contract deployment. There are two scenarios in library deployment:

### 1. Embedded Library

Here the Ethereum Virtual Machine simply embeds library into a contract if the library being consumed has only internal functions. Instead of using delegate call to call a function, it simply uses JUMP statement(normal method call). There is no need to separately deploy library in this scenario.

### 2. Linked Library
if a library contain public or external functions then the library needs to be deployed. Deployment of the library will generate a unique address on blockchain. This address needs to be linked with calling contract.

Both of these concepts are properly explained inside the SafeMath directory.