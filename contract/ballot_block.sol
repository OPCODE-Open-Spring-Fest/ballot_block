// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0<0.9.0;

contract ballot_block{

    bool isVotingStarted;
    struct vote{
        address candidateAddress;
        uint256 timeStamp;
    }

    mapping(address=>vote) public votes;

    event startingVote(address startedby);
    event endingingVote(address endedby);
    event AddVote(address indexed voter, address receiver, uint256 timeStamp);

    constructor()
    {
        isVotingStarted=false;
    }

    function Start() external returns (bool)
    {
        //write your code here
    }

    function End() external returns(bool)
    {
        //write your code here
    }

    function Add(address receiver) external returns(bool)
    {
        // write your code here
    }

    


}
