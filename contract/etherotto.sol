pragma solidity ^0.5.1;

contract Etherotto {

    /**
     * 유저 구조체
     */
    struct User {

        uint256 tokenBalance;
        uint256 subscribeSince;
        uint256 subscribeTo;

    }

    /**
     * 캐비닛 구조체
     */
    struct Cabinet {

        address ownerAddress;
        uint256 numberOfTickets;

        Ticket[] ticketList;

    }

    /**
     * 복권 구조체
     */
    struct Ticket {

        uint256 timestamp;
        
        uint8[] electronList;
        
    }

    /** 
     * 복권 가격
     * 100: 100토큰
     */
    uint16 constant TICKET_PRICE = 100;

    /** 
     * 복권 당첨 번호 수
     * 번호 6개 + 보너스 1개(고정/필수)
     */
    uint8 constant TICKET_ELECTRONS = 7;

    /**
     * 복권 추첨 요일
     * 일요일 시작으로 토요일까지 0~6
     * 6: 토요일
     */
    uint8 constant DAY_OF_DRAWING = 6;

    /** 
     * 토큰 배당금 비율
     * 100: 10%
     */
    uint16 constant TOKEN_DIVIDENDS_RATIO = 100;

    /**
     * 계약 토큰 잔액
     */
    uint256 tokenBalance;

    /**
     * 유저 목록
     */
    mapping(address => User) public userList;

    /**
     * 캐비닛 목록
     */
    mapping(address => Cabinet) public cabinetList;

    event ExchangeTo(address indexed from, address indexed to, uint256 amount, string symbol);
    event BuyTicket(address indexed who);
    event Subscribe(address indexed who, uint256 since, uint256 to);
    event Unsubscribe(address indexed who, uint256 since);
    event DrawTicket(uint256 timestamp);

    /**
     * 계약 소유자 함수 제한자
     */
    modifier onlyOwner {
        if (msg.sender != owner)
            revert();
        _;
    }

    /**
     * ETH를 ETR 토큰으로 환전
     */
    function exchangeToETR(uint256 _amount) public payable {
        
    }

    /**
     * ETR 토큰을 ETH으로 환전
     */
    function exchangeToETH(uint256 _amount) public {
        
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
        
    }

    /**
     * 정기 결제 구독 해제
     */
    function unsubscribe() public {

    }

    /**
     * 내 정보 조회
     */
    function getMyInfo() public returns(User user, Cabinet cabinet) {

    }

    /**
     * 복권 추첨 (계약 소유자 제한)
     */
    function drawTickets() public onlyOwner {

    }

}