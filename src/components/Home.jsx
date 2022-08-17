import WalletBalance from './WalletBalance';
import { useEffect, useState } from 'react';

import { ethers } from 'ethers';
import SeeGong from '../artifacts/contracts/SeeGongNFT.sol/SeeGongToken.json';

const contractAddress = '0x2A45fccb336214985425d3Ab7853d64d4Baf884A';

const provider = new ethers.providers.Web3Provider(window.ethereum);

// get the end user
const signer = provider.getSigner();
let accounts = await provider.send("eth_requestAccounts", []);
let account = accounts[0];
provider.on('accountsChanged', function (accounts) {
    account = accounts[0];
    console.log(address); // Print new address
});

// get the smart contract
const contract = new ethers.Contract(contractAddress, SeeGong.abi, signer);


function Home() {

  const [totalMinted, setTotalMinted] = useState(0);
  useEffect(() => {
    getCount();
  }, []);

  const getCount = async () => {
    const count = await contract.lastTokenId();
    console.log(parseInt(count));
    setTotalMinted(parseInt(count));
  };

  return (
    <div>
      <WalletBalance />

      <h1>시공조아 NFT 컬렉숀</h1>
      <div className="container">
        <div className="row">
          {Array(totalMinted + 1)
            .fill(0)
            .map((_, i) => (
              <div key={i+1} className="col-sm">
                <NFTImage tokenId={i+1} getCount={getCount} totalMinted={totalMinted}/>
              </div>
            ))}
        </div>
      </div>
    </div>
  );
}

function NFTImage({ tokenId, getCount, totalMinted }) {
  const metadataCID = 'bafybeicomfef4ilufdwqbo262savz2ig4kzveynlsgat3jk5a5zcxwfluu';
  const imgCID = 'bafybeihdoxcbk53l2uis4et6azvsydks4oq3wtdojqe4ildopzc6wkrm3q';
  const metadataURI = `https://ipfs.io/ipfs/${metadataCID}/${tokenId}.json`;
  const imageURI = `https://ipfs.io/ipfs/${imgCID}/${tokenId}.png`;

  // const [isMinted, setIsMinted] = useState(false);
  // useEffect(() => {
  //   getMintedStatus();
  // }, [isMinted]);

  // const getMintedStatus = async () => {
  //   const result = await contract.isContentOwned(metadataURI);
  //   console.log(result)
  //   setIsMinted(result);
  // };

  const mintToken = async () => {
    const connection = contract.connect(signer);
    const addr = connection.address;
    const result = await contract.safeMint(account, {
      value: ethers.utils.parseEther('0.001'),
    });

    await result.wait();
    // getMintedStatus();
    getCount();
  };

  async function getURI() {
    const uri = await contract.tokenURI(tokenId);
    alert(uri);
  }

  return (
    <div className="card" style={{ width: '18rem' }}>
      <img className="card-img-top" src={totalMinted+1 != tokenId ? imageURI : 'img/placeholder.png'}></img>
      <div className="card-body">
        <h5 className="card-title">ID #{tokenId}</h5>
        {totalMinted+1 == tokenId ? (
          <button className="btn btn-primary" onClick={mintToken}>
            민팅하기
          </button>
        ) : (
          <button className="btn btn-secondary" onClick={getURI}>
            URI보기
          </button>
        )}
      </div>
    </div>
  );
}

export default Home;
