// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0<0.9.0;


//1st candidate : 0xdD870fA1b7C4700F2BD7f44238821C26f7392148
//2nd candidate : 0x583031D1113aD414F02576BD6afaBfb302140225
//3rd candidate : 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB
//4th candidate : 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C



contract ballot_block{

    bool isVotingStarted;
    bool isVotingEnded;
    address administrator;
    bool isTied;
    struct pair {
        bool voted;
        uint8 round;
    }
    struct vote{
        address candidateAddress;
        uint256 timeStamp;
    }
    mapping(address => uint8) votesForCandidates;
    mapping(address => pair) hasVoted;
    mapping(address => bool) validCandidates;
    uint8 currentVotingRound;
    uint8 winningVoteCount;
    address[] candidates;
    address winner;
    event startingVote(address startedby);
    event endingVote(address endedby);
    event AddVote(address indexed voter, address receiver);

    modifier onlyAfterVoteEnd() {
        require(isVotingEnded, "Voting has not ended yet");
        _;
    }

    modifier onlyChairperson() {
        require(msg.sender == administrator, "Only administrator can call this function");
        _;
    }
    modifier votingOpen() {
        require(isVotingStarted, "Voting is not started yet");
        _;
    }
    modifier votingNotStarted_OR_tied(){
        require(!isVotingStarted || isTied, "Voting is started already");
        _;
    }
    modifier notTied(){
        require(!isTied, "Voting is Ended up in Tie, Wait for the administrator to start the next round election...");
        _;
    }
    modifier votingNotClosed(){
        require(!isVotingEnded, "Voting is Closed");
        _;
    }
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender].voted || (hasVoted[msg.sender].round != currentVotingRound), "You have already voted");
        _;
    }
    modifier isValidCandidate(address candidate) {
        require(validCandidates[candidate], "Invalid candidate");
        _;
    }
    constructor()
    {
        administrator = msg.sender;
        isVotingStarted=false;
        isVotingEnded=false;
        isTied=false;
        currentVotingRound = 0;
        candidates.push(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        candidates.push(0x583031D1113aD414F02576BD6afaBfb302140225);
        candidates.push(0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB);
        candidates.push(0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C);

        validCandidates[0xdD870fA1b7C4700F2BD7f44238821C26f7392148] = true;
        validCandidates[0x583031D1113aD414F02576BD6afaBfb302140225] = true;
        validCandidates[0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB] = true;
        validCandidates[0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C] = true;

    }

    function Start() external onlyChairperson votingNotStarted_OR_tied returns (bool)
    {
        currentVotingRound++;
        winningVoteCount = 0;
        isVotingStarted = true;
        isVotingEnded = false;
        isTied = false;
        emit startingVote(msg.sender);
        return true;

    }

    function End() external onlyChairperson votingOpen votingNotClosed returns(bool)
    {
        isVotingEnded = true;
        isVotingStarted = false;
        emit endingVote(msg.sender);
        return true;
    }

    function Add(address candidate) external votingOpen votingNotClosed hasNotVoted isValidCandidate(candidate) {
        hasVoted[msg.sender].voted = true;
        hasVoted[msg.sender].round = currentVotingRound;
        votesForCandidates[candidate]++;
        emit AddVote(msg.sender, candidate);
        if (votesForCandidates[candidate] > winningVoteCount) {
            winningVoteCount = votesForCandidates[candidate];
            winner = candidate;
        } else if (votesForCandidates[candidate] == winningVoteCount) {
            winner = address(0);
        }
    }


    function result() external onlyChairperson onlyAfterVoteEnd{
        if (winner == address(0)){
            if (votesForCandidates[candidates[0]] != winningVoteCount){
                validCandidates[candidates[0]] = false;
            }
            else{
                votesForCandidates[candidates[0]] = 0;
            }
            if (votesForCandidates[candidates[1]] != winningVoteCount){
                validCandidates[candidates[1]] = false;
            }
            else{
                votesForCandidates[candidates[1]] = 0;
            }
            if (votesForCandidates[candidates[2]] != winningVoteCount){
                validCandidates[candidates[2]] = false;
            }
            else{
                votesForCandidates[candidates[2]] = 0;
            }
            if (votesForCandidates[candidates[3]] != winningVoteCount){
                validCandidates[candidates[3]] = false;
            }
            else{
                votesForCandidates[candidates[3]] = 0;
            }
            isTied = true;
            return;
        }
        isVotingStarted = false;
        return;
    }

    function getWinner() external view onlyAfterVoteEnd notTied returns (address){
        return winner;
    }


    


}