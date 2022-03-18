const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });


async function main() {



    const whitelistContract = "0x793695e5fD072488e012c932952BA4343F07F57b";
    const metadataURL = "https://mint.kleoverse.com/api/";
    const kleoverseContract = await ethers.getContractFactory("KleoverseNFTMint");
    const deployedkleoverseContract = await kleoverseContract.deploy(metadataURL, whitelistContract);
    console.log("Kleoverse Minter Contract Address:", deployedkleoverseContract.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
