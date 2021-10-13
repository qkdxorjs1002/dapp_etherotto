pragma solidity ^0.5.1;

import "../Ownable.sol";

contract SCoin is Ownable {

    mapping(address => uint256) public coinBalance;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event FreezeAccount(address target, bool frozen);

    constructor(uint256 _initialSupply) public payable Ownable() {
        mint(ownerAddress, _initialSupply);
    }

    function transfer(address _to, uint256 _amount) public {
        require(coinBalance[msg.sender] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]); // prevent overflow

        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    function authorize(address _authorizedAccount, uint256 _allowance) public returns (bool success) {
        require(coinBalance[msg.sender] > _allowance);

        allowance[msg.sender][_authorizedAccount] = _allowance;

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        //require(_to != 0x0);
        require(coinBalance[_from] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);
        require(_amount <= allowance[_from][msg.sender]);

        coinBalance[_from] -= _amount;
        coinBalance[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;
        
        emit Transfer(_from, _to, _amount);

        return true;
    }

    function mint(address _recipient, uint256 _mintedAmount) public payable onlyOwner {
        coinBalance[_recipient] += _mintedAmount;

        emit Transfer(ownerAddress, _recipient, _mintedAmount);
    }

    function freezeAccount(address _target, bool _freeze) public onlyOwner {
        frozenAccount[_target] = _freeze;
        
        emit FreezeAccount(_target, _freeze);
    }
}
