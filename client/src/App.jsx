import { useState, useEffect } from 'react'
import reactLogo from './assets/react.svg'
import { Web3 } from 'web3'
import './App.css'

function App() {
  const [account, setAccount] = useState(null); 
  const { ethereum } = window

  useEffect(() => {
    async function load() {
      if (!ethereum) return alert("Please install MetaMask.");

      const accounts = await ethereum.request({ method: "eth_requestAccounts" });

      if (accounts.length) {
        setAccount(accounts[0]);
      } else {
        console.log("No accounts found");
      }
    }
    
    load();
   }, [account]);

  return (
    <div className="App">
      Your account is: {account}
    </div>
  )
}

export default App
