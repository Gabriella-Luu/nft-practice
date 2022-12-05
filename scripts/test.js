const Web3 = require('web3')
const web3 = new Web3('http://127.0.0.1:7545')

const nftBuild = require('../build/contracts/NFT.json')
const nftContract = new web3.eth.Contract(nftBuild.abi, nftBuild.networks[5777].address)

const amountToMint = 1
const gas = 450000

const main = async () => {
    const allAccount = await web3.eth.getAccounts()

    console.log(`Attempting to mint NFT for ${allAccount[0]}...\n`)

    await nftContract.methods.mintNFT(`ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/1.jpg`).send({ from: allAccount[0], value: 0, gas: gas })
    await nftContract.methods.mintNFT(`ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/2.jpg`).send({ from: allAccount[0], value: 0, gas: gas })
    await nftContract.methods.mintNFT(`ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/3.jpg`).send({ from: allAccount[1], value: 0, gas: gas })
    await nftContract.methods.mintNFT(`ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/4.jpg`).send({ from: allAccount[1], value: 0, gas: gas })
    await nftContract.methods.mintNFT(`ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/5.jpg`).send({ from: allAccount[1], value: 0, gas: gas })

    for (var j = 0; j < allAccount.length; j++){
        const totalMinted = await nftContract.methods.wallet().call({from: allAccount[j]})
        console.log(`Total NFTs minted for account ${j}: ${totalMinted.length}`)
        for (var i = 0; i < totalMinted.length; i++) {
            const uri = await nftContract.methods.tokenURI(totalMinted[i]).call()
            console.log(`Metadata URI for token ${totalMinted[i]}: ${uri}`)
        }
        console.log(`\n`)
    }

    await nftContract.methods.like(3).call({from: allAccount[0]})
    await nftContract.methods.like(1).call({from: allAccount[0]})
    await nftContract.methods.like(2).call({from: allAccount[0]})
    await nftContract.methods.like(2).call({from: allAccount[1]})
    await nftContract.methods.dislike(3).call({from: allAccount[1]})
    await nftContract.methods.dislike(4).call({from: allAccount[1]})
    await nftContract.methods.dislike(3).call({from: allAccount[3]})

    for (var j = 0; j < allAccount.length; j++){
        const totalMinted = await nftContract.methods.wallet().call({from: allAccount[j]})
        console.log(`Total NFTs minted for account ${j}: ${totalMinted.length}`)
        for (var i = 0; i < totalMinted.length; i++) {
            const likes = await nftContract.methods.likeCount(totalMinted[i]).call()
            const dislikes = await nftContract.methods.dislikeCount(totalMinted[i]).call()
            console.log(`likes for token ${totalMinted[i]}\t: ${likes}`)
            console.log(`dislikes for token ${totalMinted[i]}\t: ${dislikes}`)
        }
        console.log(`\n`)
    }
}

main()