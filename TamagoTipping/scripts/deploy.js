// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const gasLimit = 3000000;
  const usdc = "0x49c37d0Bb6238933eEe2157e9Df417fd62723fF6"
  const token = await hre.ethers.deployContract("TipContract", [usdc], {gasLimit});

  await token.waitForDeployment();

  console.log(token.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
