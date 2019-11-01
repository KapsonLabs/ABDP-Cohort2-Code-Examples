## Reentrancy


### Send, Transfer & Call

Because most reentrancy attacks involve send, transfer, or call functions — it is important to understand the difference between them.

`Send` and `transfer` functions are considered safer because they are limited to 2,300 gas. The gas limit prevents the expensive external function calls back to the target contract, only providing enough gas to emit an event.

The one pitfall is when a contract sets a custom amount of gas for a send or transfer using `msg.sender.call(ethAmount).gas(gasAmount)`


The `call` function is much more vulnerable

When an external function call is expected to perform complex operations, you typically want to use the call function because it forwards all remaining gas. This opens the door for an attacker to make calls back to the original function in a single function reentrancy attack, or a different function from the original contract in a cross-function reentrancy attack.

*Wherever possible, use send or transfer in place of call to limit your security risk.*
