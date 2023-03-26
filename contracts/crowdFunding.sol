// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract crowdFunding {
    uint256 public minContribution;
    uint256 public target;
    uint256 public deadline;
    address public manager;
    uint256 public raisedAmount;
    uint256 public noOfContributers;
    mapping(address => uint256) public contribution;

    modifier OnlyOwner() {
        require(msg.sender == manager, "Restricted function");
        _;
    }

    struct Request {
        string description;
        uint256 value;
        address payable recipient;
        bool votingComplete;
        uint256 votesCount;
        mapping(address => bool) voter;
    }

    mapping(uint256 => Request) public RequestList;
    uint256 public requestCount;

    constructor(uint256 _target, uint256 _deadline) {
        minContribution = 100 wei;
        target = _target;
        deadline = block.timestamp + _deadline;
        manager = msg.sender;
    }

    function sendEth() public payable {
        require(block.timestamp < deadline, "You are late !!");
        require(msg.value >= minContribution, "Not met minimum Contribution");
        if (contribution[msg.sender] == 0) {
            ++noOfContributers;
        }
        raisedAmount += msg.value;
        contribution[msg.sender] += msg.value;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function refund() public {
        require(block.timestamp > deadline, "Not eligible for refund right now");
        require(contribution[msg.sender] > 0, "You didn't contribute");
        address payable user = payable(msg.sender);
        user.transfer(contribution[msg.sender]);
        contribution[msg.sender] = 0;
    }

    function createRequest(
        string memory _description,
        uint256 _value,
        address payable _recipient
    ) public OnlyOwner {
        Request storage newRequest = RequestList[requestCount++];
        newRequest.recipient = _recipient;

        newRequest.description = _description;
        newRequest.value = _value;
    }

    function vote(uint256 _requestCount) public returns (uint256) {
        require(contribution[msg.sender] > 0, "You cant vote if you didn't contribute");
        Request storage thisRequest = RequestList[_requestCount];
        require(thisRequest.voter[msg.sender] == false, "Can be voted for only once");
        thisRequest.voter[msg.sender] = true;
        return thisRequest.votesCount++;
    }

    function Result(uint256 _requestCount) public OnlyOwner {
        Request storage thisRequest = RequestList[_requestCount];
        require(thisRequest.value >= raisedAmount, "Not enough balance");
        require(thisRequest.votingComplete == false, "Already done");
        require(thisRequest.votesCount > noOfContributers / 2, "Not enough votes");
        address payable user = payable(thisRequest.recipient);
        user.transfer(thisRequest.value);
        thisRequest.votingComplete = true;
    }

    function getFunder() public view returns (address) {
        return msg.sender;
    }
}
