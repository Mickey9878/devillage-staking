// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Token is ERC20, ERC20Burnable {

    address public admin;
    address public minter;

    constructor(string memory name, string memory symbol, address _minter) ERC20(name, symbol) {
        admin = msg.sender;
        minter = _minter;
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);        
    }

    modifier adminOnly {
        require(msg.sender == admin || minter, "minter only");
        _;
    }
}