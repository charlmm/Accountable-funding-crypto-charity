// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CauseWallet {
    address payable public beneficiary;
    address private owner;
    uint256 public goalAmount;
    uint256 public currentAmount;
    uint256 public currentMilestone;
    uint256 public totalMilestones;

    mapping(uint8 => uint256) public milestoneFunds;

    event ContributionReceived(address indexed contributor, uint256 indexed milestone, uint256 amount);
    event MilestoneReached(uint256 indexed milestone, uint256 amount);

    constructor(address _owner, address payable _beneficiary, uint256 _goalAmount, uint256 _totalMilestones ) {
        owner = _owner;
        currentMilestone = 0;
        totalMilestones = _totalMilestones;
        goalAmount = _goalAmount;
        beneficiary = _beneficiary;
    }

    receive() external payable {
        require(currentAmount < goalAmount, "Current milestone target has been reached");
        uint256 amount = msg.value;
        currentAmount += amount;
    }

    function releaseFunds(uint8 currentmilestone, address verifier) public returns (bool ) {
        require(msg.sender == owner, "only the wallet owner can release funds");
        
        if(address(this).balance >= milestoneFunds[currentmilestone]) {
            uint256 funds = milestoneFunds[currentmilestone];
            (bool success,)  = beneficiary.call{ value: funds*99/100}("");
            require(success, "Funds was not successfully released");
            (bool sent,)  = verifier.call{ value: funds*1/100}("");
            require(sent, "Funds was not successfully released");
            currentAmount -= funds;
            return success;
        } else {
            (bool success,)  = beneficiary.call{ value: address(this).balance*99/100}("");
            require(success, "Funds was not successfully released");
            (bool sent,)  = beneficiary.call{ value: address(this).balance*1/100}("");
            require(sent, "Funds was not successfully released");
            currentAmount = 0;
            return success;
        }
    }
}