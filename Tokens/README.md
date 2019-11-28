# ERC(Ethereum Request for Comments) Tokens.

A token within Ethereum, that is not Ether itself, is stored in a smart contract. This all began when someone wrote a smart contract to manage balances. It is literally a mapping of addresses to numbers storing the balance of each address. Yes, it really is that simple.
mapping(address => uint256) balances;
Tokens are value counters stored in a contract. This is a simple Solidity contract demonstrating the core principles of a token:

# Important Considerations.
Below are some explanations that are important to note when discussing tokens on the Ethereum platform.

#### Native Token
The token of the blockchain that your token exists within. E.g: Ether is the native token of the Ethereum blockchain. DAI is a token created within Ethereum but is not the native token. It can often be referred to as a coin.

#### ERC
Ethereum Request for Comment. This is used for any suggestion to improve Ethereum and not only for tokens. Community members comment on these requests, which then either gets accepted or rejected by the general community.

#### EIP
Ethereum Improvement Proposals. Once an ERC has received enough positive feedback it gets formalised into an EIP. It then gets audited and assessed by the core Ethereum developers.

#### Fungible
One is equal to the other. For example, one dollar is always equal to another dollar.

#### Non-Fungible
One is not equal to another. For example, artworks. If we traded one for another we are not getting equal value. Each non-fungible item is unique.

## Categories of Tokens.
The two categories of tokens, Fungible and Non-Fungible Tokens.

