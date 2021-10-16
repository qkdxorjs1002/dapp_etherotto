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

    function delRewards() public {
        delete rewards;
    }
}

/**
 * 유저
 */
contract User {

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
            "\"since\": ", Object.uint2str(subscribeSince), ", ",
            "\"to\": ", Object.uint2str(subscribeTo), ", ",
            "\"timestamp\": ", Object.uint2str(timestamp),
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

    function addTicket(Ticket _ticket) public {
        numberOfTickets++;
        ticketList.push(_ticket);
    }

    function delTicketList() public {
        delete ticketList;
    }

    function toJson() public view returns(string memory) {
        if (ticketList.length == 0) {
            return "{}";
        }

        string memory jsonArray = "[";
    
        for (uint8 idx = 0; idx < ticketList.length; idx++) {
            jsonArray = string(abi.encodePacked(jsonArray, ticketList[idx].toJson()));

            if (idx < ticketList.length - 1) {
                jsonArray = string(abi.encodePacked(jsonArray, ", "));
            }
        }

        jsonArray = string(abi.encodePacked(jsonArray, "]"));

        return string(abi.encodePacked("{",
            "\"tickets\": ", jsonArray,
        "}"));
    }
}

/**
 * 복권
 */
contract Ticket is EtherottoConfig, JsonConvertable {

    uint256 private timestamp;

    uint8[TICKET_ELECTRONS] private electrons;

    constructor (uint256 _timestamp) public {
        timestamp = _timestamp;
    }
    
    function getTimestamp() public view returns(uint256) {
        return timestamp;
    }

    function setTimestamp(uint256 _timestamp) public {
        timestamp = _timestamp;
    }
    
    function getElectrons() public view returns(uint8[TICKET_ELECTRONS] memory) {
        return electrons;
    }

    function setElectrons(uint8[TICKET_ELECTRONS] memory _electrons) public {
        electrons = _electrons;
    }

    function toJson() public view returns(string memory) {
        if (electrons.length == 0) {
            return "[]";
        }

        string memory jsonArray = "[";
    
        for (uint8 idx = 0; idx < electrons.length; idx++) {
            jsonArray = string(abi.encodePacked(jsonArray, Object.uint2str(electrons[idx])));
            if (idx < electrons.length - 1) {
                jsonArray = string(abi.encodePacked(jsonArray, ", "));
            }
        }

        jsonArray = string(abi.encodePacked(jsonArray, "]"));

        return string(abi.encodePacked("{",
            "\"timestamp\": ", Object.uint2str(timestamp), ", ",
            "\"electrons\": ", jsonArray,
        "}"));
    }
}
