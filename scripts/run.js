const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFTs");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("You deployed the Contract at:", nftContract.address);
};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch(error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();