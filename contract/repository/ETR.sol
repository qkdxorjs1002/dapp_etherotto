pragma solidity ^0.5.1;

import "../Ownable.sol";

contract ETR is Ownable {

    /** 
     * 토큰 기준 가치
     * 1000 : 1ETH = 1000ETR
     */
    uint16 private tokenValue;
    
    mapping(address => uint256) public tokenBalanceList;

    /**
     * 이벤트
     */
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Exchange(address indexed from, address indexed to, uint256 amount);

    /**
     * 계약 생성자
     */
    constructor (uint256 _initialSupply, uint16 _tokenValue) public payable { 
        tokenValue = _tokenValue;
        mint(msg.sender, _initialSupply);
    }
    
    function getTokenBalance(address _target) public view onlyOwner returns(uint256) {
        return tokenBalanceList[_target];
    }

    function transfer(address _to, uint256 _amount) public {
        require(tokenBalanceList[msg.sender] >= _amount);
        require(tokenBalanceList[_to] + _amount >= tokenBalanceList[_to]);

        tokenBalanceList[msg.sender] -= _amount;
        tokenBalanceList[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        require(tokenBalanceList[_from] >= _amount);
        require(tokenBalanceList[_to] + _amount >= tokenBalanceList[_to]);

        tokenBalanceList[_from] -= _amount;
        tokenBalanceList[_to] += _amount;
        
        emit Transfer(_from, _to, _amount);

        return true;
    }

    function mint(address _recipient, uint256 _mintedAmount) public payable onlyOwner {
        tokenBalanceList[_recipient] += _mintedAmount;

        emit Transfer(ownerAddress, _recipient, _mintedAmount);
    }
} 