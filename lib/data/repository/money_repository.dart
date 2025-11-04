import 'package:money_app/data/db/transaction_dao.dart';
import 'package:money_app/data/model/transaction.dart';

class MoneyRepository {
  final moneyDao = TransactionDao();

  Future<int> insertTransaction(Transaction transaction) async {
    return await moneyDao.insertTransaction(transaction);
  }

  Future<List<Transaction>> getAllTransactions() async {
    return await moneyDao.getAllTransactions();
  }

  Future<double> getBalance() async {
    return await moneyDao.getBalance();
  }

  Future<int> updateTransaction(int id, Transaction transaction) async {
    return await moneyDao.updateTransaction(id, transaction);
  }

  Future<int> deleteTransaction(int id) async {
    return await moneyDao.deleteTransaction(id);
  }

  Future<double> getIncome() async {
    return await moneyDao.getIncome();
  }

  Future<double> getExpense() async {
    return await moneyDao.getExpense();
  }
}