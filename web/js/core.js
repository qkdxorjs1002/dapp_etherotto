class EtherottoCore {

    constructor() {
        const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

        const contractABI = [{"inputs":[{"internalType":"uint256","name":"_tokenInitAmount","type":"uint256"}],"payable":true,"stateMutability":"payable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"}],"name":"BuyTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"DrawTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"uint256","name":"since","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"to","type":"uint256"}],"name":"Subscribe","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"uint256","name":"since","type":"uint256"}],"name":"Unsubscribe","type":"event"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"constant":true,"inputs":[],"name":"DAY_OF_DRAWING","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DAY_OF_PAYMENT","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_1REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_2REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_3REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_4REWARD_TOKEN","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_5REWARD_TOKEN","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"SECONDS_OF_DAY","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"SECONDS_OF_MONTH","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TICKET_ELECTRONS","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TICKET_PRICE","outputs":[{"internalType":"uint16","name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_DRAWER_REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_VALUE","outputs":[{"internalType":"uint16","name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint8[7]","name":"_electrons","type":"uint8[7]"}],"name":"buyTicket","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"buyTicketAuto","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_tokenAmount","type":"uint256"}],"name":"buyToken","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"drawTickets","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_tokenAmount","type":"uint256"}],"name":"exchange","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getMyInfo","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"_round","type":"uint256"}],"name":"getRoundInfo","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getRoundNumber","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getTokenBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ownerAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"paySubscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_month","type":"uint256"}],"name":"subscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"unsubscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}];
        const contractAddress = "0x58c55E79e625592c4B60484034B679280724e68C";
        const gasValue = 3000000;

        const contract = web3.eth.contract(contractABI);
        const etherotto = contract.at(contractAddress);
        const accounts = web3.eth.accounts;
        const tokenValue = etherotto.TOKEN_VALUE();

        this.web3 = web3;
        this.contractAddress = contractAddress;
        this.gasValue = gasValue;
        this.etherotto = etherotto;
        this.accounts = accounts;
        this.tokenValue = tokenValue;
    }

    /**
     * 계정 잠금을 해제합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `password` string : 계정 패스워드
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    unlockAccount(address, password, callback) {
        return this.web3.personal.unlockAccount(address, password, this.gasValue, callback);
    }

    /**
     * 이더로 토큰을 구매합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `tokenAmount` integer : 구매할 토큰 수 (TOKEN_VALUE 에 따라 가치 환산)
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    buyToken(address, tokenAmount, callback) {
        return this.etherotto.buyToken(tokenAmount, { 
            from: address, 
            gas: this.gasValue, 
            value: this.web3.toWei(tokenAmount / this.tokenValue, "ether")
        }, callback);
    }

    /**
     * 토큰을 이더로 환전합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `tokenAmount` integer : 환전할 토큰 수 (TOKEN_VALUE 에 따라 가치 환산)
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    exchange(address, tokenAmount, callback) {
        return this.etherotto.exchange(tokenAmount, {
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 현재 계정의 토큰 잔액을 반환합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    getTokenBalance(address, callback) {
        return this.etherotto.getTokenBalance({
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 현재 계정에서 수동 복권 구매를 합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `electrons` array<integer> : 복권 번호이며 7자리 (1 ~ 45)
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    buyTicket(address, electrons, callback) {
        return this.etherotto.buyTicket(electrons, {
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 현재 계정에서 자동 복권 구매를 합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    buyTicketAuto(address, callback) {
        return this.etherotto.buyTicketAuto({
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 현재 계정에서 정기 결제를 구독합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `month` integer : 구독 개월
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    subscribe(address, month, callback) {
        return this.etherotto.subscribe(month, {
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 현재 계정에서 정기 결제 구독을 해제합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    unsubscribe(address, callback) {
        return this.etherotto.unsubscribe({
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 현재 Etherotto 회차의 번호를 반환합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    getRoundNumber(address, callback) {
        return this.etherotto.getRoundNumber({
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 이전 Etherotto 회차의 모든 정보를 반환합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `round` integer : 회차 번호 (1부터 시작)
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    getRoundInfo(address, round, callback) {
        return this.etherotto.getRoundInfo(round - 1, {
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * 현재 계정의 모든 정보를 JSON 형태로 반환합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    getMyInfo(address, callback) {
        return this.etherotto.getMyInfo({
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * (계약 소유자 전용) 구독한 유저들에게 계약에 설정된 DAY_OF_PAYMENT에 따라 특정 요일에 buyTicketAuto를 실행하여 복권을 할당합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    paySubscribe(address, callback) {
        return this.etherotto.paySubscribe({
            from: address,
            gas: this.gasValue
        }, callback);
    }

    /**
     * (계약 소유자 전용) 구독한 유저들에게 계약에 설정된 DAY_OF_DRAWING에 따라 특정 요일에 당첨 번호를 추첨하고 비교하여 수상자에게 토큰을 수여합니다.
     * 
     * `address` string : 계정 주소
     * 
     * `callback` function (error, result)
     * 
     * `return` Promise<?>
     */
    drawTickets(address, callback) {
        return this.etherotto.drawTickets({
            from: address,
            gas: this.gasValue
        }, callback);
    }
}