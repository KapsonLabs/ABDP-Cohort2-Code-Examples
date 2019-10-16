pragma solidity >=0.4.21 <0.6.0;

import "./SafeMath.sol";

contract Shop {
    using SafeMath for uint256;

    //state variables
    address owner;
    uint private itemCount;

    struct Item {
        string name; 
        uint sku;
        uint256 price; 
        address payable seller;
        address payable buyer;
    }

    mapping(uint => Item) public items;

    //events

    //modifiers

    constructor() public {
        owner = msg.sender;
        itemCount = 0;
    }
}