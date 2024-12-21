// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationalProjectIncentives {
    address public owner;
    uint256 public submissionReward;
    uint256 public totalSubmissions;

    mapping(address => bool) public hasSubmitted;
    mapping(address => string) public submissions;

    event ProjectSubmitted(address indexed submitter, string projectIdea);
    event RewardClaimed(address indexed submitter, uint256 amount);

    constructor(uint256 _reward) {
        owner = msg.sender;
        submissionReward = _reward;
        totalSubmissions = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier hasNotSubmitted() {
        require(!hasSubmitted[msg.sender], "You have already submitted a project idea.");
        _;
    }

    // Submit project idea
    function submitProject(string memory _projectIdea) external hasNotSubmitted {
        submissions[msg.sender] = _projectIdea;
        hasSubmitted[msg.sender] = true;
        totalSubmissions += 1;

        emit ProjectSubmitted(msg.sender, _projectIdea);
    }

    // Claim incentive for submitting a project idea
    function claimReward() external hasNotSubmitted {
        require(hasSubmitted[msg.sender], "You must submit a project idea first.");
        require(address(this).balance >= submissionReward, "Insufficient balance in the contract.");

        payable(msg.sender).transfer(submissionReward);

        emit RewardClaimed(msg.sender, submissionReward);
    }

    // Deposit funds into the contract to reward submitters
    function depositFunds() external payable onlyOwner {
        require(msg.value > 0, "You must send some ETH to fund the contract.");
    }

    // Change the submission reward
    function setSubmissionReward(uint256 _newReward) external onlyOwner {
        submissionReward = _newReward;
    }

    // Get contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
