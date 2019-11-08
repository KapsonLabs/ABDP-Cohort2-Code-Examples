pragma solidity >=0.4.21 <0.6.0;

contract SupplyChainAccessRestriction {

    address owner;

    uint private skuCount;

    enum State{ForSale, Sold, Shipped, Received}

    struct Item {
        string name; 
        uint sku;
        uint256 price; 
        State state;
        address payable seller;
        address payable buyer;
    }

    mapping(uint => Item) public items;
  
    event ForSale(uint sku);

    event Sold(uint sku);

    event Shipped(uint sku);

    event Received(uint sku);

  /* Create a modifer that checks if the msg.sender is the owner of the contract */

    modifier verifyOwner(){
        require(
            msg.sender == owner,
            "Only the owner can call this function"
            );
        _;
    }

    modifier verifyCaller(address _address) { 
        require(
            msg.sender == _address,
            "Only verified role players can call this function"
            ); 
        _;
    }

    modifier paidEnough(uint _price) { 
        require(
            msg.value >= _price,
            "You dont have enough money to make this purchase"
            ); 
        _;
    }

    modifier checkValue(uint _sku) {
      //refund them after pay for item (why it is before, _ checks for logic before func)
        _;
        uint _price = items[_sku].price;
        uint amountToRefund = msg.value - _price;
        items[_sku].buyer.transfer(amountToRefund);

    }

    /*Modifier to restrict sellers from buying their own items. Everyone should have 
    A UNIQUE ROLE IN the supply chain*/
    modifier enforceSellerRole(address _address){
        require(
            msg.sender != _address,
            "A seller cannot participate in the buying process of the same product"
            );
        _; 
    }


    modifier forSale(uint _sku){
        require(
            items[_sku].state == State.ForSale,
            "This item is for sale."
            );
        _;
    }

    modifier sold(uint _sku){
        require(
            items[_sku].state == State.Sold,
            "This item has already been sold"
            );
        _;
    }

    modifier shipped(uint _sku){
        require(
            items[_sku].state == State.Shipped,
            "This item has already been shipped"
            );
        _;
    }

    modifier received(uint _sku){
        require(
            items[_sku].state == State.Received,
            "This item has already been received"
            );
        _;
    }

    constructor() public {
        owner = msg.sender;
        skuCount = 0;
    }

    function addItem(string memory _name, uint _price) public returns(bool){
        emit ForSale(skuCount);
        items[skuCount] = Item(_name, skuCount, _price, State.ForSale, msg.sender, address(0));
        skuCount = skuCount + 1;
        return true;
    }


    function buyItem(uint sku)
      public
      payable
      forSale(sku)
      paidEnough(items[sku].price)
      enforceSellerRole(items[sku].seller)
      checkValue(sku)
    {
        items[sku].state = State.Sold;
        /*The address that calls the function is assigned as the buyer*/
        items[sku].buyer = msg.sender; 
        //transfer ether to the seller
        items[sku].seller.transfer(items[sku].price);
        emit Sold(items[sku].sku);
    }

    function shipItem(uint sku)
      public
      sold(sku)
      verifyCaller(items[sku].seller)
    {
        items[sku].state = State.Shipped;
        emit Shipped(items[sku].sku);
    }

    function receiveItem(uint sku)
      public
      shipped(sku)
      verifyCaller(items[sku].buyer)
    {
        items[sku].state = State.Received;
        emit Received(items[sku].sku);
    }

    function fetchItem(uint _sku) public view returns (string memory name, uint sku, uint price, uint state, address seller, address buyer) {
        name = items[_sku].name;
        sku = items[_sku].sku;
        price = items[_sku].price;
        state = uint(items[_sku].state);
        seller = items[_sku].seller;
        buyer = items[_sku].buyer;
        return (name, sku, price, state, seller, buyer);
    }
}