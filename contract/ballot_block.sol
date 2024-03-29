// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0<0.9.0;


//1st candidate : 0xdD870fA1b7C4700F2BD7f44238821C26f7392148
//2nd candidate : 0x583031D1113aD414F02576BD6afaBfb302140225
//3rd candidate : 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB
//4th candidate : 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C



contract ballot_block{
    bool isVotingStarted;
    bool isVotingEnded;
    bool isTied;
    struct vote{
        address candidateAddress;
        uint256 timeStamp;
    }

    mapping(address => uint) public votesForCandidates;
    mapping(address => bool) public hasVoted;

    address[4] private candidates = [
        0xdD870fA1b7C4700F2BD7f44238821C26f7392148,
        0x583031D1113aD414F02576BD6afaBfb302140225,
        0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB,
        0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
    ];

    event startingVote(address startedby);
    event endingVote(address endedby);
    event AddVote(address indexed voter, address receiver);

    modifier onlyAfterVoteEnd() {
        require(isVotingEnded, "Voting has not ended yet");
        _;
    }

    constructor()
    {
        isVotingStarted=false;
        isVotingEnded=false;
        isTied=false;
        candidates = [0xdD870fA1b7C4700F2BD7f44238821C26f7392148, 0x583031D1113aD414F02576BD6afaBfb302140225];
    }

    function Start() external returns (bool)
    {

        require(!isVotingStarted, "Voting has already started");
        isVotingStarted = true;
        emit startingVote(msg.sender);
        return true;

    }

    function End() external returns(bool)
    {
        //write your code here
        require(isVotingStarted, "Voting has not started yet");
        require(!isVotingEnded, "Voting has already ended");
        isVotingEnded = true;
        isVotingStarted = false;
        emit endingVote(msg.sender);
        return true;
    }

    function Add(address receiver) external returns(bool)
    {
        // write your code here
        require(isVotingStarted, "Voting has not started");
        require(!isVotingEnded, "Voting has already ended");
        require(!hasVoted[msg.sender], "You have already voted");
        require(isValidCandidate(receiver), "Not a valid candidate");

        votesForCandidates[receiver] += 1;
        hasVoted[msg.sender] = true;
        emit AddVote(msg.sender, receiver);
        return true;
    }

    function result() external view onlyAfterVoteEnd returns (address winningCandidate, uint highestVotes) {
        highestVotes = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (votesForCandidates[candidates[i]] > highestVotes) {
                winningCandidate = candidates[i];
                highestVotes = votesForCandidates[candidates[i]];
            }
        }
    }

    function isValidCandidate(address candidate) internal view returns (bool) {
        for(uint i = 0; i < candidates.length; i++) {
            if (candidates[i] == candidate) {
                return true;
            }
        }
        return false;
    }

    


}
