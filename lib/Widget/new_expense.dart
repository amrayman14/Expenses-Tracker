import 'package:flutter/material.dart';
import 'package:new_expenses_tracker/Model/expense.dart';

class NewExpense extends StatefulWidget {
    NewExpense({required this.expenseAdder,super.key});
  void Function(Expense expense) expenseAdder;
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
   Category _selectedCategory = Category.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 1, now.month, now.day);
    var lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }
  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (
    _titleController.text.trim().isEmpty ||
        _selectedDate == null || amountIsInvalid){
      showDialog(context: context,
          builder: (ctx) => AlertDialog(
            title:const Text('Invalid Input'),
            content:const Text('please make sure the title, amount, date and category was enterd '),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(ctx);
            }, child:const Text('Okay'))
          ],
          )
      );
      return;
    }
    else{

          widget.expenseAdder(Expense(
            title: _titleController.text.trim(),
            amount: enteredAmount,
            date: _selectedDate!,
            category: _selectedCategory,

          ),
          );
        Navigator.pop(context);
    }
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx,constrains){
      final width = constrains.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16,16 ,16,keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                           width: 10,
                      ),
                       Expanded(
                         child: TextField(
                            controller: _amountController,
                            maxLength: 50,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixText: '\$ ', label: Text('Amount')),
                          ),
                       ),

                    ],
                  )
                else
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Title'),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                if (width >= 600)
                  Row(children: [
                    DropdownButton(
                        value: _selectedCategory,
                        items: Category.values.map(
                              (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ),
                        ).toList(),
                        onChanged: (value){
                          if (value == null)
                          {return;}
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                    ),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No Date selected'
                                  : formatted.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                    ),
                  ],)
                else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        maxLength: 50,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            prefixText: '\$ ', label: Text('Amount')),
                      ),
                    ),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No Date selected'
                                  : formatted.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 10,),
                if (width >= 600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
                else
                Row(
                  children: [
                    DropdownButton(
                        value: _selectedCategory,
                        items: Category.values.map(
                              (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ),
                        ).toList(),
                        onChanged: (value){
                          if (value == null)
                          {return;}
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                    ),
                    const SizedBox(width: 85),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });

  }
}
