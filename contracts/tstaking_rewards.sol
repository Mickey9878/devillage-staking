// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract TStakingRewards {

    address public admin;

    IERC20 public rewardsToken;
    IERC20 public stakingToken;

    uint public rewardRate ;
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;

    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;

    uint private _totalSupply;
    mapping(address => uint) private _balances;

    constructor() {
        admin = msg.sender;
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

    /********************************************************
     *                                                      *
     *               ADMIN-ONLY FUNCTIONS                   *
     *                                                      *
     ********************************************************/

    /*
     * Set reward distribution speed.
     *
     * @param rewardToken Reward token speed to change
     * @param speed New reward speed
     */
    function setRewardSpeed(uint _rewardRate) external adminOnly {
        rewardRate = _rewardRate;
    }

    /*
     * Set ERC20 reward token contract address.
     *
     * @param _rewardsToken Reward token address to set
     */
    function setRewardTokenAddress(address _rewardsToken) external adminOnly {
        rewardsToken = IERC20(_rewardsToken);
    }

    /*
     * Set the staked token contract address.
     *
     * @param _stakingToken New staked token contract address
     */
    function setStakedTokenAddress(address _stakingToken) external adminOnly {
        stakingToken = IERC20(_stakingToken);
    }


    /********************************************************
     *                                                      *
     *                      MODIFIERS                       *
     *                                                      *
     ********************************************************/

    modifier adminOnly {
        require(msg.sender == admin, "admin only");
        _;
    }
}

