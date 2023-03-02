const { ethers } = require("hardhat");



async function main() {
 
  const Version1 = await ethers.getContractFactory("Push");
  const version1 = await upgrades.deployProxy(Version1);

  await version1.deployed();

  console.log(
    ` deployed to ${version1.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
