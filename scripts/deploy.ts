import { SSL_OP_EPHEMERAL_RSA } from "constants";
import { ethers } from "hardhat";

async function BoredApeToken() {
  
  const claimerAddress = "0x1d8433a0c4ac759fbc2659490b40a04359af0822";
  //const addressSigner = await ethers.getSigner(claimerAddress);

  const badAirdrop = await ethers.getContractFactory("BoredAirDrop");
  const deployAirdrop = await badAirdrop.deploy();
  await deployAirdrop.deployed();

  console.log(await deployAirdrop.claimAirDrop([], 0, 10000000000, claimerAddress))
  console.log("Sleeping.....");
  console.log(await deployAirdrop.getStatus(claimerAddress));
  console.log("Deployed to:", deployAirdrop.address);

  await sleep(10000);
  
  //@ts-ignore
  await hre.run("verify:verify",{
    address: deployAirdrop.address,
    constructorArguments: [],
  });
}

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

BoredApeToken().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
