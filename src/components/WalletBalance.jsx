import { useState } from 'react';
import { ethers } from 'ethers';

function WalletBalance() {

    const [balance, setBalance] = useState();
    
    const getBalance = async () => {
        const [account] = await window.ethereum.request({ method: 'eth_requestAccounts' });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
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