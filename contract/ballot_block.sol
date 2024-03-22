// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0<0.9.0;


//1st candidate : 0xdD870fA1b7C4700F2BD7f44238821C26f7392148
//2nd candidate : 0x583031D1113aD414F02576BD6afaBfb302140225
//3rd candidate : 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB
//4th candidate : 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C



contract ballot_block{

    bool isVotingStarted;
    bool isVotingEnded;
    address[] public candidates;
    mapping(address => bool) public validCandidate;
    mapping(address => bool) public voters;
    struct vote{
        address candidateAddress;
        uint256 timeStamp;
        uint256 voterAge;
    }

    mapping(address=>vote) public votes;

    event startingVote(address startedby);
    event endingingVote(address endedby);
    event AddVote(address indexed voter, address receiver, uint256 timeStamp);
    modifier onlyValidCandidate(address _candidate) {
        require(validCandidate[_candidate], "Invalid candidate");
        _;
    }

    modifier onlyAbove18(uint256 _age) {
        require(_age >= 18, "You must be 18 years or older to vote");
        _;
    }

    constructor()
    {
        isVotingStarted=false;
        isVotingEnded = false;
        candidates.push(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        candidates.push(0x583031D1113aD414F02576BD6afaBfb302140225);
        candidates.push(0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB);
        candidates.push(0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C);
        for (uint i = 0; i < candidates.length; i++) {
            validCandidate[candidates[i]] = true;
        }
    }

    function Start() external returns (bool)
    {
        //write your code here
    }

    function End() external returns(bool)
    {
        //write your code HERE
    }

    function Add(address _receiver,uint256 _age) external onlyValidCandidate(_receiver) onlyAbove18(_age) returns(bool)
    {
        // write your code here
        require(isVotingStarted, "Voting has not started yet");
        require(!isVotingEnded, "Voting has already ended");
        require(!voters[msg.sender], "You have already voted");
        votes[msg.sender] = vote(_receiver, block.timestamp, _age);
        voters[msg.sender] = true;
        emit AddVote(msg.sender, _receiver, block.timestamp);
        return true;
    }

    


}
