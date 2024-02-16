const hre = require("hardhat");

async function main() {
    const DuckToken = await hre.ethers.getContractFactory("DuckToken");
    const duckToken = await DuckToken.deploy(100000000, 50);

    // await duckToken.deployed();
    // const contract = await duckToken.deploy();

    // console.log(duckToken);

    console.log("Duck Token deployed: ", await duckToken.getAddress());

  }
  
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });