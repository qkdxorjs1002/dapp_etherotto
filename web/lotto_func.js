
const sevenNumsArr = generateSevenNums();


// 6개의 정렬된 로또번호와 보너스 번호 1개 해서 총 7개의 번호를 배열로 반환하는 함수
function generateSevenNums() {
    let numSet = new Set();
    while (numSet.size < 7) { // numSet에 유니크한 숫자 7개가 될때까지 숫자뽑기를 반복 수행
        let num = Math.floor((Math.random() * 45)) + 1;
        numSet.add(num);
    }   // while문이 끝나면 7개 번호는 이미 생성 완료
        // 아래 나머지 과정들은 보너스 번호를 맨 뒤로 빼내고
        // 6개 번호를 정렬하는 작업

    let resultArr = Array.from(numSet);	// from(): Map,Set 등 iterable 객체로부터 배열 객체 생성
    let bonusNum = resultArr.pop(); // 맨 마지막의 보너스 번호를 임시로 배열에서 빼냄

    resultArr.sort(function (a, b) {
        return a - b;
    });  // 나머지 6개 숫자가 든 배열을 정렬 후
    resultArr.push(bonusNum);       // 따로 빼놓았던 보너스 번호를 배열 맨 끝에 다시 추가
    return resultArr;  // 결과적으로는 오름차순 정렬된 6개 로또 번호와 맨 마지막의 보너스 번호가 배열에 딱 세팅!
}

// 출처 https://m.blog.naver.com/misschip/221841169049