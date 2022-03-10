// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "contracts/token.sol";

contract Voting{

    IERC20 public votingToken;
    IERC20 public xToken;
    ERC20Burnable public VotingToken;
    Token public XToken;
    address team;

    constructor(address _votingToken, address _xToken, address _team){
        votingToken = IERC20(_votingToken);
        xToken = IERC20(_xToken);
        VotingToken = ERC20Burnable(_votingToken);
        XToken = Token(_xToken);
        team = _team;

    }
    function convert(uint _amount) external {
        require(votingToken.balanceOf(msg.sender) >= _amount, "your staked token is lack");
        VotingToken.burnfrom(msg.sender, _amount);
        XToken.mint(team, _amount);

    }
    
}