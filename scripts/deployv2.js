
const hre = require("hardhat");

async function main() {
  


  const Version2 = await hre.ethers.getContractFactory("Push");
  const version2 = await upgrades.upgradeProxy("0xd3AEbcC433daaF520878a4A53efC0419e03d8DBb",Version2);


  await version2.deployed();

  console.log(
    ` deployed to ${version2.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
