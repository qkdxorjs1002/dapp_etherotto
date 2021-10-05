pragma solidity ^0.5.1;

import "./SCoin.sol";

contract ETR is SCoin {

    /** 
     * 토큰 기준 가치
     * 1000 : 1ETH = 1000ETR
     */
    uint16 private tokenValue;

    /** 
     * 토큰 배당금 비율
     * 100: 10%
     */
    uint16 private tokenDividendsRatio;

    /**
     * 이벤트
     */
    event Exchange(address indexed from, address indexed to, uint256 amount);

    /**
     * 계약 생성자
     */
    constructor (uint256 _initialSupply, uint16 _tokenValue, uint16 _tokenDividendsRatio) SCoin(_initialSupply) public payable  { 
        require((msg.value * tokenValue) == _initialSupply);
        tokenValue = _tokenValue;
        tokenDividendsRatio = _tokenDividendsRatio;
    }

    /**
     * ETR토큰을 ETH로 환전하여 sender에 입금
     */
    function exchange(uint256 _amount) public {
        require(_amount > 0);
        require(coinBalance[msg.sender] >= _amount);

        coinBalance[msg.sender] -= _amount;

        if (!msg.sender.send(_amount / tokenValue)) {
            revert();
        }

        emit Exchange(msg.sender, msg.sender, _amount);
    }
    
    /**
     * _from의 ETR토큰을 ETH로 환전하여 _to에 입금
     */
    function exchangeFrom(address _from, address payable _to, uint256 _amount) public {
        require(_amount > 0);
        require(coinBalance[_from] >= _amount);

        coinBalance[_from] -= _amount;
        
        if (!_to.send(_amount / tokenValue)) {
            revert();
        }

        emit Exchange(_from, _to, _amount);
    }

} 