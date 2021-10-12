pragma solidity ^0.5.1;

import "./token/ETR.sol";

contract Etherotto is Ownable {
    
    /** 
     * 토큰 기준 가치
     * 1000 : 1ETH = 1000ETR
     */
    uint16 public constant TOKEN_VALUE = 1000;

    /** 
     * 토큰 배당금 비율
     * 100: 10%
     */
    uint16 public constant TOKEN_DIVIDENDS_RATIO = 100;

    /** 
     * 복권 당첨금 비율
     */
    uint32 constant TOKEN_DRAWER_REWARD_RATIO = 80;

    /** 
     * 복권 가격
     * 100: 100토큰
     */
    uint16 constant TICKET_PRICE = 10;

    /** 
     * 복권 당첨 번호 수
     * 1~45 번호 6개 + 보너스 1개(고정/필수)
     */
    uint8 constant TICKET_ELECTRONS = 7;

    /** 
     * 복권 1등 당첨금 비율
     */
    uint32 constant DRAWER_1REWARD_RATIO = 70;
    
    /** 
     * 복권 2등 당첨금 비율
     */
    uint32 constant DRAWER_2REWARD_RATIO = 15;

    /** 
     * 복권 3등 당첨금 비율
     */
    uint32 constant DRAWER_3REWARD_RATIO = 15;

    /** 
     * 복권 4등 당첨금
     */
    uint32 constant DRAWER_4REWARD_TOKEN = 500;

    /** 
     * 복권 5등 당첨금
     */
    uint32 constant DRAWER_5REWARD_TOKEN = 50;

    /**
     * 복권 추첨 요일
     * 일요일 시작으로 토요일까지 0~6
     * 6: 토요일
     */
    uint8 constant DAY_OF_DRAWING = 6;

    /**
     * 복권 정기 결제 요일
     * 일요일 시작으로 토요일까지 0~6
     * 1: 월요일
     */
    uint8 constant DAY_OF_PAYMENT = 1;

    /**
     * 한 달을 초로 환산
     */
    uint32 constant SECONDS_OF_MONTH = 2629746;

    /**
     * 한 주를 초로 환산
     */
    uint32 constant SECONDS_OF_WEEK = 604800;

    /**
     * 하루를 초로 환산
     */
    uint32 constant SECONDS_OF_DAY = 86400;

    /**
     * Etherotto Token
     */
    ETR private token;

    /**
     * 복권 회차
     */
    uint256 private numberOfRounds;

    /**
     * 구독자 수
     */
    uint256 private numberOfSubscribers;

    /**
     * 캐비넷 수
     */
    uint256 private numberOfCabinets;

    /**
     * 해당 회차 총 토큰
     */
    uint256 private totalTokens;

    /**
     * 유저 목록
     */
    mapping(uint256 => Round) public roundList;

    /**
     * 유저 목록
     */
    mapping(address => User) public userList;

    /**
     * 캐비닛 목록
     */
    mapping(uint256 => Cabinet) public cabinetList;
    
    /**
     * 정기 결제 구독자 목록
     */
    mapping(uint256 => address) public subscriberList;

    /**
     * 이벤트
     */
    event BuyTicket(address indexed who);
    event Subscribe(address indexed who, uint256 since, uint256 to);
    event Unsubscribe(address indexed who, uint256 since);
    event DrawTicket(uint256 timestamp);

    /**
     * 회차 구조체
     */
    struct Round {

        uint256 totalTokens;
        uint256 totalTickets;
        uint256[5] rewards;
        
    }

    /**
     * 유저 구조체
     */
    struct User {

        uint256 cabinetIndex;
        uint256 subscriberIndex;
        uint256 subscribeSince;
        uint256 subscribeTo;
        uint256 timestamp;

    }

    /**
     * 캐비닛 구조체
     */
    struct Cabinet {

        address ownerAddress;
        uint256 numberOfTickets;

        mapping(uint256 => Ticket) ticketList;

    }

    /**
     * 복권 구조체
     */
    struct Ticket {

        uint256 timestamp;

        mapping(uint8 => uint8) electronList;
        
    }

    /**
     * 계약 생성자
     */
    constructor (uint256 _tokenInitAmount) Ownable() public payable {
        require((msg.value * TOKEN_VALUE) == _tokenInitAmount);
        token = new ETR(_tokenInitAmount, TOKEN_VALUE, TOKEN_DIVIDENDS_RATIO);
    }

    modifier register() {
        if (userList[msg.sender].timestamp == 0) {
            userList[msg.sender] = User({
                cabinetIndex: numberOfCabinets++,
                subscriberIndex: 0,
                subscribeSince: 0,
                subscribeTo: 0,
                timestamp: now
            });
            cabinetList[userList[msg.sender].cabinetIndex].ownerAddress = msg.sender;
        }
        _;
    }

    /**
     * Fallback 메서드
     */
    function () external payable {
        revert();
    }

    /**
     * 자동 복권 구매
     */
    function buyTicketAuto() public {

    }

    /**
     * 복권 구매
     */
    function buyTicket() public {
        
    }

    /**
     * 정기 결제 구독 가입
     */
    function subscribe(uint256 _month) public register {
        require(_month >= 1);

        if (userList[msg.sender].subscribeSince == 0) {
            userList[msg.sender].subscriberIndex = numberOfSubscribers++;
            userList[msg.sender].subscribeSince = now;
            userList[msg.sender].subscribeTo = now + (SECONDS_OF_MONTH * _month);
            subscriberList[userList[msg.sender].subscriberIndex] = msg.sender;
        } else {
            userList[msg.sender].subscribeTo += (SECONDS_OF_MONTH * _month);
        }
    }

    /**
     * 정기 결제 구독 해제
     */
    function unsubscribe() public {
        unsubscribe(msg.sender);
    }
    
    function unsubscribe(address _address) private {
        require(userList[_address].subscribeSince > 0);

        delete subscriberList[userList[_address].subscriberIndex];
        delete userList[_address].subscriberIndex;
        delete userList[_address].subscribeSince;
        delete userList[_address].subscribeTo;
        numberOfSubscribers--;
    }

    /**
     * 내 정보 조회
     */
    function getMyInfo() public view returns(string memory) {
        require(userList[msg.sender].timestamp > 0);

        return (string(abi.encodePacked(
            userToJson(userList[msg.sender]),
            ", ",
            cabinetToJson(cabinetList[userList[msg.sender].cabinetIndex])
        )));
    }

    /**
     * 복권 추첨 (계약 소유자 제한)
     */
    function drawTickets() public onlyOwner {
        require(getDayOfWeek(now) == DAY_OF_DRAWING);

        uint8[] memory drawElectrons = generateRandomElectrons();
        uint256 totalTickets;
        address[][] memory winners;

        for (uint256 idx = 0; idx < numberOfCabinets; idx++) {
            address ownerAddress = cabinetList[idx].ownerAddress;
            uint256 numberOfTickets = cabinetList[idx].numberOfTickets;
            totalTickets += numberOfTickets;

            for (uint256 tdx = 0; tdx < numberOfTickets; tdx++) {
                uint8 result = drawTicket(cabinetList[idx].ticketList[tdx], drawElectrons);

                if (result != 0) {
                    uint8 target = result - 1;
                    winners[target][winners[target].length] = ownerAddress;
                }
            }
        }

        uint256 drawerReward = totalTokens * (TOKEN_DRAWER_REWARD_RATIO / 10);
        uint256 drawer5thReward = DRAWER_5REWARD_TOKEN * winners[4].length;
        uint256 drawer4thReward = DRAWER_4REWARD_TOKEN * winners[3].length;
        drawerReward -= drawer5thReward + drawer4thReward;
        uint256 drawer3rdReward = drawerReward * (DRAWER_3REWARD_RATIO / 10);
        uint256 drawer2ndReward = drawerReward * (DRAWER_2REWARD_RATIO / 10);
        uint256 drawer1stReward = drawerReward * (DRAWER_1REWARD_RATIO / 10);

        uint256[5] memory drawerRewards = [
            drawer1stReward, drawer2ndReward, 
            drawer3rdReward, drawer4thReward, drawer5thReward
        ];

        for (uint256 idx = 0; idx < winners.length; idx++) {
            address[] memory targets = winners[idx];
            
            for (uint256 tdx = 0; tdx < targets.length; tdx++) {
                token.transferFrom(address(this), targets[tdx], drawerRewards[idx]);
            }
        }

        roundList[numberOfRounds++] = Round({
            totalTokens: totalTokens,
            totalTickets: totalTickets,
            rewards: drawerRewards
        });

        delete totalTokens;
    }

    function drawTicket(Ticket storage _ticket, uint8[] memory _drawElectrons) private view returns(uint8) {
        mapping(uint8 => uint8) storage electronList = _ticket.electronList;

        uint8 matched;
        bool hasBonusNum = false;
        for (uint8 edx = 0; edx < TICKET_ELECTRONS; edx++) {
            for (uint ddx = 0; ddx < TICKET_ELECTRONS; ddx++) {
                if (electronList[edx] == _drawElectrons[ddx]) {
                    if (ddx == TICKET_ELECTRONS) {
                        hasBonusNum == true;
                    }
                    matched++;
                    break;
                }
            }
        }

        if (matched == 3 && !hasBonusNum) {
            // 5등
            return 5;
        } else if (matched == 4 && !hasBonusNum) {
            // 4등
            return 4;
        } else if (matched == 5 && !hasBonusNum) {
            // 3등   
            return 3;
        } else if (matched == 6 && hasBonusNum) {
            // 2등
            return 2;
        } else if (matched >= 6) {
            // 1등
            return 1;
        }

        return 0;
    }
    
    /**
     * 복권 정기 결제 (계약 소유자 제한)
     */
    function paySubscribe() public onlyOwner {
        require(getDayOfWeek(now) == DAY_OF_PAYMENT);

        for (uint256 idx = 0; idx < numberOfSubscribers; idx++) {
            address userAddress = subscriberList[idx];

            if (userList[userAddress].subscribeTo < now) { 
                unsubscribe(userAddress);
            } else {
                // TODO: unsubscribe 처럼 오버로딩해서 address 지정 가능하도록
                buyTicketAuto();
            }
        }
    }

    function generateRandomElectrons() private view returns(uint8[] memory) {
        uint8[] memory electrons;

        for (uint8 idx = 0; idx < TICKET_ELECTRONS; idx++) {
            bool isDup = false;
            while (isDup) {
                electrons[idx] = generateRandomElectron();
                for (uint8 tdx = 0; tdx < idx; tdx++) {
                    if (electrons[idx] == electrons[tdx]) {
                        isDup = true;
                        break;
                    }
                }
            }
        }
        return electrons;
    }

    function generateRandomElectron() private view returns(uint8) {
        return uint8((uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender))) % 45) + 1);
    }

    function getDayOfWeek(uint256 _timestamp) private pure returns(uint256) {
        return (uint(_timestamp / SECONDS_OF_DAY) + 4) % 7;
    }

    function userToJson(User storage _target) private view returns(string memory) {
        return string(abi.encodePacked("{",
            "\"cabIndex\": ", _target.cabinetIndex, ", ",
            "\"subIndex\": ", _target.subscriberIndex, ", ",
            "\"since\": ", _target.subscribeSince, ", ",
            "\"to\": ", _target.subscribeTo,
            "\"timestamp\": ", _target.timestamp,
        "}"));
    }
    
    function cabinetToJson(Cabinet storage _target) private view returns(string memory) {
        string memory jsonArray = "[";
    
        for (uint8 idx = 0; idx < _target.numberOfTickets; idx++) {
            jsonArray = string(abi.encodePacked(jsonArray, ticketToJson(_target.ticketList[idx])));

            if (idx < TICKET_ELECTRONS - 1) {
                jsonArray = string(abi.encodePacked(jsonArray, ", "));
            }
        }

        jsonArray = string(abi.encodePacked(jsonArray, "]"));

        return string(abi.encodePacked("{",
            "\"ownerAddress\": ", _target.ownerAddress, ", ",
            "\"numOfTickets\": ", _target.numberOfTickets, ", ",
            "\"tickets\": ", jsonArray, ", ",
        "}"));
    }
    
    function ticketToJson(Ticket storage _target) private view returns(string memory) {
        string memory jsonArray = "[";
    
        for (uint8 idx = 0; idx < TICKET_ELECTRONS; idx++) {
            jsonArray = string(abi.encodePacked(jsonArray, _target.electronList[idx]));
            if (idx < TICKET_ELECTRONS - 1) {
                jsonArray = string(abi.encodePacked(jsonArray, ", "));
            }
        }

        jsonArray = string(abi.encodePacked(jsonArray, "]"));

        return string(abi.encodePacked("{",
            "\"timestamp\": ", _target.timestamp, ", ",
            "\"electrons\": ", jsonArray, ", ",
        "}"));
    }

}
