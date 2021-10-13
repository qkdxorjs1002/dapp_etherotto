pragma solidity ^0.5.1;

import "./library/EtherottoLibrary.sol";
import "./model/EtherottoConfig.sol";
import "./model/EtherottoModel.sol";
import "./repository/ETR.sol";

contract Etherotto is Ownable, EtherottoConfig {

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
     * 계약 생성자
     */
    constructor (uint256 _tokenInitAmount) Ownable() public payable {
        require(uint256(msg.value / 1 ether) * TOKEN_VALUE == _tokenInitAmount);
        token = new ETR(_tokenInitAmount + (TOKEN_VALUE * 1), TOKEN_VALUE, TOKEN_DIVIDENDS_RATIO);
        token.transfer(address(this), _tokenInitAmount);
    }

    modifier register(address _address) {
        if (Object.isEmpty(address(userList[_address]))) {
            userList[_address] = new User(
                numberOfCabinets,
                0,
                0,
                0,
                uint256(now)
            );
            cabinetList[numberOfCabinets++] = new Cabinet(
                _address,
                0
            );
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
        buyTicket(generateRandomElectrons());
    }

    function buyTicketAuto(address _target) private register(_target) {
        buyTicket(_target, generateRandomElectrons());
    }

    /**
     * 수동 복권 구매
     */
    function buyTicket(uint8[] memory _electrons) public {
        buyTicket(msg.sender, _electrons);
    }
    
    function buyTicket(address _target, uint8[] memory _electrons) private register(_target) {
        for (uint8 idx = 0; idx < TICKET_ELECTRONS; idx++) {
            require(_electrons[idx] <= 45);
        }

        token.transfer(address(this), TICKET_PRICE);
        totalTokens += TICKET_PRICE;
        
        uint256 cabinetIndex = userList[_target].getCabinetIndex();

        Ticket ticket = new Ticket(uint256(now));
        ticket.setElectrons(_electrons);

        cabinetList[cabinetIndex].addTicket(ticket);
    }

    /**
     * 정기 결제 구독 가입
     */
    function subscribe(uint256 _month) public register(msg.sender) {
        require(_month >= 1);

        if (userList[msg.sender].getSubscribeSince() == 0) {
            userList[msg.sender].setSubscriberIndex(numberOfSubscribers++);
            userList[msg.sender].setSubscribeSince(uint256(now));
            userList[msg.sender].setSubscribeTo(uint256(now) + (SECONDS_OF_MONTH * _month));
            subscriberList[userList[msg.sender].getSubscriberIndex()] = msg.sender;
        } else {
            userList[msg.sender].setSubscribeTo(userList[msg.sender].getSubscribeTo() + (SECONDS_OF_MONTH * _month));
        }
    }

    /**
     * 정기 결제 구독 해제
     */
    function unsubscribe() public {
        unsubscribe(msg.sender);
    }
    
    function unsubscribe(address _address) private {
        require(!Object.isEmpty(address(userList[_address])));

        delete subscriberList[userList[_address].getSubscriberIndex()];
        
        User user = new User(
            userList[_address].getCabinetIndex(),
            0,
            0,
            0,
            userList[_address].getTimestamp()
        );
        
        userList[_address] = user;
        numberOfSubscribers--;
    }

    /**
     * 내 정보 조회
     */
    // function getMyInfo() public view returns(string memory) {
    //     require(userList[msg.sender].getTimestamp() > 0);

    //     return string(abi.encodePacked("{",
    //         "\"user\": ", userList[msg.sender].toJson(),
    //         ", ",
    //         "\"cabinet\": ", cabinetList[userList[msg.sender].getCabinetIndex()].toJson(),
    //     "}"));
    // }

    /**
     * 복권 추첨 (계약 소유자 제한)
     */
    function drawTickets() public onlyOwner {
        require(Date.getDayOfWeek(uint256(now)) == DAY_OF_DRAWING);

        uint8[] memory drawElectrons = generateRandomElectrons();
        uint256 totalTickets;
        address[][] memory winners;

        for (uint256 idx = 0; idx < numberOfCabinets; idx++) {
            address ownerAddress = cabinetList[idx].getOwnerAddress();
            uint256 numberOfTickets = cabinetList[idx].getNumberOfTickets();
            totalTickets += numberOfTickets;

            for (uint256 tdx = 0; tdx < numberOfTickets; tdx++) {
                uint8 result = drawTicket(cabinetList[idx].getTicketList()[tdx], drawElectrons);

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

        roundList[numberOfRounds] = new Round(
            totalTokens,
            totalTickets,
            drawerRewards
        );

        resetRound();
    }

    function drawTicket(Ticket _ticket, uint8[] memory _drawElectrons) private view returns(uint8) {
        uint8[] memory electrons = _ticket.getElectrons();

        uint8 matched;
        bool hasBonusNum = false;
        for (uint8 edx = 0; edx < TICKET_ELECTRONS; edx++) {
            for (uint ddx = 0; ddx < TICKET_ELECTRONS; ddx++) {
                if (electrons[edx] == _drawElectrons[ddx]) {
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
        require(Date.getDayOfWeek(now) == DAY_OF_PAYMENT);

        for (uint256 idx = 0; idx < numberOfSubscribers; idx++) {
            address userAddress = subscriberList[idx];

            if (userList[userAddress].getSubscribeTo() < now) { 
                unsubscribe(userAddress);
            } else {
                buyTicketAuto(userAddress);
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

    function resetRound() private {
        delete totalTokens;
        for (uint256 idx = 0; idx < numberOfCabinets; idx++) {
            cabinetList[idx].setNumberOfTickets(0x0);
            cabinetList[idx].delTicketList();
        }
        numberOfRounds++;
    }

}
