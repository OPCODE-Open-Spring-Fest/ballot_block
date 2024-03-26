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
    address[] candidates;
    mapping(address=>vote) public votes;
    mapping(address=>uint256) voteCount;
    address winner;
    event startingVote(address startedby);
    event endingVote(address endedby);
    event AddVote(address indexed voter, address receiver, uint256 timeStamp);
    event ReElecting(address[] winners);
    event WinnerDetermined(address winner);

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
    }

    function getWinner() external view returns (address FinalWinner) {
        require(isVotingStarted, "Voting has not started yet");
        require(isVotingEnded, "Voting has not ended yet");
        require(!isTied, "Voting has ended up in a tie, re-election required");
        return winner;
    }

    function determineWinner() internal {
        uint256 maxVotes = 0;
        uint256 tiedCandidatesCount = 0;
        address[] memory tiedCandidates;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (voteCount[candidates[i]] > maxVotes) {
                maxVotes = voteCount[candidates[i]];
                tiedCandidatesCount = 0;
                tiedCandidates[0] = candidates[i];
            } else if (voteCount[candidates[i]] == maxVotes) {
                tiedCandidates[tiedCandidatesCount] = candidates[i];
                tiedCandidatesCount++;
            }
        }
        if (tiedCandidatesCount > 1) {
            isTied = true; 
            delete candidates;
            for (uint256 i = 0; i < tiedCandidatesCount; i++) {
                candidates[i] = tiedCandidates[i];
            }
            emit ReElecting(candidates);
            isVotingStarted = false;
            isVotingEnded = false; 
            return;
        }
        winner = tiedCandidates[0];
        emit WinnerDetermined(tiedCandidates[0]);
        return;
    }
}
