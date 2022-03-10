// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "contracts/token.sol";

contract StakingRewards {
    IERC20 public rewardsToken;
    IERC20 public stakingToken;

    Token public votingToken;

    uint public rewardRate = 100;
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;

    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;

    uint private _totalSupply;
    mapping(address => uint) private _balances;

    constructor(address _stakingToken, address _rewardsToken, address _voteToken) {
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
        votingToken = Token(_voteToken);
    }

    function rewardPerToken() public view returns (uint) {
        if (_totalSupply == 0) {
            return 0;
        }
        return
            rewardPerTokenStored +
            (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / _totalSupply);
    }

    function earned(address account) public view returns (uint) {
        return
            ((_balances[account] *
                (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) +
            rewards[account];
    }

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        rewards[account] = earned(account);
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
        _;
    }

    function stake(uint _amount) external updateReward(msg.sender) {
        require(stakingToken.balanceOf(msg.sender)!=0, "your staked token balance is 0");
        require(stakingToken.balanceOf(msg.sender)>= _amount, "your staking token is lack");
        _totalSupply += _amount;
        _balances[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        votingToken.mint(msg.sender, _amount);
    }

    function withdraw(uint _amount) external updateReward(msg.sender) {
        require(_balances[msg.sender] >= _amount, "your staked token is lack");
        _totalSupply -= _amount;
        _balances[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function getReward() external updateReward(msg.sender) {
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);
    }
}

