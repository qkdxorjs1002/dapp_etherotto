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
     * 복권 가격
     * 100: 100토큰
     */
    uint16 constant TICKET_PRICE = 100;

    /** 
     * 복권 당첨 번호 수
     * 1~45 번호 6개 + 보너스 1개(고정/필수)
     */
    uint8 constant TICKET_ELECTRONS = 7;

    /**
     * 복권 추첨 요일
     * 일요일 시작으로 토요일까지 0~6
     * 6: 토요일
     */
    uint8 constant DAY_OF_DRAWING = 6;

    /**
     * 한 달을 초로 환산
     */
    uint32 constant SECONDS_OF_MONTH = 2629746;

    /**
     * Etherotto Token
     */
    ETR private token;

    /**
     * 구독자 수
     */
    uint256 private numberOfSubscribers;

    /**
     * 유저 목록
     */
    mapping(address => User) public userList;

    /**
     * 캐비닛 목록
     */
    mapping(address => Cabinet) public cabinetList;

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
     * 유저 구조체
     */
    struct User {

        uint256 subscriberIndex;
        uint256 subscribeSince;
        uint256 subscribeTo;

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
    function subscribe(uint256 month) public {
        require(month >= 1);

        if (userList[msg.sender].subscribeSince == 0) {
            userList[msg.sender] = User({
                subscriberIndex: ++numberOfSubscribers,
                subscribeSince: now,
                subscribeTo: now + (SECONDS_OF_MONTH * month)
            });
            subscriberList[userList[msg.sender].subscriberIndex] = msg.sender;
        } else {
            userList[msg.sender].subscribeTo += (SECONDS_OF_MONTH * month);
        }
    }

    /**
     * 정기 결제 구독 해제
     */
    function unsubscribe() public {
        delete subscriberList[userList[msg.sender].subscriberIndex];
        delete userList[msg.sender];
        numberOfSubscribers--;
    }

    /**
     * 내 정보 조회
     */
    function getMyInfo() public returns(string memory user, string memory cabinet) {
        //return (string(abi.encode(userList[msg.sender])), cabinetList[msg.sender]);
    }

    /**
     * 복권 추첨 (계약 소유자 제한)
     */
    function drawTickets() public onlyOwner {

    }

    function generateRandomElectron() private view returns(uint) {
        return (uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender))) % 45) + 1;
    }

}
