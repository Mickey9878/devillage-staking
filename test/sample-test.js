const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {

  beforeEach(async function() {
    const Token =await ethers.getContractFactory("Token");
    const token = await Token.deploy("village", "DEV");
    await token.deployed();
    console.log("village deployed to:", token.address);

    const VToken =await ethers.getContractFactory("Token");
    const vtoken = await VToken.deploy("vote-village", "VDEV");
    await vtoken.deployed();
    console.log("vote village deployed to:", vtoken.address);

    const StakingRewards = await ethers.getContractFactory("StakingRewards");
    const staking = await StakingRewards.deploy(token.address, token.address, vtoken.address);
    await staking.deployed();
    console.log("staking deployed to:", staking.address);
  })
  
  it("Should return the new greeting once it's changed", async function () {

  });
});
