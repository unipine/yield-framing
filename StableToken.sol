// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StableToken {
    string public name = "Stable Token";
    string public symbol = "ST";
    uint256 public totalSupply = 1000000000000000000000000;
    uint8 public decimals = 18;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        // value should be greater and equal than balance
        require(balanceOf[msg.sender] >= _value);

        // transfer value
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // trigger transfer event
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        // set allowance bye the value
        allowance[msg.sender][_spender] = _value;

        // trigger approval event
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // the value should be greater or equal than from's balance
        require(_value <= balanceOf[_from]);
        // the value should be in range of allowance
        require(_value <= allowance[_from][msg.sender]);

        // transfer the value and decrease allowance
        balanceOf[_to] += _value;
        balanceOf[_from] -= _value;
        allowance[msg.sender][_from] -= _value;

        // trigger transfer event
        emit Transfer(_from, _to, _value);

        return true;
    }
}
