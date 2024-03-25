// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0<0.9.0;


//1st candidate : 0xdD870fA1b7C4700F2BD7f44238821C26f7392148
//2nd candidate : 0x583031D1113aD414F02576BD6afaBfb302140225
//3rd candidate : 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB
//4th candidate : 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C



contract ballot_block{

    bool isVotingStarted;
    bool public isVotingEnded;
    struct vote{
        address candidateAddress;
        uint256 timeStamp;
        bool isEighteenOrOlder;
    }

    mapping(address=>vote) public votes;

    address[4] public candidates = [
        0xdD870fA1b7C4700F2BD7f44238821C26f7392148,
        0x583031D1113aD414F02576BD6afaBfb302140225,
        0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB,
        0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
    ];

    event startingVote(address startedby);
    event endingVote(address endedby);
    event AddVote(address indexed voter, address receiver, uint256 timeStamp);

    modifier onlyValidCandidate(address _candidate) {
        bool isValidCandidate = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i] == _candidate) {
                isValidCandidate = true;
                break;
            }
        }
        require(isValidCandidate, "Invalid candidate.");
        _;
    }

    constructor()
    {
        isVotingStarted=false;
        isVotingEnded = false;
    }

    function Start() external returns (bool)
    {
        //write your code here
        require(!isVotingStarted, "Voting has already started.");
        isVotingStarted = true;
        emit startingVote(msg.sender);
        return true;
    }

    function End() external returns(bool)
    {
        //write your code here
        require(isVotingStarted, "Voting has not started yet.");
        require(!isVotingEnded, "Voting has already ended.");
        isVotingEnded = true;
        emit endingVote(msg.sender);
        return true;
    }

    function Add(address _receiver, bool _isEighteenOrOlder) external onlyValidCandidate(_receiver) returns (bool)
    {
        // write your code here
        require(isVotingStarted, "Voting has not started yet.");
        require(!isVotingEnded, "Voting has already ended.");
        require(!votes[msg.sender].isEighteenOrOlder, "You have already voted.");
        
        votes[msg.sender] = vote(_receiver, block.timestamp, _isEighteenOrOlder);
        emit AddVote(msg.sender, _receiver, block.timestamp);
        return true;
    }

    


}
