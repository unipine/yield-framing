// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RewardToken.sol";
import "./StableToken.sol";

contract DecentralBank {
    string public name = "Decentral Bank";
    address public owner;
    StableToken public stable;
    RewardToken public reward;

    address[] public stakers;

    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(RewardToken _reward, StableToken _stable) {
        reward = _reward;
        stable = _stable;
        owner = msg.sender;
    }

    // staking function
    function deposit(uint256 _amount) public {
        // staking amount should be greater than zero
        require(_amount > 0, "BANK: deposit amount is 0");

        // transfer stable tokens to this contract address for staking
        stable.transferFrom(msg.sender, address(this), _amount);
        // update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // update staking balance status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // unstake tokens
    function withdraw() public {
        uint256 balance = stakingBalance[msg.sender];
        // the balance should be greater than zero
        require(balance > 0, "BANK: staking balance is 0");

        // transfer the tokens to the specified contract address from decentralized bank
        stable.transfer(msg.sender, balance);
        // reset staking balance
        stakingBalance[msg.sender] = 0;
        // update staking Status
        isStaking[msg.sender] = false;
    }

    // rewards
    function rewards() public {
        // caller should be the owner
        require(msg.sender == owner, "BANK: caller is not the owner");

        // send tokens to all stakers
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint256 balance = stakingBalance[recipient] / 10;
            if (balance > 0) {
                reward.transfer(recipient, balance);
            }
        }
    }
}