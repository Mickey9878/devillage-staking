// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Token =await ethers.getContractFactory("Token");
  const token = await Token.deploy("village", "DEV");
  await token.deployed();
  console.log("village deployed to:", token.address);

  const VToken =await ethers.getContractFactory("Token");
  const vtoken = await VToken.deploy("vote-village", "VDEV");
  await vtoken.deployed();
  console.log("vote village deployed to:", vtoken.address);

  const TToken =await ethers.getContractFactory("Token");
  const ttoken = await TToken.deploy("team-village", "TDEV");
  await ttoken.deployed();
  console.log("vote village deployed to:", ttoken.address);

  const StakingRewards = await ethers.getContractFactory("StakingRewards");
  const staking = await StakingRewards.deploy(token.address, token.address, vtoken.address);
  await staking.deployed();
  console.log("staking deployed to:", staking.address);

  const TStakingRewards = await ethers.getContractFactory("TStakingRewards");
  const tstaking = await TStakingRewards.deploy(ttoken.address, aster.address);
  await tstaking.deployed();
  console.log("staking deployed to:", tstaking.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
