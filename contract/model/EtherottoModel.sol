pragma solidity ^0.5.1;

import "./EtherottoConfig.sol";
import "../library/EtherottoLibrary.sol";

interface JsonConvertable {
    function toJson() external view returns(string memory);
}

/**
 * 회차
 */
contract Round {

    uint256 totalTokens;
    uint256 totalTickets;
    uint256[5] rewards;

    constructor (uint256 _totalTokens, uint256 _totalTickets, uint256[5] memory _rewards) public {
        totalTokens = _totalTokens;
        totalTickets = _totalTickets;
        rewards = _rewards;
    }
    
    function getTotalTokens() public view returns(uint256) {
        return totalTokens;
    }

    function setTotalTokens(uint256 _totalTokens) public {
        totalTokens = _totalTokens;
    }
    
    function getTotalTickets() public view returns(uint256) {
        return totalTickets;
    }

    function setTotalTickets(uint256 _totalTickets) public {
        totalTickets = _totalTickets;
    }
    
    function getRewards() public view returns(uint256[5] memory) {
        return rewards;
    }

    function setRewards(uint256[5] memory _rewards) public {
        rewards = _rewards;
    }
}

/**
 * 유저
 */
contract User is JsonConvertable {

    uint256 private cabinetIndex;
    uint256 private subscriberIndex;
    uint256 private subscribeSince;
    uint256 private subscribeTo;
    uint256 private timestamp;

    constructor (uint256 _cabinetIndex, uint256 _subscriberIndex, uint256 _subscribeSince, uint256 _subscribeTo, uint256 _timestamp) public {
        cabinetIndex = _cabinetIndex;
        subscriberIndex = _subscriberIndex;
        subscribeSince = _subscribeSince;
        subscribeTo = _subscribeTo;
        timestamp = _timestamp;
    }
    
    function getCabinetIndex() public view returns(uint256) {
        return cabinetIndex;
    }

    function setCabinetIndex(uint256 _cabinetIndex) public {
        cabinetIndex = _cabinetIndex;
    }
    
    function getSubscriberIndex() public view returns(uint256) {
        return subscriberIndex;
    }

    function setSubscriberIndex(uint256 _subscriberIndex) public {
        subscriberIndex = _subscriberIndex;
    }
    
    function getSubscribeSince() public view returns(uint256) {
        return subscribeSince;
    }

    function setSubscribeSince(uint256 _subscribeSince) public {
        subscribeSince = _subscribeSince;
    }
    
    function getSubscribeTo() public view returns(uint256) {
        return subscribeTo;
    }

    function setSubscribeTo(uint256 _subscribeTo) public {
        subscribeTo = _subscribeTo;
    }
    
    function getTimestamp() public view returns(uint256) {
        return timestamp;
    }

    function setTimestamp(uint256 _timestamp) public {
        timestamp = _timestamp;
    }

    function toJson() public view returns(string memory) {
        return string(abi.encodePacked("{",
            "\"cabIndex\": ", cabinetIndex, ", ",
            "\"subIndex\": ", subscriberIndex, ", ",
            "\"since\": ", subscribeSince, ", ",
            "\"to\": ", subscribeTo,
            "\"timestamp\": ", timestamp,
        "}"));
    }
}

/**
 * 캐비닛
 */
contract Cabinet is EtherottoConfig, JsonConvertable {
    
    address private ownerAddress;
    uint256 private numberOfTickets;

    Ticket[] public ticketList;

    constructor (address _ownerAddress, uint256 _numberOfTickets) public {
        ownerAddress = _ownerAddress;
        numberOfTickets = _numberOfTickets;
    }
    
    function getOwnerAddress() public view returns(address) {
        return ownerAddress;
    }

    function setOwnerAddress(address _ownerAddress) public {
        ownerAddress = _ownerAddress;
    }
    
    function getNumberOfTickets() public view returns(uint256) {
        return numberOfTickets;
    }

    function setNumberOfTickets(uint256 _numberOfTickets) public {
        numberOfTickets = _numberOfTickets;
    }
    
    function getTicketList() public view returns(Ticket[] memory) {
        return ticketList;
    }

    function setTicketList(Ticket[] memory _ticketList) public {
        ticketList = _ticketList;
    }

    function toJson() public view returns(string memory) {
        if (ticketList.length == 0) {
            return "";
        }

        string memory jsonArray = "[";
    
        for (uint8 idx = 0; idx < numberOfTickets; idx++) {
            jsonArray = string(abi.encodePacked(jsonArray, ticketList[idx].toJson()));

            if (idx < TICKET_ELECTRONS - 1) {
                jsonArray = string(abi.encodePacked(jsonArray, ", "));
            }
        }

        jsonArray = string(abi.encodePacked(jsonArray, "]"));

        return string(abi.encodePacked("{",
            "\"ownerAddress\": ", ownerAddress, ", ",
            "\"numOfTickets\": ", numberOfTickets, ", ",
            "\"tickets\": ", jsonArray, ", ",
        "}"));
    }
}

/**
 * 복권
 */
contract Ticket is EtherottoConfig, JsonConvertable {

    uint256 private timestamp;

    uint8[] private electrons;

    constructor (uint256 _timestamp) public {
        timestamp = _timestamp;
    }
    
    function getTimestamp() public view returns(uint256) {
        return timestamp;
    }

    function setTimestamp(uint256 _timestamp) public {
        timestamp = _timestamp;
    }
    
    function getElectrons() public view returns(uint8[] memory) {
        return electrons;
    }

    function setElectrons(uint8[] memory _electrons) public {
        electrons = _electrons;
    }

    function toJson() public view returns(string memory) {
        if (electrons.length == 0) {
            return "";
        }

        string memory jsonArray = "[";
    
        for (uint8 idx = 0; idx < TICKET_ELECTRONS; idx++) {
            jsonArray = string(abi.encodePacked(jsonArray, electrons[idx]));
            if (idx < TICKET_ELECTRONS - 1) {
                jsonArray = string(abi.encodePacked(jsonArray, ", "));
            }
        }

        jsonArray = string(abi.encodePacked(jsonArray, "]"));

        return string(abi.encodePacked("{",
            "\"timestamp\": ", timestamp, ", ",
            "\"electrons\": ", jsonArray, ", ",
        "}"));
    }
}
