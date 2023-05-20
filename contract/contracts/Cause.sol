// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CauseWallet.sol";

contract Cause {
    string public name;
    string public description;
    address public owner;
    address payable public beneficiary;
    uint256 public goalAmount;
    uint256 public currentAmount;
    CauseWallet public wallet;
    Milestone[] public milestones;
    uint256 public currentMilestone;
    bool public isCampaignActive = true;

    mapping(address => uint256) public contributors;
    mapping(uint8 => address) public verifier;
    mapping(uint8 => bool) public milestoneAchieved;

    uint public milestoneVerificationRequest;

    event ContributionReceived(address indexed contributor, uint256 amount);
    event MilestoneCompleted(uint256 milestone);
    event AmountAchieved(uint256 amount);

    struct Milestone {
        uint8 number;
        string goal;
        uint256 amount;
        bool achieved;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor(string memory _name, string memory _description, uint256 _goalAmount, address payable _beneficiary, string[] memory _milestoneGoals, uint256[] memory _milestoneAmounts) {
        owner = msg.sender;
        name = _name;
        description = _description;
        goalAmount = _goalAmount;
        beneficiary = _beneficiary;
        milestones.push(Milestone({
            number: 0,
            goal: "Raise Funds",
            amount: _goalAmount,
            achieved: false
        }));

        for (uint8 i = 0; i < _milestoneGoals.length; i++) {
            milestones.push(Milestone({
                number: i+1,
                goal: _milestoneGoals[i],
                amount: _milestoneAmounts[i],
                achieved: false
            }));
        }

        wallet = new CauseWallet(address(this), beneficiary, goalAmount, milestones.length);
    }

    function contribute() public payable returns (uint256){
        require(isCampaignActive, "Campaign is no longer active.");
        require(msg.value > 0, "Contribution amount must be greater than zero.");
        require(wallet.currentAmount()  <= goalAmount, "Contribution amount exceeds the campaign goal.");
      
        (bool success,) = address(wallet).call{value: msg.value}("");
        require(success, "Your contribution was not successful");

        contributors[msg.sender] = msg.value;

        if(wallet.currentAmount()+msg.value >= goalAmount) {
            isCampaignActive = false;
            emit AmountAchieved(wallet.currentAmount());
        }

        
        emit ContributionReceived(msg.sender, msg.value);
        return msg.value;
    }

    function getTotalAmountRaised() public view returns (uint256) {
        return wallet.currentAmount();
    }

    function requestMilestoneCompleteVerification(uint8 milestone) external {
        require(msg.sender == owner);
        milestoneVerificationRequest = milestone;
    }

    function verifyMilestone(uint8 milestone) external {
        require(msg.sender != owner, "owners cant verify themselves");
        require(contributors[msg.sender] > 0, "You need to be a contributor");
        require(milestoneVerificationRequest == milestone, "cannot verify a different milestone");
        require(milestoneVerificationRequest != 1000, "Not milestone request was given for this cause");
        milestones[milestone].achieved = true;
        milestoneAchieved[milestone] = true;
        milestoneVerificationRequest == 1000;

        wallet.releaseFunds(milestone+1, msg.sender);
    }

    function getMilestone(uint _milestone) internal view returns (Milestone memory milestone){
        for (uint j = 0; j < milestones.length; j++) {
            if(_milestone == j){
                milestone =  milestones[j];
                return milestone;
            }
        }
    }

}