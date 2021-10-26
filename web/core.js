var Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const contractABI = [{"inputs":[{"internalType":"uint256","name":"_tokenInitAmount","type":"uint256"}],"payable":true,"stateMutability":"payable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"}],"name":"BuyTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"DrawTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"uint256","name":"since","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"to","type":"uint256"}],"name":"Subscribe","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"uint256","name":"since","type":"uint256"}],"name":"Unsubscribe","type":"event"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"constant":true,"inputs":[],"name":"DAY_OF_DRAWING","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DAY_OF_PAYMENT","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_1REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_2REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_3REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_4REWARD_TOKEN","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DRAWER_5REWARD_TOKEN","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"SECONDS_OF_DAY","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"SECONDS_OF_MONTH","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TICKET_ELECTRONS","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TICKET_PRICE","outputs":[{"internalType":"uint16","name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_DRAWER_REWARD_RATIO","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_VALUE","outputs":[{"internalType":"uint16","name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint8[7]","name":"_electrons","type":"uint8[7]"}],"name":"buyTicket","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"buyTicketAuto","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_tokenAmount","type":"uint256"}],"name":"buyToken","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"drawTickets","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_tokenAmount","type":"uint256"}],"name":"exchange","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getMyInfo","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"_round","type":"uint256"}],"name":"getRoundInfo","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getRoundNumber","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getTokenBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ownerAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"paySubscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_month","type":"uint256"}],"name":"subscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"unsubscribe","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}];
const contractAddress = "0x3E9c8D893b80Fe842c7c6bf8E38C8919D6C5D48D";
const gasValue = 3000000;

var contract = web3.eth.contract(contractABI);
var etherotto = contract.at(contractAddress);

var accounts = web3.eth.accounts;
console.log(accounts)

/**
 * 계정 잠금을 해제합니다.
 * 
 * `address` string : 계정 주소
 * `password` string : 계정 패스워드
 * 
 * `callback` function(error) : 콜백 함수
 */
function unlockAccount() {
    var address = document.getElementById("inputAddr").value;
    var password = document.getElementById("InputPassword").value;
    console.log(address, password)
    web3.personal.unlockAccount(address, password);
    var contractAddr = document.getElementById("contractAddr");
    contractAddr.innerHTML = contractAddress
    var accountAddr = document.getElementById("accountAddr");
    accountAddr.innerHTML = address
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
    var address = document.getElementById("inputAddr").value;
    var tokenAmount = document.getElementById("buy-token-amount").value;
    console.log(tokenAmount)
    var tokenAmount_toWei = tokenAmount * 1000000000000000000;
    console.log(tokenAmount_toWei)
    etherotto.buyToken(tokenAmount_toWei, {
        from: address, 
        gas: gasValue, 
        value: tokenAmount_toWei
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
    var address = document.getElementById("inputAddr").value;
    var tokenAmount = document.getElementById("exchange-token-amount").value;
    console.log(tokenAmount)
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
    var address = document.getElementById("inputAddr").value;
    var TokenBalance = etherotto.getTokenBalance({
        from: address,
        gas: gasValue
    }, callback);
    var myTokenBalance = document.getElementById("myTokenBalance");
    myTokenBalance.innerHTML = TokenBalance;
    console.log(TokenBalance);
}

/**
 * 현재 계정의 이더 잔액을 반환합니다.
 *
 * `address` string : 계정 주소
 *
 * `callback` function(error, token) : 콜백 함수
 */
function getEtherBalance(address, callback) {
    var address = document.getElementById("inputAddr").value;
    var EtherBalance = web3.eth.getBalance(address);
    var myEtherBalance = document.getElementById("myEtherBalance");
    myEtherBalance.innerHTML = EtherBalance;
    console.log(EtherBalance);
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
    var address = document.getElementById("inputAddr").value;
    var electrons = [];
    var input_string = [];


    for (var i = 0; i < 7; i++) {
        input_string[i] = document.getElementsByName("basic-addon")[i].value;
        electrons[i] = parseInt(input_string[i]);
    }
    console.log(input_string)
    console.log(electrons);

    etherotto.buyTicket(electrons, {
        from: address,
        gas: gasValue
    }, callback);

    // 나의 수동 복권에 붙이기
    // var boughtTicket = document.getElementById("my-manual-lottery-ticket-01");
    // boughtTicket.innerHTML = electrons

    let temp_html = `
                    <div class="card">
                        <div class="card-body" id="my-manual-lottery-ticket-01">
                            ${electrons}
                          </div>
                    </div>
                    `;
    $('#cards-box').append(temp_html);

}

/**
 * 현재 계정에서 자동 복권 구매를 합니다.
 * 
 * `address` string : 계정 주소
 * 
 * `callback` function(error) : 콜백 함수
 */
function buyTicketAuto(address, callback) {
    var address = document.getElementById("inputAddr").value;

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
