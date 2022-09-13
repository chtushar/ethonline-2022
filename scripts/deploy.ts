import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners();
  const domainContractFactory = await ethers.getContractFactory('Domains');
  const domainContract = await domainContractFactory.deploy("cross");
  await domainContract.deployed();

  console.log("Contract deployed to:", domainContract.address);
  
  // let txn = await domainContract.register("doom",  owner.address, owner.address, {value: ethers.utils.parseEther('0.0001')});
  // await txn.wait();
  // console.log("Minted domain doom.cross");

  // const nft = await domainContract.get("doom");
  // console.log("Owner of domain owner:", nft);

  // const balance = await ethers.provider.getBalance(domainContract.address);
  // console.log("Contract balance:", ethers.utils.formatEther(balance));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
