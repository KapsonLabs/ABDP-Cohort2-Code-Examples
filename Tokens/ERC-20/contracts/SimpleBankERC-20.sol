pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
By inheriting ER20, our contract inherits the 
functionality if the ERC20 Contract from OpenZeppelin.
 */

contract SimpleBankERC20 is ERC20{
    using SafeMath for uint256;
    address private _erc20Token;

    constructor(address _reserveToken){
        _erc20Token = _reserveToken;
    }


    constructor() public{
        owner = msg.sender;
    }

    /**
    This mint function does the checks and
    calls the internal _mint function to
    update balances
     */

    function mint() external returns(bool){
        //Here we specify the price per token
        uint256 priceForTokens = _numTokens.mul(2);

        require(
            IERC20(_erc20Token).transferFrom(
                msg.sender,
                address(this),
                priceForTokens
            ),
            "TransferFrom failed, check approval and try again"
        );

        _mint(msg.sender, priceForTokens);

        return true;
    }

    function burn(uint256 _amount) external returns(bool){

        require(balances[msg.sender] >= _amount, "Insufficient Funds");

        uint256 priceForTokens = _amount.div(2);

        require(
            IERC20(_erc20Token).transfer(
                msg.sender,
                priceForTokens
            ),
            "Transfer failed"
        );

        _burn(msg.sender, priceForTokens);

        return true;
    }
}