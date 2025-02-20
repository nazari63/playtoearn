// Minor update: Comment added for GitHub contributions
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlayToEarnGame {
    address public owner;
    mapping(address => uint256) public playerScores;
    mapping(address => uint256) public playerRewards;
    
    uint256 public rewardThreshold = 100;
    uint256 public rewardAmount = 1 ether; // مقدار پاداش (در واحد wei)

    event ScoreUpdated(address indexed player, uint256 newScore);
    event RewardClaimed(address indexed player, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    function setRewardThreshold(uint256 _threshold) public onlyOwner {
        rewardThreshold = _threshold;
    }

    function setRewardAmount(uint256 _amount) public onlyOwner {
        rewardAmount = _amount;
    }

    function updateScore(address player, uint256 score) public onlyOwner {
        playerScores[player] += score;
        emit ScoreUpdated(player, playerScores[player]);

        // بررسی آیا بازیکن به حدنصاب امتیاز رسیده است
        if (playerScores[player] >= rewardThreshold) {
            playerRewards[player] += rewardAmount;
        }
    }

    function claimReward() public {
        uint256 reward = playerRewards[msg.sender];
        require(reward > 0, "No rewards available");
        require(address(this).balance >= reward, "Not enough balance in contract");

        playerRewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
    }

    function depositRewards() public payable onlyOwner {}

    function getPlayerScore(address player) public view returns (uint256) {
        return playerScores[player];
    }

    function getPlayerReward(address player) public view returns (uint256) {
        return playerRewards[player];
    }
}
