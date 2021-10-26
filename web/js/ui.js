const core = new EtherottoCore();

function unlockAccount() {
    var address = document.getElementById("inputAddr").value;
    var password = document.getElementById("InputPassword").value;

    console.log("method: request: unlockAccount", address, password);
    core.unlockAccount(address, password, (error, result) => {
        console.log("method: done: unlockAccount", address, password, error, result);

        if (!result) {
            alert(error);
        } else {
            var contractAddr = document.getElementById("contractAddr");
            var accountAddr = document.getElementById("accountAddr");

            contractAddr.innerHTML = core.contractAddress;
            accountAddr.innerHTML = address;
        }
    });
}

function buyToken() {
    var address = document.getElementById("inputAddr").value;
    var tokenAmount = document.getElementById("buy-token-amount").value;

    console.log("method: request: buyToken", address, tokenAmount);
    core.buyToken(address, tokenAmount, (error, result) => {
        console.log("method: done: buyToken", address, tokenAmount, error, result);

        if (error != null) {
            alert(error);
        } else {
            alert("구매되었습니다.");
            // web3.js contract 이벤트 처리
        }
    });
}

function exchange() {
    var address = document.getElementById("inputAddr").value;
    var tokenAmount = document.getElementById("exchange-token-amount").value;

    console.log("method: request: exchange", address, tokenAmount);
    core.exchange(address, tokenAmount, (error, result) => {
        console.log("method: done: exchange", address, tokenAmount, error, result);

        if (error != null) {
            alert(error);
        } else {
            alert("환전되었습니다.");
            // web3.js contract 이벤트 처리
        }
    });
}

function getTokenBalance() {
    var address = document.getElementById("inputAddr").value;

    console.log("method: request: getTokenBalance", address);
    core.getTokenBalance(address, (error, result) => {
        console.log("method: done: getTokenBalance", address, error, result);

        if (error != null) {
            alert(error);
        } else {
            var myTokenBalance = document.getElementById("myTokenBalance");
            myTokenBalance.innerHTML = result;
        }
    });
}

function getEtherBalance() {
    var address = document.getElementById("inputAddr").value;
    var myEtherBalance = document.getElementById("myEtherBalance");

    console.log("method: request: getTokenBalance", address);
    core.web3.eth.getBalance(address, (error, result) => {
        console.log("method: done: getTokenBalance", address, error, result);

        if (error != null) {
            alert(error);
        } else {
            myEtherBalance.innerHTML = result;
        }
    });
}

function buyTicket() {
    var address = document.getElementById("inputAddr").value;
    var electrons = [];

    for (var i = 0; i < 7; i++) {
        electrons[i] = parseInt(document.getElementsByName("basic-addon")[i].value);
    }

    console.log("method: request: buyTicket", address, electrons);
    core.buyTicket(address, electrons, (error, result) => {
        console.log("method: done: buyTicket", address, electrons, error, result);

        if (error != null) {
            alert(error);
        } else {

            let temp_html = `
                <div class="card">
                    <div class="card-body" id="my-manual-lottery-ticket-01">
                        ${electrons}
                        </div>
                </div>
                `;
            $('#cards-box').append(temp_html);
        }
    });
}

function buyTicketAuto() {
    var address = document.getElementById("inputAddr").value;

    console.log("method: request: buyTicketAuto", address);
    core.buyTicketAuto(address, (error, result) => {
        console.log("method: done: buyTicketAuto", address, error, result);

        if (error != null) {
            alert(error);
        } else {
            // TODO: 요청 보낸 후 처리
            var myInfo = getMyInfo();
        }
    });
}

// TODO:
function subscribe() {
    var address = document.getElementById("inputAddr").value;
    // var month = null;

    console.log("method: request: subscribe", address, month);
    core.subscribe(address, month, (error, result) => {
        console.log("method: done: subscribe", address, month, error, result);

        if (error != null) {
            alert(error);
        } else {
            // TODO: 요청 보낸 후 처리
        }
    });
}

function unsubscribe() {
    var address = document.getElementById("inputAddr").value;

    console.log("method: request: unsubscribe", address);
    core.unsubscribe(address, (error, result) => {
        console.log("method: done: unsubscribe", address, error, result);

        if (error != null) {
            alert(error);
        } else {
            // TODO: 요청 보낸 후 처리
        }
    });
}

function getRoundNumber() {
    var address = document.getElementById("inputAddr").value;
    console.log("method: request: getRoundNumber", address);

    var round = -1;
    try {
        var result = core.getRoundNumber(address);
        round = result.toNumber();
    } catch (error) {
        alert(error);
    }
    console.log("method: done: getRoundNumber", address, result);

    if (round < 0) {
        throw Exception("variable `round` is not valid");
    }
    
    return round;
}

// TODO:
function getRoundInfo() {
    var address = document.getElementById("inputAddr").value;
    // var round = null;
    var round = getRoundNumber();

    console.log("method: request: getRoundInfo", address, round);
    core.getRoundInfo(address, round, (error, result) => {
        console.log("method: done: getRoundInfo", address, round, error, result);
        
        if (error != null) {
            alert(error);
        } else {
            // TODO: 요청 보낸 후 처리
        }
    });
}

function getMyInfo() {
    var address = document.getElementById("inputAddr").value;
    var round = getRoundNumber();
    console.log("method: request: getMyInfo", address, round);
    core.getMyInfo(address, round, (error, result) => {
        console.log("method: done: getMyInfo", address, round, error, result);

        if (error != null) {
            alert(error);
        } else {
            var resultJSON = result;
            console.log("result : ", result, "resultJSON : ", resultJSON);
        }
    });
}

function paySubscribe() {
    var address = document.getElementById("inputAddr").value;

    console.log("method: request: paySubscribe", address);
    core.paySubscribe(address, (error, result) => {
        console.log("method: done: paySubscribe", address, error, result);

        if (error != null) {
            alert(error);
        } else {
            // TODO: 요청 보낸 후 처리
        }
    });
}

function drawTickets() {
    var address = document.getElementById("inputAddr").value;
    
    console.log("method: request: drawTickets", address);
    core.drawTickets(address, (error, result) => {
        console.log("method: done: drawTickets", address, error, result);

        if (error != null) {
            alert(error);
        } else {
            // TODO: 요청 보낸 후 처리
        }
    });
}

jQuery(function () {
    // 페이지 로드 후 실행
});
