import { ethers } from "hardhat";

const main = async () => {
    const [owner, randomPerson] = await ethers.getSigners();
    const domainContractFactory = await ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy('cross');
    await domainContract.deployed();
    console.log("Contract deployed to:", domainContract.address);
    console.log("Contract deployed by:", owner.address);

    let txn = await domainContract.register("doom", owner.address, owner.address, {value: ethers.utils.parseEther('0.0001')});
    await txn.wait();

    const domainOwner = await domainContract.get("doom");
    console.log("Owner of domain:", domainOwner);

    const balance = await ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", ethers.utils.formatEther(balance));
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();