## Reentrancy

A reentrancy attack can occur when you create a function that makes an external call to another untrusted contract before it resolves any effects. If the attacker can control the untrusted contract, they can make a recursive call back to the original function, repeating interactions that would have otherwise not run after the effects were resolved.

## Run examples

`npm install`

`ganache-cli`

`truffle test`

### Send, Transfer & Call

Most reentrancy attacks involve send, transfer, or call functions — it is important to understand the difference between them.

`Send` and `transfer` functions are considered safer because they are limited to 2,300 gas. The gas limit prevents the expensive external function calls back to the target contract, only providing enough gas to emit an event.

The one pitfall is when a contract sets a custom amount of gas for a send or transfer using `msg.sender.call(ethAmount).gas(gasAmount)`


The `call` function is much more vulnerable

When an external function call is expected to perform complex operations, you typically want to use the call function because it forwards all remaining gas. This opens the door for an attacker to make calls back to the original function in a single function reentrancy attack, or a different function from the original contract in a cross-function reentrancy attack.

**Wherever possible, use send or transfer in place of call to limit your security risk.**

### DAO Hack 2016

The DAO had a vulnerable function meant to split off a child DAO. The attacker used this function to recursively transfer funds from the original DAO to the child DAO that they controlled.

The hack was so damaging the Ethereum Foundation resorted to a controversial hard fork that recovered investor funds. Most supported the hard fork, but part of the community thought it violated the core principles of cryptocurrency — namely immutability — and continued to use the old chain resulting in the creation of Ethereum Classic.

Read more about the DAO hack here: http://hackingdistributed.com/2016/06/18/analysis-of-the-dao-exploit/

### Checks-effects-interactions pattern

The most reliable method of protecting against reentrancy attacks is using the `checks-effects-interactions` pattern.

This pattern defines the order in which you should structure your functions.

1. First perform any checks, which are normally assert and require statements, at the beginning of the function.
2. If check pass, then make all required state changes to the contract
3. Only after all state changes are resolved should the function interact with other contracts

By calling external functions last, even if an attacker makes a recursive call to the original function they cannot abuse the state of the contract.
