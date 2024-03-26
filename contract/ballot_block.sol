// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0<0.9.0;


//1st candidate : 0xdD870fA1b7C4700F2BD7f44238821C26f7392148
//2nd candidate : 0x583031D1113aD414F02576BD6afaBfb302140225
//3rd candidate : 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB
//4th candidate : 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C



contract ballot_block{

    bool isVotingStarted;
    address public owner;
    struct vote{
        address candidateAddress;
        uint256 timeStamp;
    }

    mapping(address=>vote) public votes;

    event startingVote(address startedby);
    event endingVote(address endedby);
    event AddVote(address indexed voter, address receiver, uint256 timeStamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier whenVotingActive() {
        require(isVotingStarted, "Voting has not started yet");
        _;
    }

    modifier whenVotingNotActive() {
        require(!isVotingStarted, "Voting is already active");
        _;
    }

    constructor()
    {
        owner=msg.sender;
        isVotingStarted=false;
    }

    function Start() external onlyOwner whenVotingNotActive returns (bool)
    {
        //write your code here
        isVotingStarted = true;
        emit startingVote(msg.sender);
        return true;
    }

    function End() external onlyOwner whenVotingActive returns(bool)
    {
        //write your code here
        isVotingStarted = false;
        emit endingVote(msg.sender);
        return true;
    }

    function Add(address receiver) external whenVotingActive returns(bool)
    {
        // write your code here
        require(votes[msg.sender].candidateAddress == address(0), "You have already voted");
        votes[msg.sender] = vote(receiver, block.timestamp);
        emit AddVote(msg.sender, receiver, block.timestamp);
        return true;
    }

    function checkMyVote() external view returns (address candidateAddress, uint256 timeStamp) {
        require(votes[msg.sender].candidateAddress != address(0), "You have not voted yet");
        return (votes[msg.sender].candidateAddress, votes[msg.sender].timeStamp);
    }

    


}
