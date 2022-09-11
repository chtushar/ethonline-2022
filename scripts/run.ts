import { ethers } from "hardhat";

const main = async () => {
    const [owner, randomPerson] = await ethers.getSigners();
    const domainContractFactory = await ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy();
    await domainContract.deployed();
    console.log("Contract deployed to:", domainContract.address);
    console.log("Contract deployed by:", owner.address);

    const txn = await domainContract.register("doom", randomPerson.address, randomPerson.address);
    await txn.wait();

    const domainOwner = await domainContract.get("doom");
    console.log("Owner of domain:", domainOwner);
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