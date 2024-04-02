// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0<0.9.0;


//1st candidate : 0xdD870fA1b7C4700F2BD7f44238821C26f7392148
//2nd candidate : 0x583031D1113aD414F02576BD6afaBfb302140225
//3rd candidate : 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB
//4th candidate : 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C



contract ballot_block{

    address public owner;
    bool private isVotingStarted;
    bool private isVotingEnded;
    uint256 private endTime;

    struct vote{
        address candidateAddress;
        uint256 timeStamp;
    }

    mapping(address=>vote) public votes;

    event StartingVote(address startedBy);
    event EndingVote(address endedBy);
    event AddVote(address indexed voter, address receiver, uint256 timeStamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor()
    {
        owner = msg.sender;
        isVotingStarted = false;
        isVotingEnded = false;
    }

    function start() external onlyOwner returns (bool) {
        require(!isVotingStarted, "Voting has already started");
        isVotingStarted = true;
        emit StartingVote(msg.sender);
        return true;
    }

    function end() external onlyOwner returns (bool) {
        require(isVotingStarted, "Voting has not started yet");
        require(!isVotingEnded, "Voting has already ended");
        isVotingEnded = true;
        isVotingStarted = false;
        emit EndingVote(msg.sender);
        return true;
    }

    function add(address receiver) external returns(bool) {
    require(isVotingStarted, "Voting has not started yet");
    require(!isVotingEnded, "Voting has already ended");
    require(votes[msg.sender].timeStamp == 0, "Already voted");
    votes[msg.sender] = vote(receiver, block.timestamp);
    emit AddVote(msg.sender, receiver, block.timestamp);
    return true;
    }

    function setEndTime(uint256 duration) external onlyOwner {
        require(!isVotingEnded, "Voting has already ended");
        endTime = block.timestamp + duration;
    }

    function autoEnd() external onlyOwner {
        require(isVotingStarted, "Voting has not started yet");
        require(!isVotingEnded, "Voting has already ended");
        require(block.timestamp >= endTime, "Voting end time has not reached");
        isVotingEnded = true;
        isVotingStarted = false;
        emit EndingVote(msg.sender);
    }
}
