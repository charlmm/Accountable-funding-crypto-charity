// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  // Deploy Charity contract
  // const Wallet = await ethers.getContractFactory("CauseWallet");
  // const wallet = await Wallet.deploy();

  // await wallet.deployed()

  // const Cause = await ethers.getContractFactory("Cause");
  // const cause = await Cause.deploy();

  // await cause.deployed()

  const Charity = await ethers.getContractFactory("Charity");
  const charity = await Charity.deploy();

  await charity.deployed()

  console.log("Charity deployed to:", charity.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
