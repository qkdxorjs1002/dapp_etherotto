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
    constructor (uint256 _initialSupply, uint16 _tokenValue, uint16 _tokenDividendsRatio) SCoin(_initialSupply) public payable { 
        tokenValue = _tokenValue;
        tokenDividendsRatio = _tokenDividendsRatio;
    }

    /**
     * ETR토큰을 ETH로 환전하여 sender에 입금
     */
    function exchange(uint256 _tokenAmount) public {
        require(_tokenAmount > 0);
        require(coinBalance[msg.sender] >= _tokenAmount);

        coinBalance[msg.sender] -= _tokenAmount;
        coinBalance[address(this)] += _tokenAmount;

        if (!msg.sender.send(_tokenAmount / tokenValue)) {
            revert();
        }

        emit Exchange(msg.sender, msg.sender, _tokenAmount);
    }
    
    /**
     * 토큰 구매
     */
    function buyToken(uint256 _tokenAmount) public payable {
        require(_tokenAmount > 0);
        require(uint256(msg.value * tokenValue / 1 ether) == _tokenAmount);

        coinBalance[msg.sender] += _tokenAmount;
        coinBalance[address(this)] -= _tokenAmount;

        emit Exchange(msg.sender, address(this), _tokenAmount);
    }
    
} 