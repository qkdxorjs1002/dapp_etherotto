import * as core from "./core.js";

function unlockAccount() {
    var address = document.getElementById("inputAddr").value;
    var password = document.getElementById("InputPassword").value;

    console.log(address, password);
    core.unlockAccount(address, password);

    var contractAddr = document.getElementById("contractAddr");
    var accountAddr = document.getElementById("accountAddr");

    contractAddr.innerHTML = core.contractAddress;
    accountAddr.innerHTML = core.address;
}

function buyToken() {
    var address = document.getElementById("inputAddr").value;
    var tokenAmount = document.getElementById("buy-token-amount").value;

    console.log(address, tokenAmount);
    core.buyToken(address, tokenAmount, () => {
        console.log("method: done: buyToken");
    });
}

function exchange() {
    var address = document.getElementById("inputAddr").value;
    var tokenAmount = document.getElementById("exchange-token-amount").value;

    console.log(tokenAmount)
    core.exchange(address, tokenAmount, () => {
        console.log("method: done: exchange");
    });
}

function getTokenBalance() {
    var address = document.getElementById("inputAddr").value;

    core.getTokenBalance(address, (value) => {
        var myTokenBalance = document.getElementById("myTokenBalance");
        myTokenBalance.innerHTML = value;
        console.log(value);
    });
}

function getEtherBalance() {
    var address = document.getElementById("inputAddr").value;
    var myEtherBalance = document.getElementById("myEtherBalance");

    const etherBalance = web3.eth.getBalance(address);
    myEtherBalance.innerHTML = etherBalance;
    console.log(etherBalance);
}

function buyTicket() {
    var address = document.getElementById("inputAddr").value;
    var electrons = [];
    var input_string = [];

    for (var i = 0; i < 7; i++) {
        input_string[i] = document.getElementsByName("basic-addon")[i].value;
        electrons[i] = parseInt(input_string[i]);
    }
    console.log(input_string);
    console.log(electrons);

    core.buyTicket(address, electrons, () => {
        console.log("method: done: buyTicket");
    });

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

function buyTicketAuto() {
    var address = document.getElementById("inputAddr").value;

    core.buyTicketAuto(address, () => {
        console.log("method: done: buyTicketAuto");
    });
}

// TODO:
function subscribe() {
    var address = document.getElementById("inputAddr").value;
    // var month = null;

    core.subscribe(address, month, () => {
        console.log("method: done: subscribe");
    });
}

function unsubscribe() {
    var address = document.getElementById("inputAddr").value;

    core.unsubscribe(address, () => {
        console.log("method: done: unsubscribe");
    });
}

function getRoundNumber() {
    var address = document.getElementById("inputAddr").value;

    core.getRoundNumber(address, (value) => {
        console.log("method: done: getRoundNumber", value);
    });
}

// TODO:
function getRoundInfo() {
    var address = document.getElementById("inputAddr").value;
    // var round = null;
    
    core.getRoundInfo(address, round, (value) => {
        console.log("method: done: getRoundInfo", value);
    });
}

function getMyInfo() {
    var address = document.getElementById("inputAddr").value;
    
    core.getMyInfo(address, round, (value) => {
        console.log("method: done: getMyInfo", value);
    });
}

function paySubscribe() {
    var address = document.getElementById("inputAddr").value;

    core.paySubscribe(address, () => {
        console.log("method: done: paySubscribe");
    });
}

function drawTickets() {
    var address = document.getElementById("inputAddr").value;
    
    core.drawTickets(address, () => {
        console.log("method: done: drawTickets");
    });
}

jQuery(function () {
    // 페이지 로드 후 실행
});
