pragma solidity ^0.5.1;

library Object {
    
    function isEmpty(address _addressOfObject) public pure returns(bool) {
        if (_addressOfObject == address(0x0)) {
            return true;
        }
        return false;
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}

library Date {
    
    function getDayOfWeek(uint256 _timestamp) public pure returns(uint256) {
        return (uint256(_timestamp / 86400) + 4) % 7;
    }
}