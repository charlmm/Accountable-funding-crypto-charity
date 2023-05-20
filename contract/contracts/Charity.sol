// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Cause.sol";

contract Charity {
  address public owner;
  Cause[] public causesForFE;

  constructor() {
    owner = msg.sender;
  }

  uint causeid;
  // List of registered cause managers
 
  mapping(uint => address) public causes;
  mapping(address => uint256) public individualDonations;
  mapping(address => bool) public allowedVerifiers;

  // Register a new cause
  function registerCause(string memory causeName,string memory causeDescription, uint256 _goalAmount, address payable  _beneficiary,  string[] memory causeMilestoneGoals, uint256[] memory causeMilestoneAmounts) public {
    Cause newCause = new Cause(causeName, causeDescription,_goalAmount, _beneficiary, causeMilestoneGoals, causeMilestoneAmounts);
    causes[causeid+1] = address(newCause);
    causesForFE.push(newCause);
  }

  // Get a list of all registered causes
  function getCauses() public view returns (Cause[] memory) {
    return causesForFE;
  }

  function contributeToCause(uint _causeid) external {
    Cause selectedCause = Cause(causes[_causeid]);
    uint256 amount = selectedCause.contribute();
    individualDonations[msg.sender] += amount;
  }
}