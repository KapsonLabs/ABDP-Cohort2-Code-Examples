pragma solidity >=0.4.21 <0.6.0;

library SafeMathLinked {

    function mul(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }


    function div(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }


    function sub(uint256 a, uint256 b) external pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }


    function add(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
