// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    string public message;
    address public owner;

    constructor(string memory _message) {
        message = _message;
        owner = msg.sender;
    }

    function updateMessage(string memory _newMessage) public {
        require(msg.sender == owner, "Only owner can update the message");
        message = _newMessage;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
}

