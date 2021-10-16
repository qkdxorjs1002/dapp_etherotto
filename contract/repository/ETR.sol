pragma solidity ^0.5.1;

import "./SCoin.sol";

contract ETR is SCoin {

    /** 
     * 토큰 기준 가치
     * 1000 : 1ETH = 1000ETR
     */
    uint16 private tokenValue;

    /**
     * 이벤트
     */
    event Exchange(address indexed from, address indexed to, uint256 amount);

    /**
     * 계약 생성자
     */
    constructor (uint256 _initialSupply, uint16 _tokenValue) SCoin(_initialSupply) public payable { 
        tokenValue = _tokenValue;
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
    
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        //require(_to != 0x0);
        require(coinBalance[_from] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);

        coinBalance[_from] -= _amount;
        coinBalance[_to] += _amount;
        
        emit Transfer(_from, _to, _amount);

        return true;
    }
    
    function getTokenBalance() public view returns(uint256) {
        return coinBalance[msg.sender];
    }
    
    function getTokenBalance(address _target) public view onlyOwner returns(uint256) {
        return coinBalance[_target];
    }
    
} 