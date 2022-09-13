import { MINT } from './taskNames';
import { task } from "hardhat/config";

import deployments from '../deployments.json';

task(MINT, "Mints a new NFT").setAction(async (taskArgs, hre) => {
    const { ethers } = hre;
    
    const contract = await ethers.getContractFactory("Domains");
    const minter = await contract.attach(deployments.domains);

    const txn = await minter.register("doom3", "0x2fec772214B6B98dcF14DdE1602c349cc58C04E7", "0x2fec772214B6B98dcF14DdE1602c349cc58C04E7", { value: ethers.utils.parseEther("0.0001") });
    txn.wait();
    console.log("Minted NFT: ", txn);
})