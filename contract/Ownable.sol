pragma solidity ^0.5.1;

contract Ownable {

    address public ownerAddress;

    constructor() public {
        ownerAddress = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }

}
