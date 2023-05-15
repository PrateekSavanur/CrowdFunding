# CrowdFunding

## CrowdFunding Contract

This is a Solidity smart contract that enables the creation of a crowdfunding campaign on the Ethereum blockchain. The contract allows users to contribute to the campaign, and when the campaign deadline is reached, the manager of the campaign can make a request to withdraw the funds and specify a recipient address. The request can be approved by a majority vote from the campaign contributors.

### Contract Variables

- `minContribution` - the minimum amount that a contributor can donate to the campaign, set to 100 wei.
- `target` - the fundraising goal of the campaign, set by the contract creator.
- `deadline` - the deadline of the campaign, set by the contract creator.
- `manager` - the Ethereum address of the campaign manager, set by the contract creator.
- `raisedAmount` - the total amount of ether raised by the campaign.
- `noOfContributers` - the total number of contributors to the campaign.
- `contribution` - a mapping that maps a contributor's address to the amount of ether they have donated to the campaign.
- `requestCount` - the total number of requests made by the campaign manager.
- `RequestList` - a mapping that maps a request count to a `Request` struct.

### Contract Functions

- `sendEth()` - a payable function that allows a user to contribute to the campaign. The function checks if the campaign deadline has been reached and if the user has met the minimum contribution amount. If the user is a new contributor, the `noOfContributers` variable is incremented. The user's contribution is added to the `raisedAmount` variable, and their contribution amount is stored in the `contribution` mapping.
- `getContractBalance()` - a view function that returns the current balance of the contract in wei.
- `refund()` - a function that allows a user to request a refund of their contribution if the campaign deadline has passed and the campaign has not met its fundraising goal. The function checks if the user has contributed to the campaign and transfers the corresponding amount of ether back to the user's address.
- `createRequest()` - a function that allows the campaign manager to make a request to withdraw funds from the campaign and specify a recipient address. The function creates a new `Request` struct and adds it to the `RequestList` mapping.
- `vote()` - a function that allows a campaign contributor to vote on a request made by the campaign manager. The function checks if the user has contributed to the campaign and if they have not already voted on the request. If the checks pass, the user's address is added to the `voter` mapping for the request, and the `votesCount` variable for the request is incremented.
- `Result()` - a function that allows the campaign manager to finalize a request made by withdrawing funds from the campaign and transferring them to the recipient address. The function checks if the request value is less than or equal to the `raisedAmount` variable, if the voting for the request is complete, and if the request has received a majority vote from the contributors. If the checks pass, the request recipient address is paid the requested value, and the `votingComplete` variable for the request is set to true.
- `getFunder()` - a view function that returns the Ethereum address of the current user. 

### Contract Modifiers

- `OnlyOwner()` - a modifier that restricts the execution of a function to the campaign manager. The modifier checks if the user calling the function is the campaign manager. If the check fails, the function execution is halted.
