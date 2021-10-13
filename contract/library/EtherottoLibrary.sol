pragma solidity ^0.5.1;

library Object {
    
    function isEmpty(address _addressOfObject) public pure returns(bool) {
        if (_addressOfObject == address(0x0)) {
            return true;
        }
        return false;
    }
}

library Date {
    
    function getDayOfWeek(uint256 _timestamp) public pure returns(uint256) {
        return (uint256(_timestamp / 86400) + 4) % 7;
    }
}