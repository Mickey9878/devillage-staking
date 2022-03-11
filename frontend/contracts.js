const { ethers } = require("ethers");
import StakingRewards from './artifacts/contracts/staking_rewards.sol/StakingRewards.json';


const StakingRewardsAddress = "";
const TStakingRewardsAddress = "";


const MetaMaskClientCheck = () => {
    if (!isMetaMaskInstalled()) {
        onboardButton.innerText = 'Please install MetaMask';
    } else {
        onboardButton.innerText = 'Connect';
        onboardButton.onclick = onClickConnect;
        onboardButton.disabled = false;
    }
};
const isMetaMaskInstalled = () => {
    const { ethereum } = window;
    return Boolean(ethereum && ethereum.isMetaMask);
};

async onClickConnect() {
    try {
        //アカウントへの接続を要求
        const newAccounts = await ethereum.request({
            method: 'eth_requestAccounts',
        })
        accounts = newAccounts;
	//アカウントのアドレスを表示
        accountsDiv.innerHTML = accounts;
        if (isMetaMaskConnected()) {
	    //retrieve・storeボタンを有効化
            retrieveButton.disabled = false;
            retrieveButton.onclick = onClickRetrieve;
            storeButton.disabled = false;
            storeButton.onclick = onClickStore;
	    //provider(Metamask)を設定
            const provider = new ethers.providers.Web3Provider(ethereum);
	    //signerの設定
            const signer = provider.getSigner(0);
	    //コントラクトのインスタンスを生成
            myContract = new ethers.Contract(ContractAddress, ContractAbi, signer);
        }
    } catch (error) {
        console.error(error);
    }
};

async approve() {
    
}

async deposit() {
    if(!depositAmount) return;
    if(typeof window.ethereum !== "undefined"){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        console.log({ provider });
        const signer = provider.getSigner();
        const contract = new ethers.Contract(StakingRewardsAddress, StakingRewards.abi, signer);
        const tx = await contract.stake(depositAmount);
        await tx.wait();
    }

}

async claim() {
    if(typeof window.ethereum !== "undefined"){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        console.log({ provider });
        const signer = provider.getSigner();
        const contract = new ethers.Contract(StakingRewardsAddress, StakingRewards.abi, signer);
        const tx = await contract.getReward();
        await tx.wait();
    }
}

async withdraw() {
    if(!withdrawAmount) return;
    if(typeof window.ethereum !== "undefined"){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        console.log({ provider });
        const signer = provider.getSigner();
        const contract = new ethers.Contract(StakingRewardsAddress, StakingRewards.abi, signer);
        const tx = await contract.stake(withdrawAmount);
        await tx.wait();
    }
}