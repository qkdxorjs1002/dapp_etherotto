pragma solidity ^0.5.1;

contract EtherottoConfig {
    
    /** 
     * 토큰 기준 가치 / 배당금 비율
     * 1000 : 1ETH = 1000ETR
     */
    uint16 public constant TOKEN_VALUE = 1000;
    uint16 public constant TOKEN_DIVIDENDS_RATIO = 100;

    /** 
     * 복권 가격
     * 100: 100토큰
     */
    uint16 public constant TICKET_PRICE = 10;

    /** 
     * 복권 당첨 번호 수
     * 1~45 번호 6개 + 보너스 1개(고정/필수)
     */
    uint8 public constant TICKET_ELECTRONS = 7;

    /** 
     * 복권 당첨금 비율
     */
    uint32 public constant TOKEN_DRAWER_REWARD_RATIO = 80;
    uint32 public constant DRAWER_1REWARD_RATIO = 70;
    uint32 public constant DRAWER_2REWARD_RATIO = 15;
    uint32 public constant DRAWER_3REWARD_RATIO = 15;
    uint32 public constant DRAWER_4REWARD_TOKEN = 500;
    uint32 public constant DRAWER_5REWARD_TOKEN = 50;

    /**
     * 복권 추첨/결제 요일
     * 일요일 시작으로 토요일까지 0~6
     * 6: 토요일
     */
    uint8 public constant DAY_OF_DRAWING = 6;
    uint8 public constant DAY_OF_PAYMENT = 1;

    /**
     * 초로 환산
     */
    uint32 public constant SECONDS_OF_MONTH = 2629746;
    uint32 public constant SECONDS_OF_DAY = 86400;

}