import { useState } from 'react';
import { ethers } from 'ethers';

function WalletBalance() {

    const [balance, setBalance] = useState();
    
    const getBalance = async () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        const signer = provider.getSigner();
        const account = await signer.getAddress();
        console.log("Account:: ", account);
        const balance = await provider.getBalance(account);
        setBalance(ethers.utils.formatEther(balance));
    };
  
    return (
      <div className="card">
        <div className="card-body">
          <h5 className="card-title">당신의 잔액: {balance} ETH</h5>
          <button className="btn btn-success" onClick={() => getBalance()}>잔액 확인</button>
        </div>
      </div>
    );
  };
  
  export default WalletBalance;