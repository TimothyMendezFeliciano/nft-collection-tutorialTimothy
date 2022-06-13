const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('Dangerous');
    const dangerousContract = await nftContractFactory.deploy()
    await dangerousContract.deployed()
    console.log('Dangerous Contract Deployed To: ', dangerousContract.address)

    let transaction = await dangerousContract.mintDangerousNFT()
    await transaction.wait()

    transaction = await dangerousContract.mintDangerousNFT()
    await transaction.wait()
}

const runMain = async () => {
    try {
        await main()
        process.exit(0)
    } catch (e) {
        console.log(e)
        process.exit(1)
    }

}


runMain().then()
