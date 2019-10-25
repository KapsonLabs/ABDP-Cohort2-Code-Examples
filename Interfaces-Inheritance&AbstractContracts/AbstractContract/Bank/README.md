# Abstract Contracts and their Application.

Abstracts contracts are contracts that have partial function definitions. You cannot create an instance of an abstract contract.
An abstract contract must be inherited by a child contract for utilizing its functions.
Abstract contracts help in defining the structure of a contract and any class inheriting from it must ensure to provide an implementation for them.
If the child contract does not provide the implementation for incomplete functions, even its instance cannot be created.
The function signatures terminate using the semicolon, ; , character.
There is no Solidity-provided keyword to mark a contract as abstract.
A contract becomes an abstract class if it has functions without implementation.

