// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Цифровой рубль Ямайки
contract JDR {

  // Число выпущенных рублей
  uint256 totalSupply;
  // Процент налога
  uint8 taxRate;
  // Процент начисления
  uint256 accrualRate;
  // Адресс владельца волюты
  address public owner;

  // Структура для баланса пользователя
  // amount - сумма денег
  // isBlocked - заблокирован ли счет
  struct Balance {
    uint256 amount;
    bool isBlocked;
  }

  // Отобрадение адрессов и балансов
  mapping (address => Balance) public balances;

  // Проверяет, является ли отправитель владельцем
  modifier isOwner() {
    require(msg.sender == owner, "Caller is not owner");
    _;
  }

  // Проверяет, не является ли пользователь владельцем
  modifier isNotOwner(address user) {
    require(user != owner, "User is owner");
    _;
  }

  // Проверяет, достаточно ли у отправителя денег в балансе
  modifier isEnoughRubles(uint256 amount) {
    require(balances[msg.sender].amount >= amount, "Caller does not have enough rubles");
    _;
  }

  // Проверяет, одно ли лицо отправитель и получатель
  modifier isSenderEqualsToReciever(address reciever) {
    require(msg.sender != reciever, "Caller try to send rubles to himself");
    _;
  }

  // Проверяет, не заблокирован ли пользователь
  modifier isNotBlocked(address user) {
    require(!balances[user].isBlocked, "User is blocked");
    _;
  }

  // Проверяет, не заблокирован ли пользователь
  modifier isEnoughReserveForAccrual(address user) {
    uint256 accrual = balances[user].amount / 100 * accrualRate;
    require(balances[owner].amount >= accrual, "Owner does not have enough rubles for accrual");
    _;
  }

  // Событие выпуска цифровых Ямайских рублей
  event Minted(address who, uint256 amount);

  // Событие блокировки пользователя
  event Blocked(address who);

  // Событие разблокировки пользователя
  event Unblocked(address who);

  constructor() {
    owner = msg.sender;
    taxRate = 5;
    accrualRate = 5;
  }

  // Функция выпуска цифровых ямайских рублей
  function mint(uint256 amount) public isOwner {
    totalSupply += amount;
    balances[msg.sender].amount += amount;
    emit Minted(msg.sender, amount);
  }

  // Функция перевода рублей
  // Если сумма перевода больше 100, берется 5% налог
  function transfer(address reciever, uint256 amount) public
  isEnoughRubles(amount)
  isSenderEqualsToReciever(reciever)
  isNotBlocked(msg.sender)
  isNotBlocked(reciever) {
    uint256 tax;
    if(amount <= 100 || msg.sender == owner) {
      tax = 0;
    } else {
      tax = amount / 100 * taxRate;
    }
    balances[msg.sender].amount -= amount;
    balances[reciever].amount += (amount - tax);
    balances[owner].amount += tax;
  }

  // Функция блокировки пользователя
  function blockUser(address user) public
  isOwner
  isNotOwner(user) {
    balances[user].isBlocked = true;
    emit Blocked(user);
  }

  // Функция разблокировки пользователя
  function unblockUser(address user) public
  isOwner
  isNotOwner(user) {
    balances[user].isBlocked = false;
    emit Unblocked(user);
  }

  // Функция конфискации денег
  function confiscation(address user, uint256 amount) public
  isOwner
  isNotOwner(user) {
    if(balances[user].amount < amount) {
      balances[owner].amount += balances[user].amount;
      balances[user].amount = 0;
    } else {
      balances[owner].amount += amount;
      balances[user].amount -= amount;
    }
  }

  // Функция начисления денег на балансе
  function accrualPersents(address user) public
  isOwner
  isNotOwner(user)
  isNotBlocked(user)
  isEnoughReserveForAccrual(user) {
    uint256 accrual = balances[user].amount / 100 * accrualRate;
    balances[user].amount += accrual;
    balances[owner].amount -= accrual;
  }
}