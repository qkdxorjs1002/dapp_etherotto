web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const contractABI = [{"inputs":[{"internalType":"uint256","name":"_tokenInitAmount","type":"uint256"}],"payable":true,"stateMutability":"payable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"}],"name":"BuyTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"DrawTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"uint256","name":"since","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"to","type":"uint256"}],"name":"Subscribe","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"uint256","name":"since","type":"uint256"}],"name":"Unsubscribe","type":"event"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"constant":true,"inputs":[],"name":"DAY_OF_DRAWING","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DAY_OF_PAYMENT","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_1REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_2REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_3REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_4REWARD_TOKEN","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_5REWARD_TOKEN","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"SECONDS_OF_DAY","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"SECONDS_OF_MONTH","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TICKET_ELECTRONS","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TICKET_PRICE","outputs":[{"internalType":"uint16","name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_DRAWER_REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_VALUE","outputs":[{"internalType":"uint16","name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint8[7]","name":"_electrons","type":"uint8[7]"}],"name":"buyTicket","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"buyTicketAuto","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_tokenAmount","type":"uint256"}],"name":"buyToken","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"drawTickets","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_tokenAmount","type":"uint256"}],"name":"exchange","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getMyInfo","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"_round","type":"uint256"}],"name":"getRoundInfo","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getRoundNumber","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getTokenBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ownerAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"paySubscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_month","type":"uint256"}],"name":"subscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"unsubscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}];
const contractAddress = "";
const gasValue = 3000000;

var contract = web3.eth.contract(contractABI);
var etherotto = contract.at(contractAddress);

var accounts = web3.eth.accounts;

/**
 * 계정 잠금을 해제합니다.
 * 
 * `address` string : 계정 주소
 * `password` string : 계정 패스워드
 * 
 * `callback` function(error) : 콜백 함수
 */
function unlockAccount(address, password, callback) {
    web3.eth.personal.unlockAccount(address, password, gasValue, callback);
}

/**
 * 이더로 토큰을 구매합니다.
 * 
 * `address` string : 계정 주소
 * `tokenAmount` integer : 구매할 토큰 수 (TOKEN_VALUE 에 따라 가치 환산)
 * 
 * `callback` function(error) : 콜백 함수
 */
function buyToken(address, tokenAmount, callback) {
    etherotto.buyToken(tokenAmount, { 
        from: address, 
        gas: gasValue, 
        value: web3.toWei(1, "ether") * tokenAmount 
    }, callback);
}

/**
 * 토큰을 이더로 환전합니다.
 * 
 * `address` string : 계정 주소
 * `tokenAmount` integer : 환전할 토큰 수 (TOKEN_VALUE 에 따라 가치 환산)
 * 
 * `callback` function(error) : 콜백 함수
 */
function exchange(address, tokenAmount, callback) {
    etherotto.exchange(tokenAmount, {
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 현재 계정의 토큰 잔액을 반환합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error, token) : 콜백 함수
 */
function getTokenBalance(address, callback) {
    etherotto.getTokenBalance({
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 현재 계정에서 수동 복권 구매를 합니다.
 * 
 * `address` string : 계정 주소
 * `electrons` array<integer> : 복권 번호이며 7자리 (1 ~ 45)
 * 
 * `callback` function(error) : 콜백 함수
 */
function buyTicket(address, electrons, callback) {
    etherotto.buyTicket(electrons, {
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 현재 계정에서 자동 복권 구매를 합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error) : 콜백 함수
 */
function buyTicketAuto(address, callback) {
    etherotto.buyTicketAuto({
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 현재 계정에서 정기 결제를 구독합니다.
 * 
 * `address` string : 계정 주소
 * `month` integer : 구독 개월
 * 
 * `callback` function(error) : 콜백 함수
 */
function subscribe(address, month, callback) {
    etherotto.subscribe(month, {
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 현재 계정에서 정기 결제 구독을 해제합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error) : 콜백 함수
 */
function unsubscribe(address, callback) {
    etherotto.unsubscribe({
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 현재 Etherotto 회차의 번호를 반환합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error, round) : 콜백 함수
 */
function getRoundNumber(address, callback) {
    etherotto.getRoundNumber({
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 이전 Etherotto 회차의 모든 정보를 반환합니다.
 * 
 * `address` string : 계정 주소
 * `round` integer : 회차 번호 (1부터 시작)
 * 
 * `callback` function(error, Object) : 콜백 함수
 */
function getRoundInfo(address, round, callback) {
    etherotto.getRoundInfo(round - 1, {
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * 현재 계정의 모든 정보를 JSON 형태로 반환합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error, Object) : 콜백 함수
 */
function getMyInfo(address, callback) {
    etherotto.getMyInfo({
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * (계약 소유자 전용) 구독한 유저들에게 계약에 설정된 DAY_OF_PAYMENT에 따라 특정 요일에 buyTicketAuto를 실행하여 복권을 할당합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error) : 콜백 함수
 */
function paySubscribe(address, callback) {
    etherotto.paySubscribe({
        from: address,
        gas: gasValue
    }, callback);
}

/**
 * (계약 소유자 전용) 구독한 유저들에게 계약에 설정된 DAY_OF_DRAWING에 따라 특정 요일에 당첨 번호를 추첨하고 비교하여 수상자에게 토큰을 수여합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error) : 콜백 함수
 */
function drawTickets(address, callback) {
    etherotto.drawTickets({
        from: address,
        gas: gasValue
    }, callback);
}

jQuery(function () {
    // 페이지 로드 후 실행
});
